package com.tournoi.model;
public class Match {
    private int id, equipeDomId, equipeExtId, scoreDom, scoreExt; private String nomEquipeDom, nomEquipeExt, statut;
    public int getId() { return id; } public void setId(int id) { this.id = id; }
    public int getScoreDom() { return scoreDom; } public void setScoreDom(int scoreDom) { this.scoreDom = scoreDom; }
    public int getScoreExt() { return scoreExt; } public void setScoreExt(int scoreExt) { this.scoreExt = scoreExt; }
    public String getNomEquipeDom() { return nomEquipeDom; } public void setNomEquipeDom(String nomEquipeDom) { this.nomEquipeDom = nomEquipeDom; }
    public String getNomEquipeExt() { return nomEquipeExt; } public void setNomEquipeExt(String nomEquipeExt) { this.nomEquipeExt = nomEquipeExt; }
    public String getStatut() { return statut; } public void setStatut(String statut) { this.statut = statut; }
    private int tourNumero;

    public int getTourNumero() { return tourNumero; }
    public void setTourNumero(int tourNumero) { this.tourNumero = tourNumero; }
}