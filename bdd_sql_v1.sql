

DROP TABLE IF EXISTS poste;
DROP TABLE IF EXISTS concerne;
DROP TABLE IF EXISTS panier;
DROP TABLE IF EXISTS ligne_commande_;
DROP TABLE IF EXISTS est_en;
DROP TABLE IF EXISTS est_genre;
DROP TABLE IF EXISTS saisonne_pour;
DROP TABLE IF EXISTS appartient_a;
DROP TABLE IF EXISTS propose;
DROP TABLE IF EXISTS est_dispo;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS vetement;
DROP TABLE IF EXISTS avis;
DROP TABLE IF EXISTS etat;
DROP TABLE IF EXISTS matiere;
DROP TABLE IF EXISTS sexe;
DROP TABLE IF EXISTS saison;
DROP TABLE IF EXISTS type_vetement;
DROP TABLE IF EXISTS marque;
DROP TABLE IF EXISTS taille;
DROP TABLE IF EXISTS style;
DROP TABLE IF EXISTS adresse;







CREATE TABLE adresse(
   id_adresse INT AUTO_INCREMENT,
   region_adresse VARCHAR(50),
   ville_adresse VARCHAR(50),
   cp_adresse VARCHAR(50),
   pays_adresse VARCHAR(50),
   PRIMARY KEY(Id_adresse)
);

INSERT INTO adresse(id_adresse, region_adresse, ville_adresse, cp_adresse, pays_adresse) VALUES
(NULL, 'Grand Est', 'Metz', '57000', 'France'),
(NULL, 'Grand Est', 'Nancy', '54000', 'France'),
(NULL, 'Centre', 'Orléans', '45000', 'France'),
(NULL, 'Grand Est', 'Metz', '57000', 'France');

CREATE TABLE style(
   id_style INT AUTO_INCREMENT,
   libelle_style VARCHAR(50),
   PRIMARY KEY(id_style)
);

INSERT INTO style(id_style, libelle_style) VALUES
(NULL, 'Streetwear'),
(NULL, 'Habillé'),
(NULL, 'Casual'),
(NULL, 'Classique'),
(NULL, 'Sportif');


CREATE TABLE taille(
   id_taille INT AUTO_INCREMENT,
   libelle_taille VARCHAR(50),
   PRIMARY KEY(id_taille)
);
INSERT INTO taille (id_taille, libelle_taille) VALUES
(NULL, 'XS'),
(NULL, 'S'),
(NULL, 'M'),
(NULL, 'L'),
(NULL, 'XL'),
(NULL, 'XXL');


CREATE TABLE marque(
   id_marque INT AUTO_INCREMENT,
   libelle_marque VARCHAR(50),
   PRIMARY KEY(id_marque)
);

INSERT INTO marque(id_marque, libelle_marque) VALUES
(NULL, 'Nike'),
(NULL, 'Levis'),
(NULL, 'Jack and jones'),
(NULL, 'The North Face'),
(NULL, 'Calvin Klein');

CREATE TABLE type_vetement(
   id_type_vetement INT AUTO_INCREMENT,
   libelle_type_vetement VARCHAR(50),
   PRIMARY KEY(id_type_vetement)
);

INSERT INTO type_vetement(id_type_vetement, libelle_type_vetement) VALUES
(NULL, 'T-Shirt'),
(NULL, 'Pantalon'),
(NULL, 'Jean'),
(NULL, 'Sweatshirt'),
(NULL, 'Pull'),
(NULL, 'Gilet'),
(NULL, 'Manteau'),
(NULL, 'Veste'),
(NULL, 'Echarpe'),
(NULL, 'Sous-vêtements'),
(NULL, 'Bonnets'),
(NULL, 'Gants'),
(NULL, 'Masques');


CREATE TABLE saison(
   id_saison INT AUTO_INCREMENT,
   libelle_saison VARCHAR(50),
   PRIMARY KEY(id_saison)
);

INSERT INTO saison(id_saison, libelle_saison) VALUES
(NULL, 'Printemps/Eté'),
(NULL, 'Automne/Hiver');

CREATE TABLE sexe(
   id_sexe INT AUTO_INCREMENT,
   libelle_sexe VARCHAR(50),
   PRIMARY KEY(id_sexe)
);

CREATE TABLE matiere(
   id_matiere INT AUTO_INCREMENT,
   libelle_matiere VARCHAR(50),
   PRIMARY KEY(id_matiere)
);

CREATE TABLE etat(
   id_etat INT AUTO_INCREMENT,
   libelle_etat VARCHAR(50),
   PRIMARY KEY(id_etat)
);

