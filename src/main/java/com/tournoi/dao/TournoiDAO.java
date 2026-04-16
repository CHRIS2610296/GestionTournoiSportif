package com.tournoi.dao;
import com.tournoi.model.Tournoi; import java.sql.*; import java.util.ArrayList; import java.util.List;
public class TournoiDAO {
    public void creerTournoi(Tournoi t) {
        try (Connection conn = DatabaseConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement("INSERT INTO tournoi (nom, sport, type_tournoi, lieu, date_debut, date_fin) VALUES (?, ?, ?, ?, ?, ?)")) {
            stmt.setString(1, t.getNom()); stmt.setString(2, t.getSport()); stmt.setString(3, t.getTypeTournoi()); stmt.setString(4, t.getLieu()); stmt.setString(5, t.getDateDebut()); stmt.setString(6, t.getDateFin()); stmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
    public List<Tournoi> listerTournois() {
        List<Tournoi> liste = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM tournoi ORDER BY id DESC")) {
            while (rs.next()) { Tournoi t = new Tournoi(); t.setId(rs.getInt("id")); t.setNom(rs.getString("nom")); t.setSport(rs.getString("sport")); t.setTypeTournoi(rs.getString("type_tournoi")); t.setLieu(rs.getString("lieu")); t.setDateDebut(rs.getString("date_debut")); t.setDateFin(rs.getString("date_fin")); liste.add(t); }
        } catch (Exception e) { e.printStackTrace(); } return liste;
    }
    public Tournoi getTournoiById(int id) {
        Tournoi t = null;
        try (Connection conn = DatabaseConnection.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM tournoi WHERE id=?")) {
            stmt.setInt(1, id); 
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) { 
                t = new Tournoi(); 
                t.setId(id); 
                t.setNom(rs.getString("nom")); 
                t.setTypeTournoi(rs.getString("type_tournoi")); 
                t.setSport(rs.getString("sport"));
                t.setLieu(rs.getString("lieu"));
                // LES DEUX LIGNES MANQUANTES SONT ICI :
                t.setDateDebut(rs.getString("date_debut")); 
                t.setDateFin(rs.getString("date_fin")); 
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        } 
        return t;
    }
}