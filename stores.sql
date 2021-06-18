CREATE TABLE IF NOT EXISTS `store_balance` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `market_id` varchar(50) NOT NULL,
  `income` bit(1) NOT NULL,
  `title` varchar(50) NOT NULL,
  `amount` int(10) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `store_business` (
  `market_id` varchar(50) NOT NULL DEFAULT '',
  `citizenid` varchar(50) NOT NULL,
  `stock` varchar(50) NOT NULL DEFAULT '[]',
  `stock_upgrade` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `truck_upgrade` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `relationship_upgrade` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `money` int(10) unsigned NOT NULL DEFAULT 0,
  `total_money_earned` int(10) unsigned NOT NULL DEFAULT 0,
  `total_money_spent` int(10) unsigned NOT NULL DEFAULT 0,
  `goods_bought` int(10) unsigned NOT NULL DEFAULT 0,
  `distance_traveled` double unsigned NOT NULL DEFAULT 0,
  `total_visits` int(10) unsigned NOT NULL DEFAULT 0,
  `customers` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`market_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `store_jobs` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`market_id` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`reward` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`product` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
	`amount` INT(11) NOT NULL DEFAULT '0',
	`progress` BIT(1) NOT NULL DEFAULT b'0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

