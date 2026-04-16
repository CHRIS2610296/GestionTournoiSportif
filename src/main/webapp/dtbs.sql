DROP DATABASE IF EXISTS tournoi_db;
CREATE DATABASE tournoi_db;
USE tournoi_db;

CREATE TABLE tournoi (
    id INT AUTO_INCREMENT PRIMARY KEY, nom VARCHAR(100) NOT NULL, sport VARCHAR(50) DEFAULT 'Football',
    type_tournoi VARCHAR(50) DEFAULT 'Championnat', lieu VARCHAR(100), date_debut DATE, date_fin DATE
);

CREATE TABLE equipe (
    id INT AUTO_INCREMENT PRIMARY KEY, nom VARCHAR(100) NOT NULL, ville VARCHAR(100),
    nombre_joueurs INT, logo VARCHAR(255), contact VARCHAR(100), id_tournoi INT,
    FOREIGN KEY (id_tournoi) REFERENCES tournoi(id) ON DELETE CASCADE
);

CREATE TABLE match_tournoi (
    id INT AUTO_INCREMENT PRIMARY KEY, equipe_dom_id INT NOT NULL, equipe_ext_id INT NOT NULL,
    score_dom INT DEFAULT 0, score_ext INT DEFAULT 0, tour_numero INT DEFAULT 1, statut VARCHAR(20) DEFAULT 'A jouer',
    FOREIGN KEY (equipe_dom_id) REFERENCES equipe(id) ON DELETE CASCADE,
    FOREIGN KEY (equipe_ext_id) REFERENCES equipe(id) ON DELETE CASCADE
);

CREATE TABLE utilisateur (
    id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, role VARCHAR(20) NOT NULL
);

-- Insertion des équipes par défaut et des comptes
INSERT INTO utilisateur (username, password, role) VALUES 
('admin', 'admin123', 'Admin'), ('orga', 'orga123', 'Organisateur'), ('invite', 'visiteur123', 'Spectateur');

INSERT INTO tournoi (nom, sport, type_tournoi, lieu) VALUES ('Ligue des Champions', 'Football', 'Elimination', 'Europe');

INSERT INTO equipe (nom, ville, nombre_joueurs, logo, contact, id_tournoi) VALUES 
('Real Madrid', 'Madrid', 25, 'https://i.pinimg.com/1200x/bb/8f/99/bb8f9956d1892f6ac5fd5c6650fbc218.jpg', 'contact@realmadrid.com', 1),
('FC Barcelone', 'Barcelone', 24, 'https://i.pinimg.com/736x/1a/80/08/1a80080e35169166c68640ce0a190809.jpg', 'contact@fcb.cat', 1),
('PSG', 'Paris', 26, 'https://i.pinimg.com/1200x/2c/33/74/2c337415c9f69443cf643c14b561857f.jpg', 'direction@psg.fr', 1),
('Man City', 'Manchester', 25, 'https://i.pinimg.com/1200x/13/e1/e5/13e1e5ee88fe474b7027355263ba0c6d.jpg', 'hello@mancity.co.uk', 1);