CREATE TABLE avis(
   id_avis INT AUTO_INCREMENT,
   note_avis INT,
   commentaire_avis VARCHAR(50),
   PRIMARY KEY(id_avis)
);

CREATE TABLE vetement(
   id_vetement INT AUTO_INCREMENT,
   libelle_vetement VARCHAR(50),
   id_type_vetement INT NOT NULL,
   PRIMARY KEY(id_vetement),
   FOREIGN KEY(id_type_vetement) REFERENCES type_vetement(id_type_vetement)
);

CREATE TABLE users(
   id_users INT AUTO_INCREMENT,
   nom_users VARCHAR(50),
   prenom_users VARCHAR(50),
   numtel_users VARCHAR(50),
   email_users VARCHAR(50),
   password_users VARCHAR(50),
   Id_adresse INT NOT NULL,
   PRIMARY KEY(id_users),
   FOREIGN KEY(Id_adresse) REFERENCES adresse(Id_adresse)
);

CREATE TABLE commande(
   id_commande INT AUTO_INCREMENT,
   date_commande DATE,
   Id_adresse INT NOT NULL,
   id_users INT NOT NULL,
   id_etat INT NOT NULL,
   PRIMARY KEY(id_commande),
   FOREIGN KEY(Id_adresse) REFERENCES adresse(Id_adresse),
   FOREIGN KEY(id_users) REFERENCES users(id_users),
   FOREIGN KEY(id_etat) REFERENCES etat(id_etat)
);

CREATE TABLE est_dispo(
   id_vetement INT,
   id_taille INT,
   stock INT,
   PRIMARY KEY(id_vetement, id_taille),
   FOREIGN KEY(id_vetement) REFERENCES vetement(id_vetement),
   FOREIGN KEY(id_taille) REFERENCES taille(id_taille)
);

CREATE TABLE propose(
   id_vetement INT,
   id_marque INT,
   PRIMARY KEY(id_vetement, id_marque),
   FOREIGN KEY(id_vetement) REFERENCES vetement(id_vetement),
   FOREIGN KEY(id_marque) REFERENCES marque(id_marque)
);

CREATE TABLE appartient_a(
   id_vetement INT,
   id_style INT,
   PRIMARY KEY(id_vetement, id_style),
   FOREIGN KEY(id_vetement) REFERENCES vetement(id_vetement),
   FOREIGN KEY(id_style) REFERENCES style(id_style)
);

CREATE TABLE saisonne_pour(
   id_type_vetement INT,
   id_Saison INT,
   PRIMARY KEY(id_type_vetement, id_Saison),
   FOREIGN KEY(id_type_vetement) REFERENCES type_vetement(id_type_vetement),
   FOREIGN KEY(id_Saison) REFERENCES Saison(id_Saison)
);

CREATE TABLE est_genre(
   id_vetement INT,
   id_sexe INT,
   PRIMARY KEY(id_vetement, id_sexe),
   FOREIGN KEY(id_vetement) REFERENCES vetement(id_vetement),
   FOREIGN KEY(id_sexe) REFERENCES sexe(id_sexe)
);

CREATE TABLE est_en(
   id_vetement INT,
   id_matiere INT,
   PRIMARY KEY(id_vetement, id_matiere),
   FOREIGN KEY(id_vetement) REFERENCES vetement(id_vetement),
   FOREIGN KEY(id_matiere) REFERENCES matiere(id_matiere)
);

CREATE TABLE ligne_commande_(
   id_vetement INT,
   id_commande INT,
   prix_unitaire DECIMAL(15,2),
   quantite INT,
   PRIMARY KEY(id_vetement, id_commande),
   FOREIGN KEY(id_vetement) REFERENCES vetement(id_vetement),
   FOREIGN KEY(id_commande) REFERENCES commande(id_commande)
);

CREATE TABLE panier(
   id_vetement INT,
   id_users INT,
   quantite VARCHAR(50),
   PRIMARY KEY(id_vetement, id_users),
   FOREIGN KEY(id_vetement) REFERENCES vetement(id_vetement),
   FOREIGN KEY(id_users) REFERENCES users(id_users)
);

CREATE TABLE concerne(
   id_vetement INT,
   id_avis INT,
   PRIMARY KEY(id_vetement, id_avis),
   FOREIGN KEY(id_vetement) REFERENCES vetement(id_vetement),
   FOREIGN KEY(id_avis) REFERENCES avis(id_avis)
);

CREATE TABLE poste(
   id_users INT,
   id_avis INT,
   PRIMARY KEY(id_users, id_avis),
   FOREIGN KEY(id_users) REFERENCES users(id_users),
   FOREIGN KEY(id_avis) REFERENCES avis(id_avis)
);
