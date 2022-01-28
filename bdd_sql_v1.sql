CREATE TABLE adresse(
   Id_adresse INT AUTO_INCREMENT,
   region_adresse VARCHAR(50),
   ville_adresse VARCHAR(50),
   cp_adresse VARCHAR(50),
   pays_adresse VARCHAR(50),
   PRIMARY KEY(Id_adresse)
);

CREATE TABLE style(
   id_style COUNTER AUTO_INCREMENT,
   libelle_style VARCHAR(50),
   PRIMARY KEY(id_style)
);

CREATE TABLE taille(
   id_taille INT AUTO_INCREMENT,
   libelle_taille VARCHAR(50),
   PRIMARY KEY(id_taille)
);

CREATE TABLE marque(
   id_marque INT AUTO_INCREMENT,
   libelle_marque VARCHAR(50),
   PRIMARY KEY(id_marque)
);

CREATE TABLE type_vetement(
   id_type_vetement INT AUTO_INCREMENT,
   libelle_type_vetement VARCHAR(50),
   PRIMARY KEY(id_type_vetement)
);

CREATE TABLE Saison(
   id_Saison INT AUTO_INCREMENT,
   libelle_saison VARCHAR(50),
   PRIMARY KEY(id_Saison)
);

CREATE TABLE sexe(
   id_sexe COUNTER AUTO_INCREMENT,
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
