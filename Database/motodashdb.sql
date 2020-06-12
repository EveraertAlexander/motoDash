-- MySQL dump 10.13  Distrib 8.0.20, for Win64 (x86_64)
--
-- Host: localhost    Database: motodashdb
-- ------------------------------------------------------
-- Server version	5.5.5-10.3.17-MariaDB-0+deb10u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actions` (
  `actionid` varchar(20) NOT NULL,
  `description` varchar(345) DEFAULT NULL,
  `deviceid` varchar(50) NOT NULL,
  PRIMARY KEY (`actionid`),
  UNIQUE KEY `actionid_UNIQUE` (`actionid`),
  KEY `description_idx` (`description`),
  KEY `fk_actions_devices1_idx` (`deviceid`),
  CONSTRAINT `fk_actions_devices1` FOREIGN KEY (`deviceid`) REFERENCES `devices` (`deviceid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `avg_temp_month`
--

DROP TABLE IF EXISTS `avg_temp_month`;
/*!50001 DROP VIEW IF EXISTS `avg_temp_month`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `avg_temp_month` AS SELECT 
 1 AS `avg_temp`,
 1 AS `date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `avg_temp_ride`
--

DROP TABLE IF EXISTS `avg_temp_ride`;
/*!50001 DROP VIEW IF EXISTS `avg_temp_ride`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `avg_temp_ride` AS SELECT 
 1 AS `avg_temp`,
 1 AS `rideid`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devices` (
  `deviceid` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `measuringunit` varchar(45) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`deviceid`),
  UNIQUE KEY `deviceid_UNIQUE` (`deviceid`),
  UNIQUE KEY `device_UNIQUE` (`name`),
  KEY `name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history` (
  `reference` int(11) NOT NULL AUTO_INCREMENT,
  `value` float NOT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `actionid` varchar(20) NOT NULL,
  `rideid` int(11) NOT NULL,
  PRIMARY KEY (`reference`),
  UNIQUE KEY `reference_UNIQUE` (`reference`),
  KEY `fk_actionid_idx` (`actionid`),
  KEY `fk_history_ride1_idx` (`rideid`),
  CONSTRAINT `fk_actionID` FOREIGN KEY (`actionid`) REFERENCES `actions` (`actionid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_history_ride1` FOREIGN KEY (`rideid`) REFERENCES `rides` (`rideid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2718 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `max_accel_month`
--

DROP TABLE IF EXISTS `max_accel_month`;
/*!50001 DROP VIEW IF EXISTS `max_accel_month`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `max_accel_month` AS SELECT 
 1 AS `max_accel`,
 1 AS `date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `max_accel_ride`
--

DROP TABLE IF EXISTS `max_accel_ride`;
/*!50001 DROP VIEW IF EXISTS `max_accel_ride`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `max_accel_ride` AS SELECT 
 1 AS `max_accel`,
 1 AS `rideid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `max_angle_month`
--

DROP TABLE IF EXISTS `max_angle_month`;
/*!50001 DROP VIEW IF EXISTS `max_angle_month`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `max_angle_month` AS SELECT 
 1 AS `max_angle`,
 1 AS `date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `max_angle_ride`
--

DROP TABLE IF EXISTS `max_angle_ride`;
/*!50001 DROP VIEW IF EXISTS `max_angle_ride`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `max_angle_ride` AS SELECT 
 1 AS `max_angle`,
 1 AS `rideid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `max_temp_month`
--

DROP TABLE IF EXISTS `max_temp_month`;
/*!50001 DROP VIEW IF EXISTS `max_temp_month`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `max_temp_month` AS SELECT 
 1 AS `max_temp`,
 1 AS `date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `max_temp_ride`
--

DROP TABLE IF EXISTS `max_temp_ride`;
/*!50001 DROP VIEW IF EXISTS `max_temp_ride`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `max_temp_ride` AS SELECT 
 1 AS `max_temp`,
 1 AS `rideid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `min_accel_month`
--

DROP TABLE IF EXISTS `min_accel_month`;
/*!50001 DROP VIEW IF EXISTS `min_accel_month`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `min_accel_month` AS SELECT 
 1 AS `min_accel`,
 1 AS `date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `min_accel_ride`
--

DROP TABLE IF EXISTS `min_accel_ride`;
/*!50001 DROP VIEW IF EXISTS `min_accel_ride`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `min_accel_ride` AS SELECT 
 1 AS `min_accel`,
 1 AS `rideid`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `ride_durations`
--

DROP TABLE IF EXISTS `ride_durations`;
/*!50001 DROP VIEW IF EXISTS `ride_durations`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ride_durations` AS SELECT 
 1 AS `ride_duration`,
 1 AS `rideid`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rides`
--

DROP TABLE IF EXISTS `rides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rides` (
  `rideid` int(11) NOT NULL AUTO_INCREMENT,
  `starttime` datetime NOT NULL DEFAULT current_timestamp(),
  `ridename` varchar(45) DEFAULT 'MyRide',
  `description` varchar(345) DEFAULT NULL,
  PRIMARY KEY (`rideid`),
  UNIQUE KEY `rideid_UNIQUE` (`rideid`)
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `stats_ride`
--

DROP TABLE IF EXISTS `stats_ride`;
/*!50001 DROP VIEW IF EXISTS `stats_ride`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `stats_ride` AS SELECT 
 1 AS `rideid`,
 1 AS `startdate`,
 1 AS `ride_duration`,
 1 AS `ridename`,
 1 AS `description`,
 1 AS `max_angle`,
 1 AS `avg_temp`,
 1 AS `max_temp`,
 1 AS `max_accel`,
 1 AS `min_accel`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `summary_months`
--

DROP TABLE IF EXISTS `summary_months`;
/*!50001 DROP VIEW IF EXISTS `summary_months`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `summary_months` AS SELECT 
 1 AS `max_angle`,
 1 AS `avg_temp`,
 1 AS `max_temp`,
 1 AS `max_accel`,
 1 AS `min_accel`,
 1 AS `date`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'motodashdb'
--

--
-- Final view structure for view `avg_temp_month`
--

/*!50001 DROP VIEW IF EXISTS `avg_temp_month`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `avg_temp_month` AS select avg(`h`.`value`) AS `avg_temp`,date_format(`h`.`date`,'%M %Y') AS `date` from `history` `h` where `h`.`actionid` = 'TEMP' group by month(`h`.`date`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `avg_temp_ride`
--

/*!50001 DROP VIEW IF EXISTS `avg_temp_ride`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `avg_temp_ride` AS select avg(`history`.`value`) AS `avg_temp`,`history`.`rideid` AS `rideid` from `history` where `history`.`actionid` = 'TEMP' group by `history`.`rideid` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `max_accel_month`
--

/*!50001 DROP VIEW IF EXISTS `max_accel_month`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `max_accel_month` AS select max(`history`.`value`) AS `max_accel`,date_format(`history`.`date`,'%M %Y') AS `date` from `history` where `history`.`actionid` = 'ACCEL' group by month(`history`.`date`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `max_accel_ride`
--

/*!50001 DROP VIEW IF EXISTS `max_accel_ride`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `max_accel_ride` AS select max(`history`.`value`) AS `max_accel`,`history`.`rideid` AS `rideid` from `history` where `history`.`actionid` = 'ACCEL' group by `history`.`rideid` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `max_angle_month`
--

/*!50001 DROP VIEW IF EXISTS `max_angle_month`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `max_angle_month` AS select max(`history`.`value`) AS `max_angle`,date_format(`history`.`date`,'%M %Y') AS `date` from `history` where `history`.`actionid` = 'ANGLE' group by month(`history`.`date`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `max_angle_ride`
--

/*!50001 DROP VIEW IF EXISTS `max_angle_ride`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `max_angle_ride` AS select max(`history`.`value`) AS `max_angle`,`history`.`rideid` AS `rideid` from `history` where `history`.`actionid` = 'ANGLE' group by `history`.`rideid` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `max_temp_month`
--

/*!50001 DROP VIEW IF EXISTS `max_temp_month`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `max_temp_month` AS select max(`history`.`value`) AS `max_temp`,date_format(`history`.`date`,'%M %Y') AS `date` from `history` where `history`.`actionid` = 'TEMP' group by month(`history`.`date`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `max_temp_ride`
--

/*!50001 DROP VIEW IF EXISTS `max_temp_ride`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `max_temp_ride` AS select max(`history`.`value`) AS `max_temp`,`history`.`rideid` AS `rideid` from `history` where `history`.`actionid` = 'TEMP' group by `history`.`rideid` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `min_accel_month`
--

/*!50001 DROP VIEW IF EXISTS `min_accel_month`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `min_accel_month` AS select min(`history`.`value`) AS `min_accel`,date_format(`history`.`date`,'%M %Y') AS `date` from `history` where `history`.`actionid` = 'ACCEL' group by month(`history`.`date`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `min_accel_ride`
--

/*!50001 DROP VIEW IF EXISTS `min_accel_ride`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `min_accel_ride` AS select min(`history`.`value`) AS `min_accel`,`history`.`rideid` AS `rideid` from `history` where `history`.`actionid` = 'ACCEL' group by `history`.`rideid` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ride_durations`
--

/*!50001 DROP VIEW IF EXISTS `ride_durations`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ride_durations` AS select date_format(timediff(max(`h`.`date`),`r`.`starttime`),'%Hh %im') AS `ride_duration`,`r`.`rideid` AS `rideid` from (`rides` `r` left join `history` `h` on(`h`.`rideid` = `r`.`rideid`)) group by `r`.`rideid` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `stats_ride`
--

/*!50001 DROP VIEW IF EXISTS `stats_ride`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `stats_ride` AS select `r`.`rideid` AS `rideid`,date_format(`r`.`starttime`,'%d-%m-%Y') AS `startdate`,`d`.`ride_duration` AS `ride_duration`,`r`.`ridename` AS `ridename`,`r`.`description` AS `description`,`maxa`.`max_angle` AS `max_angle`,`at`.`avg_temp` AS `avg_temp`,`mt`.`max_temp` AS `max_temp`,`maxaccel`.`max_accel` AS `max_accel`,`minaccel`.`min_accel` AS `min_accel` from ((((((`rides` `r` left join `ride_durations` `d` on(`r`.`rideid` = `d`.`rideid`)) left join `max_angle_ride` `maxa` on(`maxa`.`rideid` = `r`.`rideid`)) left join `avg_temp_ride` `at` on(`r`.`rideid` = `at`.`rideid`)) left join `max_temp_ride` `mt` on(`r`.`rideid` = `mt`.`rideid`)) left join `max_accel_ride` `maxaccel` on(`r`.`rideid` = `maxaccel`.`rideid`)) left join `min_accel_ride` `minaccel` on(`r`.`rideid` = `minaccel`.`rideid`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `summary_months`
--

/*!50001 DROP VIEW IF EXISTS `summary_months`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`mysql`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `summary_months` AS select `ang`.`max_angle` AS `max_angle`,`at`.`avg_temp` AS `avg_temp`,`mt`.`max_temp` AS `max_temp`,`maxa`.`max_accel` AS `max_accel`,`mina`.`min_accel` AS `min_accel`,`ang`.`date` AS `date` from ((((`max_angle_month` `ang` left join `avg_temp_month` `at` on(`ang`.`date` = `at`.`date`)) left join `max_temp_month` `mt` on(`at`.`date` = `mt`.`date`)) left join `max_accel_month` `maxa` on(`mt`.`date` = `maxa`.`date`)) left join `min_accel_month` `mina` on(`maxa`.`date` = `mina`.`date`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-06-12 16:05:02
