package com.tournoi.model;
public class Tournoi {
    private int id; private String nom, sport, typeTournoi, lieu, dateDebut, dateFin;
    public int getId() { return id; } public void setId(int id) { this.id = id; }
    public String getNom() { return nom; } public void setNom(String nom) { this.nom = nom; }
    public String getSport() { return sport; } public void setSport(String sport) { this.sport = sport; }
    public String getTypeTournoi() { return typeTournoi; } public void setTypeTournoi(String typeTournoi) { this.typeTournoi = typeTournoi; }
    public String getLieu() { return lieu; } public void setLieu(String lieu) { this.lieu = lieu; }
    public String getDateDebut() { return dateDebut; } public void setDateDebut(String dateDebut) { this.dateDebut = dateDebut; }
    public String getDateFin() { return dateFin; } public void setDateFin(String dateFin) { this.dateFin = dateFin; }
}