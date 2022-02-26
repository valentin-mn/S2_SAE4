-- MySQL dump 10.13  Distrib 8.0.25, for Linux (x86_64)
--
-- Host: vmunch.mysql.pythonanywhere-services.com    Database: vmunch$default
-- ------------------------------------------------------
-- Server version	5.7.34-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adresse`
--

DROP TABLE IF EXISTS `adresse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adresse` (
  `id_adresse` int(11) NOT NULL AUTO_INCREMENT,
  `ligne_adresse` varchar(256) DEFAULT NULL,
  `ligne_2_adresse` varchar(256) DEFAULT NULL,
  `ville_adresse` varchar(256) DEFAULT NULL,
  `cp_adresse` varchar(50) DEFAULT NULL,
  `pays_adresse` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id_adresse`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adresse`
--

LOCK TABLES `adresse` WRITE;
/*!40000 ALTER TABLE `adresse` DISABLE KEYS */;
INSERT INTO `adresse` VALUES (8,'3 rue Gaston Defferre','','Belfort','90000','France'),(9,'Oui','','oui','85005','oui');
/*!40000 ALTER TABLE `adresse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appartient_a`
--

DROP TABLE IF EXISTS `appartient_a`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appartient_a` (
  `id_vetement` int(11) NOT NULL,
  `id_style` int(11) NOT NULL,
  PRIMARY KEY (`id_vetement`,`id_style`),
  KEY `id_style` (`id_style`),
  CONSTRAINT `appartient_a_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `appartient_a_ibfk_2` FOREIGN KEY (`id_style`) REFERENCES `style` (`id_style`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appartient_a`
--

LOCK TABLES `appartient_a` WRITE;
/*!40000 ALTER TABLE `appartient_a` DISABLE KEYS */;
INSERT INTO `appartient_a` VALUES (1,1),(4,1),(9,1),(12,1),(14,1),(15,1),(2,2),(3,2),(11,2),(13,2);
/*!40000 ALTER TABLE `appartient_a` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commande`
--

DROP TABLE IF EXISTS `commande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commande` (
  `id_commande` int(11) NOT NULL AUTO_INCREMENT,
  `date_commande` date DEFAULT NULL,
  `id_adresse` int(11) NOT NULL,
  `id_users` int(11) NOT NULL,
  `id_etat` int(11) NOT NULL,
  PRIMARY KEY (`id_commande`),
  KEY `id_adresse` (`id_adresse`),
  KEY `id_users` (`id_users`),
  KEY `id_etat` (`id_etat`),
  CONSTRAINT `commande_ibfk_1` FOREIGN KEY (`id_adresse`) REFERENCES `adresse` (`id_adresse`),
  CONSTRAINT `commande_ibfk_2` FOREIGN KEY (`id_users`) REFERENCES `users` (`id_users`),
  CONSTRAINT `commande_ibfk_3` FOREIGN KEY (`id_etat`) REFERENCES `etat` (`id_etat`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commande`
--

LOCK TABLES `commande` WRITE;
/*!40000 ALTER TABLE `commande` DISABLE KEYS */;
INSERT INTO `commande` VALUES (1,'2022-02-21',8,2,3),(2,'2022-02-21',8,2,4),(3,'2022-02-21',8,2,4),(4,'2022-02-21',8,2,4),(5,'2022-02-21',8,2,4),(6,'2022-02-21',8,2,1),(7,'2022-02-23',8,2,1),(8,'2022-02-24',9,4,2),(9,'2022-02-24',9,4,1);
/*!40000 ALTER TABLE `commande` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commentaires`
--

DROP TABLE IF EXISTS `commentaires`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commentaires` (
  `id_commentaires` int(11) NOT NULL AUTO_INCREMENT,
  `date_commentaire` date DEFAULT NULL,
  `txt_commentaire` varchar(512) DEFAULT NULL,
  `note_commentaire` int(11) DEFAULT NULL,
  `id_vetement` int(11) NOT NULL,
  `id_users` int(11) NOT NULL,
  PRIMARY KEY (`id_commentaires`),
  KEY `id_vetement` (`id_vetement`),
  KEY `id_users` (`id_users`),
  CONSTRAINT `commentaires_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `commentaires_ibfk_2` FOREIGN KEY (`id_users`) REFERENCES `users` (`id_users`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commentaires`
--

LOCK TABLES `commentaires` WRITE;
/*!40000 ALTER TABLE `commentaires` DISABLE KEYS */;
INSERT INTO `commentaires` VALUES (1,'2022-02-24','Bon article, je recommande. Tissu de qualité !',5,14,4),(2,'2022-02-24','Top !',3,13,4);
/*!40000 ALTER TABLE `commentaires` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `est_associee_a`
--

DROP TABLE IF EXISTS `est_associee_a`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `est_associee_a` (
  `id_users` int(11) NOT NULL,
  `id_adresse` int(11) NOT NULL,
  PRIMARY KEY (`id_users`,`id_adresse`),
  KEY `id_adresse` (`id_adresse`),
  CONSTRAINT `est_associee_a_ibfk_1` FOREIGN KEY (`id_users`) REFERENCES `users` (`id_users`),
  CONSTRAINT `est_associee_a_ibfk_2` FOREIGN KEY (`id_adresse`) REFERENCES `adresse` (`id_adresse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `est_associee_a`
--

LOCK TABLES `est_associee_a` WRITE;
/*!40000 ALTER TABLE `est_associee_a` DISABLE KEYS */;
INSERT INTO `est_associee_a` VALUES (2,8),(4,9);
/*!40000 ALTER TABLE `est_associee_a` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `est_dispo`
--

DROP TABLE IF EXISTS `est_dispo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `est_dispo` (
  `id_vetement` int(11) NOT NULL,
  `id_taille` int(11) NOT NULL,
  `stock` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_vetement`,`id_taille`),
  KEY `id_taille` (`id_taille`),
  CONSTRAINT `est_dispo_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `est_dispo_ibfk_2` FOREIGN KEY (`id_taille`) REFERENCES `taille` (`id_taille`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `est_dispo`
--

LOCK TABLES `est_dispo` WRITE;
/*!40000 ALTER TABLE `est_dispo` DISABLE KEYS */;
INSERT INTO `est_dispo` VALUES (1,1,3),(1,2,-4),(2,1,10),(2,3,5),(2,4,15),(3,1,10),(3,3,15),(4,2,10),(4,3,25),(9,3,8),(10,2,4),(10,4,6),(11,2,6),(12,3,3),(12,5,7),(13,1,4),(14,2,8),(14,3,-8),(14,4,8),(15,1,3),(15,3,5),(15,4,5),(15,5,1);
/*!40000 ALTER TABLE `est_dispo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `est_en`
--

DROP TABLE IF EXISTS `est_en`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `est_en` (
  `id_vetement` int(11) NOT NULL,
  `id_matiere` int(11) NOT NULL,
  PRIMARY KEY (`id_vetement`,`id_matiere`),
  KEY `id_matiere` (`id_matiere`),
  CONSTRAINT `est_en_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `est_en_ibfk_2` FOREIGN KEY (`id_matiere`) REFERENCES `matiere` (`id_matiere`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `est_en`
--

LOCK TABLES `est_en` WRITE;
/*!40000 ALTER TABLE `est_en` DISABLE KEYS */;
INSERT INTO `est_en` VALUES (1,1),(2,1),(4,1),(9,1),(10,1),(15,1),(3,2),(13,2),(11,3),(12,3),(12,4),(14,4);
/*!40000 ALTER TABLE `est_en` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `etat`
--

DROP TABLE IF EXISTS `etat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etat` (
  `id_etat` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_etat` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_etat`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `etat`
--

LOCK TABLES `etat` WRITE;
/*!40000 ALTER TABLE `etat` DISABLE KEYS */;
INSERT INTO `etat` VALUES (1,'En attente'),(2,'En cours de traitement'),(3,'Expediée'),(4,'Annulée');
/*!40000 ALTER TABLE `etat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ligne_commande`
--

DROP TABLE IF EXISTS `ligne_commande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ligne_commande` (
  `id_vetement` int(11) NOT NULL,
  `id_commande` int(11) NOT NULL,
  `id_taille` int(11) NOT NULL,
  `prix_unitaire` decimal(15,2) DEFAULT NULL,
  `quantite` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_vetement`,`id_commande`),
  KEY `id_commande` (`id_commande`),
  KEY `id_taille` (`id_taille`),
  CONSTRAINT `ligne_commande_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `ligne_commande_ibfk_2` FOREIGN KEY (`id_commande`) REFERENCES `commande` (`id_commande`),
  CONSTRAINT `ligne_commande_ibfk_3` FOREIGN KEY (`id_taille`) REFERENCES `taille` (`id_taille`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ligne_commande`
--

LOCK TABLES `ligne_commande` WRITE;
/*!40000 ALTER TABLE `ligne_commande` DISABLE KEYS */;
INSERT INTO `ligne_commande` VALUES (1,3,1,25.99,3),(1,8,1,25.99,2),(1,9,2,25.99,10),(14,9,3,47.99,4),(15,8,5,59.99,2);
/*!40000 ALTER TABLE `ligne_commande` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marque`
--

DROP TABLE IF EXISTS `marque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marque` (
  `id_marque` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_marque` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_marque`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marque`
--

LOCK TABLES `marque` WRITE;
/*!40000 ALTER TABLE `marque` DISABLE KEYS */;
INSERT INTO `marque` VALUES (1,'Nike'),(2,'Adidas'),(3,'Bershka'),(4,'Calvin Klein'),(5,'Carhartt'),(6,'Only & Sons'),(7,'Stradivarius'),(8,'The North Face'),(9,'Ralph Lauren'),(10,'Levi\'s'),(11,'Jordan'),(12,'Pull & Bear');
/*!40000 ALTER TABLE `marque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matiere`
--

DROP TABLE IF EXISTS `matiere`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matiere` (
  `id_matiere` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_matiere` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_matiere`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matiere`
--

LOCK TABLES `matiere` WRITE;
/*!40000 ALTER TABLE `matiere` DISABLE KEYS */;
INSERT INTO `matiere` VALUES (1,'Coton'),(2,'Synthetique'),(3,'Polaire'),(4,'Jean');
/*!40000 ALTER TABLE `matiere` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `panier`
--

DROP TABLE IF EXISTS `panier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `panier` (
  `id_vetement` int(11) NOT NULL,
  `id_users` int(11) NOT NULL,
  `id_taille` int(11) NOT NULL,
  `quantite` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_vetement`,`id_users`,`id_taille`),
  KEY `id_users` (`id_users`),
  CONSTRAINT `panier_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `panier_ibfk_2` FOREIGN KEY (`id_users`) REFERENCES `users` (`id_users`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `panier`
--

LOCK TABLES `panier` WRITE;
/*!40000 ALTER TABLE `panier` DISABLE KEYS */;
INSERT INTO `panier` VALUES (13,4,1,'4');
/*!40000 ALTER TABLE `panier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propose`
--

DROP TABLE IF EXISTS `propose`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `propose` (
  `id_vetement` int(11) NOT NULL,
  `id_marque` int(11) NOT NULL,
  PRIMARY KEY (`id_vetement`,`id_marque`),
  KEY `id_marque` (`id_marque`),
  CONSTRAINT `propose_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `propose_ibfk_2` FOREIGN KEY (`id_marque`) REFERENCES `marque` (`id_marque`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propose`
--

LOCK TABLES `propose` WRITE;
/*!40000 ALTER TABLE `propose` DISABLE KEYS */;
INSERT INTO `propose` VALUES (1,1),(4,1),(15,1),(3,3),(2,4),(5,4),(10,4),(11,4),(9,5),(13,7),(12,10),(14,10),(15,11);
/*!40000 ALTER TABLE `propose` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saison`
--

DROP TABLE IF EXISTS `saison`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saison` (
  `id_saison` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_saison` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_saison`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saison`
--

LOCK TABLES `saison` WRITE;
/*!40000 ALTER TABLE `saison` DISABLE KEYS */;
INSERT INTO `saison` VALUES (1,'Été'),(2,'Primtemps'),(3,'Automne'),(4,'Hiver'),(5,'Mi-Saison'),(6,'Toutes Saisons');
/*!40000 ALTER TABLE `saison` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sexe`
--

DROP TABLE IF EXISTS `sexe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sexe` (
  `id_sexe` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_sexe` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_sexe`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sexe`
--

LOCK TABLES `sexe` WRITE;
/*!40000 ALTER TABLE `sexe` DISABLE KEYS */;
INSERT INTO `sexe` VALUES (1,'Homme'),(2,'Femme'),(3,'Unisexe');
/*!40000 ALTER TABLE `sexe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `style`
--

DROP TABLE IF EXISTS `style`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `style` (
  `id_style` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_style` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_style`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `style`
--

LOCK TABLES `style` WRITE;
/*!40000 ALTER TABLE `style` DISABLE KEYS */;
INSERT INTO `style` VALUES (1,'Streetwear'),(2,'Classique');
/*!40000 ALTER TABLE `style` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taille`
--

DROP TABLE IF EXISTS `taille`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taille` (
  `id_taille` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_taille` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_taille`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taille`
--

LOCK TABLES `taille` WRITE;
/*!40000 ALTER TABLE `taille` DISABLE KEYS */;
INSERT INTO `taille` VALUES (1,'XS'),(2,'S'),(3,'M'),(4,'L'),(5,'XL');
/*!40000 ALTER TABLE `taille` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `type_vetement`
--

DROP TABLE IF EXISTS `type_vetement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `type_vetement` (
  `id_type_vetement` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_type_vetement` varchar(50) DEFAULT NULL,
  `id_saison` int(11) NOT NULL,
  PRIMARY KEY (`id_type_vetement`),
  KEY `id_saison` (`id_saison`),
  CONSTRAINT `type_vetement_ibfk_1` FOREIGN KEY (`id_saison`) REFERENCES `saison` (`id_saison`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `type_vetement`
--

LOCK TABLES `type_vetement` WRITE;
/*!40000 ALTER TABLE `type_vetement` DISABLE KEYS */;
INSERT INTO `type_vetement` VALUES (1,'Tshirt',1),(2,'Veste',4),(3,'Pull',5),(4,'Sweat',5),(5,'Jean',5),(6,'Pantalon',6),(7,'Bonnet',4),(8,'Sous-vêtements',6),(9,'Gants',4);
/*!40000 ALTER TABLE `type_vetement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id_users` int(11) NOT NULL AUTO_INCREMENT,
  `username_users` varchar(250) DEFAULT NULL,
  `nom_users` varchar(250) DEFAULT NULL,
  `prenom_users` varchar(250) DEFAULT NULL,
  `numtel_users` varchar(20) DEFAULT NULL,
  `email_users` varchar(250) DEFAULT NULL,
  `password_users` varchar(250) DEFAULT NULL,
  `role_users` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_users`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','Tout puissant','Administrateur','0123456789','admin@admin.fr','sha256$EMOEOjUZlW34l57I$4577c634103087b498cf2c3997b380d515e9b84d48b5e33e020cd64680cc9434','ROLE_admin'),(2,'pmaffiol','Maffiolini','Paul','0123456789','paulmaffiolini04@gmail.com','sha256$cRojH2VeVJn2jTsp$5900fbda1881537d230ae51134acde3f7541e07723784e8e5e21a9c23d6a8065','ROLE_client'),(3,'iencli','ien','cli','0102030405','clienttest@gmail.com','sha256$3cFyhHHnE9MUcR1O$90663c17257fe588eaab77a216437b648401c1c8247d426b4344efb6dd948b8d','ROLE_client'),(4,'client','client','client','0102030405','client@z.com','sha256$owhyuMHBzz7lAJub$e94756356fbe74594dd5778920eabb8c83dc6d02f06d5387e82099534b728fc7','ROLE_client');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vetement`
--

DROP TABLE IF EXISTS `vetement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vetement` (
  `id_vetement` int(11) NOT NULL AUTO_INCREMENT,
  `prix_vetement` decimal(15,2) DEFAULT NULL,
  `libelle_vetement` varchar(50) DEFAULT NULL,
  `id_sexe` int(11) NOT NULL,
  `id_type_vetement` int(11) NOT NULL,
  PRIMARY KEY (`id_vetement`),
  KEY `id_sexe` (`id_sexe`),
  KEY `id_type_vetement` (`id_type_vetement`),
  CONSTRAINT `vetement_ibfk_1` FOREIGN KEY (`id_sexe`) REFERENCES `sexe` (`id_sexe`),
  CONSTRAINT `vetement_ibfk_2` FOREIGN KEY (`id_type_vetement`) REFERENCES `type_vetement` (`id_type_vetement`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vetement`
--

LOCK TABLES `vetement` WRITE;
/*!40000 ALTER TABLE `vetement` DISABLE KEYS */;
INSERT INTO `vetement` VALUES (1,25.99,'Tshirt Brun',1,1),(2,20.99,'Tshirt Gris',2,1),(3,27.99,'Pantalon large',2,6),(4,45.99,'Sweat Bleu',2,4),(5,23.00,'Tshirt ours',2,1),(9,25.00,'Bonnet',3,7),(10,37.00,'Boxer',1,2),(11,24.00,'Gants Roses',2,9),(12,89.99,'Veste Polaire',3,2),(13,75.45,'Manteau Gris',2,2),(14,47.99,'Jean Bleu délavé',1,5),(15,59.99,'Sweat à capuche vert',1,4);
/*!40000 ALTER TABLE `vetement` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-25 23:16:59
