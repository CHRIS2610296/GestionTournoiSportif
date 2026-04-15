package com.tournoi.model;
public class Classement {
    private int idEquipe; private String nomEquipe, logo;
    private int points = 0, matchsJoues = 0, victoires = 0, nuls = 0, defaites = 0, butsPour = 0, butsContre = 0;
    
    public Classement(int idEquipe, String nomEquipe, String logo) { this.idEquipe = idEquipe; this.nomEquipe = nomEquipe; this.logo = logo; }
    
    public int getDifferenceButs() { return butsPour - butsContre; }
    public void ajouterResultatMatch(int butsMarques, int butsEncaisses) {
        this.matchsJoues++; this.butsPour += butsMarques; this.butsContre += butsEncaisses;
        if (butsMarques > butsEncaisses) { this.victoires++; this.points += 3; } 
        else if (butsMarques == butsEncaisses) { this.nuls++; this.points += 1; } 
        else { this.defaites++; }
    }
    public int getIdEquipe() { return idEquipe; } public String getNomEquipe() { return nomEquipe; }
    public String getLogo() { return logo; } public int getPoints() { return points; }
    public int getMatchsJoues() { return matchsJoues; } public int getVictoires() { return victoires; }
    public int getNuls() { return nuls; } public int getDefaites() { return defaites; }
    public int getButsPour() { return butsPour; } public int getButsContre() { return butsContre; }
}