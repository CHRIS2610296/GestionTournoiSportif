package com.tournoi.dao;
import com.tournoi.model.Equipe; import com.tournoi.model.Classement; import java.sql.*; import java.util.*;
public class EquipeDAO {
    public void ajouterEquipe(Equipe e) {
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement("INSERT INTO equipe (nom, ville, nombre_joueurs, logo, contact, id_tournoi) VALUES (?, ?, ?, ?, ?, ?)")) {
            stmt.setString(1, e.getNom()); stmt.setString(2, e.getVille()); stmt.setInt(3, e.getNombreJoueurs()); stmt.setString(4, e.getLogo()); stmt.setString(5, e.getContact()); stmt.setInt(6, e.getIdTournoi()); stmt.executeUpdate();
        } catch (Exception ex) { ex.printStackTrace(); }
    }
    public List<Equipe> listerParTournoi(int idTournoi) {
        List<Equipe> liste = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement("SELECT * FROM equipe WHERE id_tournoi=?")) {
            stmt.setInt(1, idTournoi); ResultSet rs = stmt.executeQuery();
            while(rs.next()) { Equipe e = new Equipe(); e.setId(rs.getInt("id")); e.setNom(rs.getString("nom")); e.setVille(rs.getString("ville")); e.setNombreJoueurs(rs.getInt("nombre_joueurs")); e.setLogo(rs.getString("logo")); e.setContact(rs.getString("contact")); e.setIdTournoi(rs.getInt("id_tournoi")); liste.add(e); }
        } catch(Exception ex) { ex.printStackTrace(); } return liste;
    }
    public List<Classement> genererClassement(int idTournoi) {
        List<Equipe> equipes = listerParTournoi(idTournoi);
        Map<Integer, Classement> tableau = new HashMap<>();
        for (Equipe eq : equipes) { tableau.put(eq.getId(), new Classement(eq.getId(), eq.getNom(), eq.getLogo())); }
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement("SELECT m.equipe_dom_id, m.equipe_ext_id, m.score_dom, m.score_ext FROM match_tournoi m JOIN equipe e ON m.equipe_dom_id = e.id WHERE e.id_tournoi = ? AND m.statut = 'Terminé'")) {
            stmt.setInt(1, idTournoi); ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                if(tableau.containsKey(rs.getInt("equipe_dom_id"))) tableau.get(rs.getInt("equipe_dom_id")).ajouterResultatMatch(rs.getInt("score_dom"), rs.getInt("score_ext"));
                if(tableau.containsKey(rs.getInt("equipe_ext_id"))) tableau.get(rs.getInt("equipe_ext_id")).ajouterResultatMatch(rs.getInt("score_ext"), rs.getInt("score_dom"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        List<Classement> listeFinale = new ArrayList<>(tableau.values());
        Collections.sort(listeFinale, (c1, c2) -> {
            if (c1.getPoints() != c2.getPoints()) return c2.getPoints() - c1.getPoints();
            if (c1.getDifferenceButs() != c2.getDifferenceButs()) return c2.getDifferenceButs() - c1.getDifferenceButs();
            return c2.getButsPour() - c1.getButsPour();
        });
        return listeFinale;
    }
 // NOUVELLE MÉTHODE : Récupérer les équipes uniques pour l'ajout rapide
    public List<Equipe> listerEquipesDistinctes() {
        List<Equipe> liste = new ArrayList<>();
        // Le GROUP BY permet de ne pas afficher l'équipe en double si elle a participé à 3 tournois
        String sql = "SELECT nom, ville, logo, contact FROM equipe GROUP BY nom, ville, logo, contact";
        
        try (Connection conn = DatabaseConnection.getConnection(); 
             Statement stmt = conn.createStatement(); 
             ResultSet rs = stmt.executeQuery(sql)) {
             
            while(rs.next()) { 
                Equipe e = new Equipe(); 
                e.setNom(rs.getString("nom")); 
                e.setVille(rs.getString("ville")); 
                e.setLogo(rs.getString("logo")); 
                e.setContact(rs.getString("contact")); 
                liste.add(e); 
            }
        } catch(Exception ex) { 
            ex.printStackTrace(); 
        } 
        return liste;
    }
}