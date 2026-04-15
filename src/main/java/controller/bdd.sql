DROP DATABASE IF EXISTS tournoi_db;
CREATE DATABASE tournoi_db;
USE tournoi_db;

CREATE TABLE tournoi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    sport VARCHAR(50) DEFAULT 'Football',
    type_tournoi VARCHAR(50) DEFAULT 'Championnat',
    lieu VARCHAR(100),
    date_debut DATE,
    date_fin DATE
);

CREATE TABLE equipe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    ville VARCHAR(100),
    nombre_joueurs INT,
    logo VARCHAR(255),
    contact VARCHAR(100),
    id_tournoi INT,
    FOREIGN KEY (id_tournoi) REFERENCES tournoi(id) ON DELETE CASCADE
);

CREATE TABLE match_tournoi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    equipe_dom_id INT NOT NULL,
    equipe_ext_id INT NOT NULL,
    score_dom INT DEFAULT 0,
    score_ext INT DEFAULT 0,
    statut VARCHAR(20) DEFAULT 'A jouer',
    FOREIGN KEY (equipe_dom_id) REFERENCES equipe(id) ON DELETE CASCADE,
    FOREIGN KEY (equipe_ext_id) REFERENCES equipe(id) ON DELETE CASCADE
);