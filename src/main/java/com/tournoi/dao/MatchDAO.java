package com.tournoi.dao;

import com.tournoi.model.Equipe;
import com.tournoi.model.Match;
import java.sql.*;
import java.util.*;

public class MatchDAO {

    // 1. Ajouter un match normal (Championnat) avec une date
    public void ajouterMatch(int idDom, int idExt, String dateMatch) {
        try (Connection conn = DatabaseConnection.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement("INSERT INTO match_tournoi (equipe_dom_id, equipe_ext_id, date_match) VALUES (?, ?, ?)")) {
            stmt.setInt(1, idDom); 
            stmt.setInt(2, idExt); 
            stmt.setString(3, dateMatch); 
            stmt.executeUpdate();
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

    // 2. Ajouter un match à Élimination Directe (avec numéro de tour et date)
    public void ajouterMatchKO(int idDom, int idExt, int tourNumero, String dateMatch) {
        try (Connection conn = DatabaseConnection.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement("INSERT INTO match_tournoi (equipe_dom_id, equipe_ext_id, tour_numero, date_match, statut) VALUES (?, ?, ?, ?, 'A jouer')")) {
            stmt.setInt(1, idDom); 
            stmt.setInt(2, idExt); 
            stmt.setInt(3, tourNumero); 
            stmt.setString(4, dateMatch);
            stmt.executeUpdate();
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

    // 3. Générer le calendrier d'un Championnat
    public void genererChampionnat(List<Equipe> equipes, com.tournoi.model.Tournoi t) {
        for (int i = 0; i < equipes.size(); i++) { 
            for (int j = i + 1; j < equipes.size(); j++) { 
                String dateAssignee = genererDateAleatoire(t.getDateDebut(), t.getDateFin());
                ajouterMatch(equipes.get(i).getId(), equipes.get(j).getId(), dateAssignee); 
            } 
        }
    }

    // 4. Générer le Tour 1 d'un tournoi à Élimination Directe
    public void genererKnockout(List<Equipe> equipes, com.tournoi.model.Tournoi t) {
        Collections.shuffle(equipes);
        for (int i = 0; i < equipes.size() - 1; i += 2) { 
            String dateAssignee = genererDateAleatoire(t.getDateDebut(), t.getDateFin());
            ajouterMatchKO(equipes.get(i).getId(), equipes.get(i+1).getId(), 1, dateAssignee); 
        }
    }

    // 5. Enregistrer le score d'un match joué
    public void enregistrerScore(int idMatch, int scoreDom, int scoreExt) {
        try (Connection conn = DatabaseConnection.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement("UPDATE match_tournoi SET score_dom=?, score_ext=?, statut='Terminé' WHERE id=?")) {
            stmt.setInt(1, scoreDom); 
            stmt.setInt(2, scoreExt); 
            stmt.setInt(3, idMatch); 
            stmt.executeUpdate();
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

    // 6. Lister tous les matchs d'un tournoi
    public List<Match> listerMatchsParTournoi(int idTournoi) {
        List<Match> liste = new ArrayList<>();
        String sql = "SELECT m.id, m.score_dom, m.score_ext, m.statut, m.date_match, e1.nom AS dom, e2.nom AS ext " +
                     "FROM match_tournoi m " +
                     "JOIN equipe e1 ON m.equipe_dom_id = e1.id " +
                     "JOIN equipe e2 ON m.equipe_ext_id = e2.id " +
                     "WHERE e1.id_tournoi=?";
        try (Connection conn = DatabaseConnection.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idTournoi); 
            ResultSet rs = stmt.executeQuery();
            while(rs.next()) { 
                Match m = new Match(); 
                m.setId(rs.getInt("id")); 
                m.setScoreDom(rs.getInt("score_dom")); 
                m.setScoreExt(rs.getInt("score_ext")); 
                m.setStatut(rs.getString("statut")); 
                m.setNomEquipeDom(rs.getString("dom")); 
                m.setNomEquipeExt(rs.getString("ext")); 
                
                // LE FORMATAGE DE LA DATE EN FRANÇAIS :
                String dateBrute = rs.getString("date_match");
                if (dateBrute != null && !dateBrute.isEmpty()) {
                    try {
                        java.time.LocalDate dateFormatee = java.time.LocalDate.parse(dateBrute);
                        java.time.format.DateTimeFormatter formatFrancais = java.time.format.DateTimeFormatter.ofPattern("d MMMM yyyy", java.util.Locale.FRENCH);
                        m.setDateMatch(dateFormatee.format(formatFrancais));
                    } catch (Exception ex) {
                        m.setDateMatch(dateBrute);
                    }
                } else {
                    m.setDateMatch("Date à définir");
                }
                
                liste.add(m); 
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        } 
        return liste;
    }
 
    // 7. L'Algorithme Intelligent : Vérifier et créer le tour suivant
    public void verifierEtGenererTourSuivant(int idTournoi) {
        int tourActuel = 1;
        String sqlMaxTour = "SELECT MAX(tour_numero) FROM match_tournoi m JOIN equipe e ON m.equipe_dom_id = e.id WHERE e.id_tournoi = ?";
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sqlMaxTour)) {
            stmt.setInt(1, idTournoi);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) tourActuel = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); return; }

        String sqlCheck = "SELECT COUNT(*) FROM match_tournoi m JOIN equipe e ON m.equipe_dom_id = e.id WHERE e.id_tournoi = ? AND m.tour_numero = ? AND m.statut != 'Terminé'";
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sqlCheck)) {
            stmt.setInt(1, idTournoi);
            stmt.setInt(2, tourActuel);
            ResultSet rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return; // Il reste des matchs à jouer, on arrête
            }
        } catch (Exception e) { e.printStackTrace(); return; }

