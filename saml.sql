-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: saml
-- ------------------------------------------------------
-- Server version	11.2.3-MariaDB

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
-- Current Database: `saml`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `saml` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `saml`;

--
-- Table structure for table `cnfrmnc_migrations`
--

DROP TABLE IF EXISTS `cnfrmnc_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cnfrmnc_migrations` (
  `migration` varchar(191) NOT NULL,
  PRIMARY KEY (`migration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cnfrmnc_migrations`
--

LOCK TABLES `cnfrmnc_migrations` WRITE;
/*!40000 ALTER TABLE `cnfrmnc_migrations` DISABLE KEYS */;
INSERT INTO `cnfrmnc_migrations` VALUES ('_1_CreateSpConsentsTable.php'),('_2_CreateSpConsentRequestsTable.php');
/*!40000 ALTER TABLE `cnfrmnc_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cnfrmnc_sp_consent_requests`
--

DROP TABLE IF EXISTS `cnfrmnc_sp_consent_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cnfrmnc_sp_consent_requests` (
  `entity_id` varchar(255) NOT NULL,
  `challenge` char(64) NOT NULL,
  `created_at` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cnfrmnc_sp_consent_requests`
--

LOCK TABLES `cnfrmnc_sp_consent_requests` WRITE;
/*!40000 ALTER TABLE `cnfrmnc_sp_consent_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `cnfrmnc_sp_consent_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cnfrmnc_sp_consents`
--

DROP TABLE IF EXISTS `cnfrmnc_sp_consents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cnfrmnc_sp_consents` (
  `entity_id` varchar(255) NOT NULL,
  `created_at` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cnfrmnc_sp_consents`
--

LOCK TABLES `cnfrmnc_sp_consents` WRITE;
/*!40000 ALTER TABLE `cnfrmnc_sp_consents` DISABLE KEYS */;
/*!40000 ALTER TABLE `cnfrmnc_sp_consents` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-03-27 19:47:51
