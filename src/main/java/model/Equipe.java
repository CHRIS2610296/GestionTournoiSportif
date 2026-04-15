package model;

import java.io.Serializable;

public class Equipe implements Serializable {
    private int id;
    private String nom;
    private int tournoiId; 

    
    public Equipe() {
    }

    public Equipe(int id, String nom, int tournoiId) {
        this.id = id;
        this.nom = nom;
        this.tournoiId = tournoiId;
    }

    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public int getTournoiId() { return tournoiId; }
    public void setTournoiId(int tournoiId) { this.tournoiId = tournoiId; }
}