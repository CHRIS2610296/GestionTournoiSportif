package com.tournoi.dao;
import com.tournoi.model.Equipe; import com.tournoi.model.Match; import java.sql.*; import java.util.*;
public class MatchDAO {
    public void ajouterMatch(int idDom, int idExt) {
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement("INSERT INTO match_tournoi (equipe_dom_id, equipe_ext_id) VALUES (?, ?)")) {
            stmt.setInt(1, idDom); stmt.setInt(2, idExt); stmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    public void genererChampionnat(List<Equipe> equipes) {
        for (int i = 0; i < equipes.size(); i++) { for (int j = i + 1; j < equipes.size(); j++) { ajouterMatch(equipes.get(i).getId(), equipes.get(j).getId()); } }
    }
    public void genererKnockout(List<Equipe> equipes) {
        // On mélange les équipes pour un tirage au sort aléatoire
        Collections.shuffle(equipes);
        
        // On les associe 2 par 2 pour le Tour 1
        for (int i = 0; i < equipes.size() - 1; i += 2) {
            ajouterMatchKO(equipes.get(i).getId(), equipes.get(i+1).getId(), 1);
        }
    }
    public void enregistrerScore(int idMatch, int scoreDom, int scoreExt) {
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement("UPDATE match_tournoi SET score_dom=?, score_ext=?, statut='Terminé' WHERE id=?")) {
            stmt.setInt(1, scoreDom); stmt.setInt(2, scoreExt); stmt.setInt(3, idMatch); stmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    public List<Match> listerMatchsParTournoi(int idTournoi) {
        List<Match> liste = new ArrayList<>();
        String sql = "SELECT m.id, m.score_dom, m.score_ext, m.statut, e1.nom AS dom, e2.nom AS ext FROM match_tournoi m JOIN equipe e1 ON m.equipe_dom_id = e1.id JOIN equipe e2 ON m.equipe_ext_id = e2.id WHERE e1.id_tournoi=?";
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idTournoi); ResultSet rs = stmt.executeQuery();
            while(rs.next()) { Match m = new Match(); m.setId(rs.getInt("id")); m.setScoreDom(rs.getInt("score_dom")); m.setScoreExt(rs.getInt("score_ext")); m.setStatut(rs.getString("statut")); m.setNomEquipeDom(rs.getString("dom")); m.setNomEquipeExt(rs.getString("ext")); liste.add(m); }
        } catch (Exception e) { e.printStackTrace(); } return liste;
    }
 // On ajoute le paramètre tourNumero
    public void ajouterMatchKO(int idDom, int idExt, int tourNumero) {
        String sql = "INSERT INTO match_tournoi (equipe_dom_id, equipe_ext_id, tour_numero, statut) VALUES (?, ?, ?, 'A jouer')";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idDom);
            stmt.setInt(2, idExt);
            stmt.setInt(3, tourNumero);
            stmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    public void verifierEtGenererTourSuivant(int idTournoi) {
        // 1. Trouver le tour actuel (le plus grand numéro de tour)
        int tourActuel = 1;
        String sqlMaxTour = "SELECT MAX(tour_numero) FROM match_tournoi m JOIN equipe e ON m.equipe_dom_id = e.id WHERE e.id_tournoi = ?";
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sqlMaxTour)) {
            stmt.setInt(1, idTournoi);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) tourActuel = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); return; }

        // 2. Vérifier s'il reste des matchs "A jouer" dans ce tour
        String sqlCheck = "SELECT COUNT(*) FROM match_tournoi m JOIN equipe e ON m.equipe_dom_id = e.id WHERE e.id_tournoi = ? AND m.tour_numero = ? AND m.statut != 'Terminé'";
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sqlCheck)) {
            stmt.setInt(1, idTournoi);
            stmt.setInt(2, tourActuel);
            ResultSet rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return; // Il reste des matchs à jouer, on arrête là !
            }
        } catch (Exception e) { e.printStackTrace(); return; }

        // 3. Si tout est terminé, on récupère les gagnants du tour actuel
        List<Integer> vainqueurs = new ArrayList<>();
        String sqlGagnants = "SELECT equipe_dom_id, equipe_ext_id, score_dom, score_ext FROM match_tournoi m JOIN equipe e ON m.equipe_dom_id = e.id WHERE e.id_tournoi = ? AND m.tour_numero = ?";
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sqlGagnants)) {
            stmt.setInt(1, idTournoi);
            stmt.setInt(2, tourActuel);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int scoreDom = rs.getInt("score_dom");
                int scoreExt = rs.getInt("score_ext");
                // On ajoute l'ID de l'équipe qui a marqué le plus de buts
                if (scoreDom > scoreExt) {
                    vainqueurs.add(rs.getInt("equipe_dom_id"));
                } else if (scoreExt > scoreDom) {
                    vainqueurs.add(rs.getInt("equipe_ext_id"));
                } else {
                    // Pour un projet simple, en cas d'égalité, l'équipe à domicile passe (ou on tire au sort)
                    vainqueurs.add(rs.getInt("equipe_dom_id"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }

        // 4. On génère le tour suivant avec les vainqueurs
        if (vainqueurs.size() >= 2) {
            for (int i = 0; i < vainqueurs.size() - 1; i += 2) {
                ajouterMatchKO(vainqueurs.get(i), vainqueurs.get(i+1), tourActuel + 1);
            }
        }
    }
 // NOUVELLE MÉTHODE : Trouver le vainqueur d'un tournoi à élimination
    public Equipe getVainqueurKnockout(int idTournoi) {
        int dernierTour = 0;
        
        // 1. Trouver le numéro du dernier tour (ex: Tour 3 = Finale)
        String sqlMax = "SELECT MAX(tour_numero) FROM match_tournoi m JOIN equipe e ON m.equipe_dom_id = e.id WHERE e.id_tournoi = ?";
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sqlMax)) {
            stmt.setInt(1, idTournoi);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) dernierTour = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }

        if (dernierTour == 0) return null;

        // 2. Analyser les matchs de ce dernier tour
        String sqlFinale = "SELECT m.statut, m.score_dom, m.score_ext, m.equipe_dom_id, m.equipe_ext_id " +
                           "FROM match_tournoi m JOIN equipe e ON m.equipe_dom_id = e.id " +
                           "WHERE e.id_tournoi = ? AND m.tour_numero = ?";
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sqlFinale)) {
            stmt.setInt(1, idTournoi);
            stmt.setInt(2, dernierTour);
            ResultSet rs = stmt.executeQuery();

            int nbMatchs = 0;
            Equipe vainqueur = null;

            while (rs.next()) {
                nbMatchs++;
                if ("Terminé".equals(rs.getString("statut"))) {
                    // Trouver qui a gagné ce match
                    int idGagnant = (rs.getInt("score_dom") > rs.getInt("score_ext")) ? rs.getInt("equipe_dom_id") : rs.getInt("equipe_ext_id");
                    
                    // Récupérer les infos de l'équipe gagnante
                    EquipeDAO eqDAO = new EquipeDAO();
                    for(Equipe e : eqDAO.listerParTournoi(idTournoi)) {
                        if(e.getId() == idGagnant) vainqueur = e;
                    }
                } else {
                    return null; // La finale est en cours, pas encore de vainqueur
                }
            }

            // 3. S'il n'y a qu'UN SEUL match (la finale) et qu'elle est terminée
            if (nbMatchs == 1 && vainqueur != null) {
                return vainqueur;
            }
        } catch (Exception e) { e.printStackTrace(); }

        return null;
    }
}