        List<Integer> vainqueurs = new ArrayList<>();
        String sqlGagnants = "SELECT equipe_dom_id, equipe_ext_id, score_dom, score_ext FROM match_tournoi m JOIN equipe e ON m.equipe_dom_id = e.id WHERE e.id_tournoi = ? AND m.tour_numero = ?";
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt =prepareStatement(sqlGagnants)) {
            stmt.setInt(1, idTournoi);
            stmt.setInt(2, tourActuel);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int scoreDom = rs.getInt("score_dom");
                int scoreExt = rs.getInt("score_ext");
                if (scoreDom > scoreExt) {
                    vainqueurs.add(rs.getInt("equipe_dom_id"));
                } else if (scoreExt > scoreDom) {
                    vainqueurs.add(rs.getInt("equipe_ext_id"));
                } else {
                    vainqueurs.add(rs.getInt("equipe_dom_id")); 
                }
            }
        } catch (Exception e) { e.printStackTrace(); }

        // Génération du tour suivant avec dates
        if (vainqueurs.size() >= 2) {
            TournoiDAO tournoiDAO = new TournoiDAO();
            com.tournoi.model.Tournoi t = tournoiDAO.getTournoiById(idTournoi);
            
            for (int i = 0; i < vainqueurs.size() - 1; i += 2) {
                String dateAssignee = genererDateAleatoire(t.getDateDebut(), t.getDateFin());
                ajouterMatchKO(vainqueurs.get(i), vainqueurs.get(i+1), tourActuel + 1, dateAssignee);
            }
        }
    }

    // 8. Trouver le grand Vainqueur d'une Élimination Directe
    public Equipe getVainqueurKnockout(int idTournoi) {
        int dernierTour = 0;
        String sqlMax = "SELECT MAX(tour_numero) FROM match_tournoi m JOIN equipe e ON m.equipe_dom_id = e.id WHERE e.id_tournoi = ?";
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sqlMax)) {
            stmt.setInt(1, idTournoi);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) dernierTour = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }

        if (dernierTour == 0) return null;

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
                    int idGagnant = (rs.getInt("score_dom") > rs.getInt("score_ext")) ? rs.getInt("equipe_dom_id") : rs.getInt("equipe_ext_id");
                    EquipeDAO eqDAO = new EquipeDAO();
                    for(Equipe e : eqDAO.listerParTournoi(idTournoi)) {
                        if(e.getId() == idGagnant) vainqueur = e;
                    }
                } else {
                    return null; 
                }
            }
            if (nbMatchs == 1 && vainqueur != null) {
                return vainqueur;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 9. L'outil pour générer une date aléatoire
    private String genererDateAleatoire(String dateDebut, String dateFin) {
        try {
            java.time.LocalDate start = java.time.LocalDate.parse(dateDebut);
            java.time.LocalDate end = java.time.LocalDate.parse(dateFin);
            long days = java.time.temporal.ChronoUnit.DAYS.between(start, end);
            
            if (days < 0) return dateDebut; 
            
            long randomDays = (long) (Math.random() * (days + 1));
            return start.plusDays(randomDays).toString();
        } catch (Exception e) {
            return dateDebut; 
        }
    }

    // Méthode utilitaire interne pour éviter la répétition dans verifierEtGenererTourSuivant
    private PreparedStatement prepareStatement(String sql) throws SQLException {
        return DatabaseConnection.getConnection().prepareStatement(sql);
    }
}