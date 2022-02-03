-- MariaDB dump 10.19  Distrib 10.5.12-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: serveurmysql    Database: BDD_tbecher
-- ------------------------------------------------------
-- Server version	5.7.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adresse` (
  `Id_adresse` int(11) NOT NULL AUTO_INCREMENT,
  `region_adresse` varchar(50) DEFAULT NULL,
  `ville_adresse` varchar(50) DEFAULT NULL,
  `cp_adresse` varchar(50) DEFAULT NULL,
  `pays_adresse` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id_adresse`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adresse`
--

LOCK TABLES `adresse` WRITE;
/*!40000 ALTER TABLE `adresse` DISABLE KEYS */;
INSERT INTO `adresse` VALUES (1,'3 rue Gaston Defferre','Apt 81','Belfort','90000'),(2,'3 rue Gaston Defferre','Apt 90','Belfort','90000'),(3,'15 route de cormin','','Germingny des près','45110'),(4,'15 Rue Arristide Briand','','Belfort','90000'),(5,'15 Rue de la vigne au loup','','Hauteville-lès-Dijon','21121');
/*!40000 ALTER TABLE `adresse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appartient_a`
--

DROP TABLE IF EXISTS `appartient_a`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appartient_a` (
  `id_vetement` int(11) NOT NULL,
  `id_style` int(11) NOT NULL,
  PRIMARY KEY (`id_vetement`,`id_style`),
  KEY `id_style` (`id_style`),
  CONSTRAINT `appartient_a_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `appartient_a_ibfk_2` FOREIGN KEY (`id_style`) REFERENCES `style` (`id_style`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appartient_a`
--

LOCK TABLES `appartient_a` WRITE;
/*!40000 ALTER TABLE `appartient_a` DISABLE KEYS */;
INSERT INTO `appartient_a` VALUES (4,1),(9,1),(18,1),(21,1),(8,2),(15,2),(19,2),(22,2),(1,3),(2,3),(3,3),(6,3),(10,3),(12,3),(14,3),(17,3),(23,3),(5,4),(7,4),(13,4),(16,4),(20,4),(24,4),(11,5);
/*!40000 ALTER TABLE `appartient_a` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commande`
--

DROP TABLE IF EXISTS `commande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `commande` (
  `id_commande` int(11) NOT NULL AUTO_INCREMENT,
  `date_commande` date DEFAULT NULL,
  `id_users` int(11) NOT NULL,
  `id_etat` int(11) NOT NULL,
  PRIMARY KEY (`id_commande`),
  KEY `id_users` (`id_users`),
  KEY `id_etat` (`id_etat`),
  CONSTRAINT `commande_ibfk_1` FOREIGN KEY (`id_users`) REFERENCES `users` (`id_users`),
  CONSTRAINT `commande_ibfk_2` FOREIGN KEY (`id_etat`) REFERENCES `etat` (`id_etat`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commande`
--

LOCK TABLES `commande` WRITE;
/*!40000 ALTER TABLE `commande` DISABLE KEYS */;
INSERT INTO `commande` VALUES (1,'2020-04-11',1,1),(2,'2020-12-11',2,2),(3,'2021-01-28',3,3),(4,'2020-09-19',4,3),(5,'2019-04-11',5,2),(6,'2020-12-11',6,3),(7,'2020-03-28',7,1),(8,'2020-12-09',8,1),(9,'2019-04-11',9,2),(10,'2020-12-11',10,3);
/*!40000 ALTER TABLE `commande` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `est_dispo`
--

DROP TABLE IF EXISTS `est_dispo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `est_dispo` (
  `id_vetement` int(11) NOT NULL,
  `id_taille` int(11) NOT NULL,
  `stock` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_vetement`,`id_taille`),
  KEY `id_taille` (`id_taille`),
  CONSTRAINT `est_dispo_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `est_dispo_ibfk_2` FOREIGN KEY (`id_taille`) REFERENCES `taille` (`id_taille`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `est_dispo`
--

LOCK TABLES `est_dispo` WRITE;
/*!40000 ALTER TABLE `est_dispo` DISABLE KEYS */;
INSERT INTO `est_dispo` VALUES (1,2,NULL),(1,3,NULL),(2,4,NULL),(3,2,NULL),(4,1,NULL),(5,5,NULL),(6,3,NULL),(7,4,NULL),(7,6,NULL),(8,1,NULL),(9,2,NULL),(10,3,NULL),(11,1,NULL),(11,5,NULL),(12,2,NULL),(13,3,NULL),(14,5,NULL),(15,4,NULL),(16,6,NULL),(17,1,NULL),(18,3,NULL),(19,2,NULL),(19,4,NULL),(19,5,NULL),(19,6,NULL),(20,4,NULL),(20,5,NULL),(20,6,NULL),(21,1,NULL),(22,2,NULL),(23,1,NULL),(24,5,NULL);
/*!40000 ALTER TABLE `est_dispo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `est_en`
--

DROP TABLE IF EXISTS `est_en`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `est_en` (
  `id_vetement` int(11) NOT NULL,
  `id_matiere` int(11) NOT NULL,
  PRIMARY KEY (`id_vetement`,`id_matiere`),
  KEY `id_matiere` (`id_matiere`),
  CONSTRAINT `est_en_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `est_en_ibfk_2` FOREIGN KEY (`id_matiere`) REFERENCES `matiere` (`id_matiere`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `est_en`
--

LOCK TABLES `est_en` WRITE;
/*!40000 ALTER TABLE `est_en` DISABLE KEYS */;
INSERT INTO `est_en` VALUES (1,1),(7,1),(12,1),(16,1),(20,1),(2,2),(6,2),(8,2),(13,2),(17,2),(22,2),(5,3),(9,3),(14,3),(18,3),(23,3),(3,4),(10,4),(21,4),(4,5),(11,5),(15,5),(19,5),(24,5);
/*!40000 ALTER TABLE `est_en` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `est_genre`
--

DROP TABLE IF EXISTS `est_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `est_genre` (
  `id_vetement` int(11) NOT NULL,
  `id_sexe` int(11) NOT NULL,
  PRIMARY KEY (`id_vetement`,`id_sexe`),
  KEY `id_sexe` (`id_sexe`),
  CONSTRAINT `est_genre_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `est_genre_ibfk_2` FOREIGN KEY (`id_sexe`) REFERENCES `sexe` (`id_sexe`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `est_genre`
--

LOCK TABLES `est_genre` WRITE;
/*!40000 ALTER TABLE `est_genre` DISABLE KEYS */;
INSERT INTO `est_genre` VALUES (1,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(2,2),(3,2),(4,2),(5,2),(6,2),(7,2),(8,2),(9,2),(10,2),(11,2),(13,2),(12,3),(14,3);
/*!40000 ALTER TABLE `est_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `etat`
--

DROP TABLE IF EXISTS `etat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `etat` (
  `id_etat` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_etat` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_etat`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `etat`
--

LOCK TABLES `etat` WRITE;
/*!40000 ALTER TABLE `etat` DISABLE KEYS */;
INSERT INTO `etat` VALUES (1,'En attente\r'),(2,'En cours de livraison\r'),(3,'Livré');
/*!40000 ALTER TABLE `etat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ligne_commande`
--

DROP TABLE IF EXISTS `ligne_commande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ligne_commande` (
  `id_vetement` int(11) NOT NULL,
  `id_commande` int(11) NOT NULL,
  `prix_unitaire` decimal(15,2) DEFAULT NULL,
  `quantite` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_vetement`,`id_commande`),
  KEY `id_commande` (`id_commande`),
  CONSTRAINT `ligne_commande_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `ligne_commande_ibfk_2` FOREIGN KEY (`id_commande`) REFERENCES `commande` (`id_commande`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ligne_commande`
--

LOCK TABLES `ligne_commande` WRITE;
/*!40000 ALTER TABLE `ligne_commande` DISABLE KEYS */;
INSERT INTO `ligne_commande` VALUES (1,1,19.99,1),(2,1,19.99,2),(3,1,24.99,1),(4,2,39.99,1),(5,2,20.99,1),(6,3,50.00,1),(7,4,25.99,2),(8,5,150.00,1),(9,6,89.99,4),(10,7,19.99,1),(11,7,25.99,2),(12,8,17.99,1),(13,9,19.99,1),(14,10,10.99,3);
/*!40000 ALTER TABLE `ligne_commande` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marque`
--

DROP TABLE IF EXISTS `marque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marque` (
  `id_marque` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_marque` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_marque`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marque`
--

LOCK TABLES `marque` WRITE;
/*!40000 ALTER TABLE `marque` DISABLE KEYS */;
INSERT INTO `marque` VALUES (1,'Nike\r'),(2,'Jack and Jones\r'),(3,'The North Face\r'),(4,'Calvin Klein\r'),(5,'Only\r'),(6,'Only & Sons\r'),(7,'Pull & Bear\r'),(8,'Levi\'s\r'),(9,'Ralph Lauren\r'),(10,'Stradivarius\r'),(11,'Bershka\r'),(12,'Jordan\r'),(13,'Brave Soul\r'),(14,'The North Face\r'),(15,'Carhartt\r'),(16,'Sans Marque');
/*!40000 ALTER TABLE `marque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matiere`
--

DROP TABLE IF EXISTS `matiere`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matiere` (
  `id_matiere` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_matiere` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_matiere`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matiere`
--

LOCK TABLES `matiere` WRITE;
/*!40000 ALTER TABLE `matiere` DISABLE KEYS */;
INSERT INTO `matiere` VALUES (1,'Coton\r'),(2,'Synthétique\r'),(3,'Cuir\r'),(4,'Polyester\r'),(5,'Polaire');
/*!40000 ALTER TABLE `matiere` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `panier`
--

DROP TABLE IF EXISTS `panier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `panier` (
  `id_vetement` int(11) NOT NULL,
  `id_users` int(11) NOT NULL,
  `quantite` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_vetement`,`id_users`),
  KEY `id_users` (`id_users`),
  CONSTRAINT `panier_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `panier_ibfk_2` FOREIGN KEY (`id_users`) REFERENCES `users` (`id_users`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `panier`
--

LOCK TABLES `panier` WRITE;
/*!40000 ALTER TABLE `panier` DISABLE KEYS */;
INSERT INTO `panier` VALUES (1,1,'1\r'),(2,2,'4\r'),(3,2,'3\r'),(4,1,'2\r'),(5,3,'2\r'),(6,5,'1'),(7,4,'1\r'),(10,1,'1\r'),(11,1,'1\r'),(18,5,'3\r'),(19,1,'1\r'),(20,5,'2\r');
/*!40000 ALTER TABLE `panier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `propose`
--

DROP TABLE IF EXISTS `propose`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `propose` (
  `id_vetement` int(11) NOT NULL,
  `id_marque` int(11) NOT NULL,
  PRIMARY KEY (`id_vetement`,`id_marque`),
  KEY `id_marque` (`id_marque`),
  CONSTRAINT `propose_ibfk_1` FOREIGN KEY (`id_vetement`) REFERENCES `vetement` (`id_vetement`),
  CONSTRAINT `propose_ibfk_2` FOREIGN KEY (`id_marque`) REFERENCES `marque` (`id_marque`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `propose`
--

LOCK TABLES `propose` WRITE;
/*!40000 ALTER TABLE `propose` DISABLE KEYS */;
INSERT INTO `propose` VALUES (1,1),(4,1),(2,4),(11,4),(13,4),(23,4),(7,5),(15,6),(20,6),(5,7),(18,7),(6,8),(21,8),(22,9),(8,10),(10,10),(3,11),(9,11),(16,12),(17,13),(19,14),(24,14),(12,15),(14,16);
/*!40000 ALTER TABLE `propose` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saison`
--

DROP TABLE IF EXISTS `saison`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `saison` (
  `id_saison` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_saison` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_saison`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saison`
--

LOCK TABLES `saison` WRITE;
/*!40000 ALTER TABLE `saison` DISABLE KEYS */;
INSERT INTO `saison` VALUES (1,'Printemps/Eté\r'),(2,'Automne/Hiver\r'),(3,'Toutes saisons');
/*!40000 ALTER TABLE `saison` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sexe`
--

DROP TABLE IF EXISTS `sexe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sexe` (
  `id_sexe` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_sexe` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_sexe`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sexe`
--

LOCK TABLES `sexe` WRITE;
/*!40000 ALTER TABLE `sexe` DISABLE KEYS */;
INSERT INTO `sexe` VALUES (1,'Homme\r'),(2,'Femme\r'),(3,'Unisexe');
/*!40000 ALTER TABLE `sexe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `style`
--

DROP TABLE IF EXISTS `style`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `style` (
  `id_style` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_style` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_style`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `style`
--

LOCK TABLES `style` WRITE;
/*!40000 ALTER TABLE `style` DISABLE KEYS */;
INSERT INTO `style` VALUES (1,'Streetwear\r'),(2,'Habillé\r'),(3,'Casual\r'),(4,'Classique\r'),(5,'Sportif');
/*!40000 ALTER TABLE `style` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taille`
--

DROP TABLE IF EXISTS `taille`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taille` (
  `id_taille` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_taille` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_taille`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taille`
--

LOCK TABLES `taille` WRITE;
/*!40000 ALTER TABLE `taille` DISABLE KEYS */;
INSERT INTO `taille` VALUES (1,'XS\r'),(2,'S\r'),(3,'M\r'),(4,'L\r'),(5,'XL\r'),(6,'XXL');
/*!40000 ALTER TABLE `taille` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `type_vetement`
--

DROP TABLE IF EXISTS `type_vetement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `type_vetement` (
  `id_type_vetement` int(11) NOT NULL AUTO_INCREMENT,
  `libelle_type_vetement` varchar(50) DEFAULT NULL,
  `id_saison` int(11) NOT NULL,
  PRIMARY KEY (`id_type_vetement`),
  KEY `id_saison` (`id_saison`),
  CONSTRAINT `type_vetement_ibfk_1` FOREIGN KEY (`id_saison`) REFERENCES `saison` (`id_saison`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `type_vetement`
--

LOCK TABLES `type_vetement` WRITE;
/*!40000 ALTER TABLE `type_vetement` DISABLE KEYS */;
INSERT INTO `type_vetement` VALUES (1,'T-Shirt',1),(2,'Pantalon',2),(3,'Jean',1),(4,'Sweatshirt',2),(5,'Pull',2),(6,'Gilet',3),(7,'Manteau',1),(8,'Echarpe',2),(9,'Sous-vêtements',3),(10,'Bonnets',1),(11,'Gants',2),(12,'Masques',1),(13,'Sous-Vetements',3),(14,'Veste',1);
/*!40000 ALTER TABLE `type_vetement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id_users` int(11) NOT NULL AUTO_INCREMENT,
  `nom_users` varchar(50) DEFAULT NULL,
  `prenom_users` varchar(50) DEFAULT NULL,
  `numtel_users` varchar(50) DEFAULT NULL,
  `email_users` varchar(50) DEFAULT NULL,
  `password_users` varchar(50) DEFAULT NULL,
  `Id_adresse` int(11) NOT NULL,
  PRIMARY KEY (`id_users`),
  KEY `Id_adresse` (`Id_adresse`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`Id_adresse`) REFERENCES `adresse` (`Id_adresse`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Becher','Thomas','123456789','email@test.com','null',1),(2,'Lebreuil','Thibault','123456789','email1@test.com','null',2),(3,'Munch','Valentin','123456789','email2@test.com','null',3),(4,'Valenne','Nathan','123456789','email3@test.com','null',4),(5,'Lagaffe','Gaston','123456789','email4@test.com','null',5),(6,'Maffiolini','Paul','123456789','email5@test.com','null',1),(7,'Monnier','David','123456789','email6@test.com','null',2),(8,'Toillion','Samuel','123456789','email7@test.com','null',1),(9,'Reberti','Jean Pierre','123456789','email8@test.com','null',4),(10,'Moulin','Jean','123456789','email9@test.com','null',1),(11,'Moulinier','Henry','123456789','email10@test.com','null',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vetement`
--

DROP TABLE IF EXISTS `vetement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vetement` (
  `id_vetement` int(11) NOT NULL AUTO_INCREMENT,
  `prix_vetement` decimal(15,2) DEFAULT NULL,
  `libelle_vetement` varchar(50) DEFAULT NULL,
  `id_type_vetement` int(11) NOT NULL,
  PRIMARY KEY (`id_vetement`),
  KEY `id_type_vetement` (`id_type_vetement`),
  CONSTRAINT `vetement_ibfk_1` FOREIGN KEY (`id_type_vetement`) REFERENCES `type_vetement` (`id_type_vetement`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vetement`
--

LOCK TABLES `vetement` WRITE;
/*!40000 ALTER TABLE `vetement` DISABLE KEYS */;
INSERT INTO `vetement` VALUES (1,19.99,'Tshirt Brun ',1),(2,19.99,'T-Shirt Gris ',1),(3,24.99,'Pantalon Wide Beige',2),(4,39.99,'Sweat bleu oversized',4),(5,20.99,'Gilet noir',6),(6,50.00,'Jean HIGH WAISTED MOM',3),(7,25.99,'Pull rouge',5),(8,150.00,'Manteau Off-white (couleur)',7),(9,89.99,'Veste/Doudoune sans manche beige',14),(10,19.99,'Echarpe rose',8),(11,25.99,'Sous-vêtements gris',13),(12,17.99,'Bonnet noir',10),(13,19.99,'gants rose',11),(14,10.99,'Masques en tissu noir x5',12),(15,20.99,'Pantalon Cargo Noir',2),(16,59.99,'Sweat Vert',4),(17,40.99,'Pull col roulé blanc',5),(18,30.99,'Jean bleu clair',3),(19,25.00,'Gilet Polaire rouge',6),(20,179.99,'Manteau vert olive',7),(21,189.99,'Veste polaire camel/bleue',14),(22,30.99,'Echarpe noire',8),(23,15.99,'Boxer noir pack de 3',9),(24,15.99,'Gants noirs',11);
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

-- Dump completed on 2022-02-03  8:55:36
