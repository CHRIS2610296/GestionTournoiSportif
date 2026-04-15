package com.tournoi.model;
public class Equipe {
    private int id, nombreJoueurs, idTournoi; private String nom, ville, logo, contact;
    public int getId() { return id; } public void setId(int id) { this.id = id; }
    public int getNombreJoueurs() { return nombreJoueurs; } public void setNombreJoueurs(int nombreJoueurs) { this.nombreJoueurs = nombreJoueurs; }
    public int getIdTournoi() { return idTournoi; } public void setIdTournoi(int idTournoi) { this.idTournoi = idTournoi; }
    public String getNom() { return nom; } public void setNom(String nom) { this.nom = nom; }
    public String getVille() { return ville; } public void setVille(String ville) { this.ville = ville; }
    public String getLogo() { return logo; } public void setLogo(String logo) { this.logo = logo; }
    public String getContact() { return contact; } public void setContact(String contact) { this.contact = contact; }
}