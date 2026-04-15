package model;
import java.io.Serializable;

public class Tournoi implements Serializable {
    private int id;
    private String nom;
    private String typeRegle;

    public Tournoi() {}
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getTypeRegle() { return typeRegle; }
    public void setTypeRegle(String typeRegle) { this.typeRegle = typeRegle; }
}