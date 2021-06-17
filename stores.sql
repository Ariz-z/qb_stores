-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mer. 28 avr. 2021 à 13:05
-- Version du serveur :  10.4.18-MariaDB
-- Version de PHP : 8.0.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `es_extended`
--

-- --------------------------------------------------------

--
-- Structure de la table `gas_station_balance`
--

CREATE TABLE `store_balance` (
  `id` int(10) UNSIGNED NOT NULL,
  `market_id` varchar(50) NOT NULL,
  `income` bit(1) NOT NULL,
  `title` varchar(255) NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `date` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `gas_station_business`
--

CREATE TABLE `store_business` (
  `market_id` varchar(50) NOT NULL DEFAULT '',
  `user_id` varchar(50) NOT NULL,
  `stock` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `price` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `stock_upgrade` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `truck_upgrade` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `relationship_upgrade` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `money` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `total_money_earned` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `total_money_spent` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `gas_bought` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `gas_sold` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `distance_traveled` double UNSIGNED NOT NULL DEFAULT 0,
  `total_visits` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `customers` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `timer` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `gas_station_jobs`
--

CREATE TABLE `store_jobs` (
  `id` int(10) UNSIGNED NOT NULL,
  `market_id` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL,
  `reward` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `progress` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `gas_station_balance`
--
ALTER TABLE `store_balance`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Index pour la table `gas_station_business`
--
ALTER TABLE `store_business`
  ADD PRIMARY KEY (`market_id`) USING BTREE;

--
-- Index pour la table `store_jobs`
--
ALTER TABLE `store_jobs`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `gas_station_balance`
--
ALTER TABLE `store_balance`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `store_jobs`
--
ALTER TABLE `store_jobs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
