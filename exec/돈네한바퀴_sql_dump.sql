-- --------------------------------------------------------
-- 호스트:                          j9a705.p.ssafy.io
-- 서버 버전:                        11.1.2-MariaDB-1:11.1.2+maria~ubu2204 - mariadb.org binary distribution
-- 서버 OS:                        debian-linux-gnu
-- HeidiSQL 버전:                  12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- donnearound 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `donnearound` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `donnearound`;

-- 테이블 donnearound.exchange_record 구조 내보내기
CREATE TABLE IF NOT EXISTS `exchange_record` (
  `exchange_date` date NOT NULL,
  `foreign_currency_amount` int(11) NOT NULL,
  `korean_won_amount` int(11) NOT NULL,
  `preferential_rate` int(11) NOT NULL,
  `trading_base_rate` float NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `bank_code` varchar(255) NOT NULL,
  `country_code` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKshbsm33hs4ck8c5b9f8mh9qem` (`member_id`),
  CONSTRAINT `FKshbsm33hs4ck8c5b9f8mh9qem` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 donnearound.keyword 구조 내보내기
CREATE TABLE IF NOT EXISTS `keyword` (
  `create_time` datetime DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `administrative_area` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `country_code` varchar(255) NOT NULL,
  `locality` varchar(255) DEFAULT NULL,
  `sub_administrative_area` varchar(255) DEFAULT NULL,
  `sub_locality` varchar(255) DEFAULT NULL,
  `thoroughfare` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKimxgqgimqgen8o4go4k2msk6s` (`member_id`),
  CONSTRAINT `FKimxgqgimqgen8o4go4k2msk6s` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 donnearound.keyword_notification 구조 내보내기
CREATE TABLE IF NOT EXISTS `keyword_notification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) NOT NULL,
  `trade_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKs44nmc0wd5jwklwvpst9cjoyh` (`member_id`),
  KEY `FK5bdbnkqfmlbs1wyv4qtbcja57` (`trade_id`),
  CONSTRAINT `FK5bdbnkqfmlbs1wyv4qtbcja57` FOREIGN KEY (`trade_id`) REFERENCES `trade` (`id`),
  CONSTRAINT `FKs44nmc0wd5jwklwvpst9cjoyh` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 donnearound.member 구조 내보내기
CREATE TABLE IF NOT EXISTS `member` (
  `point` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `image_url` varchar(255) DEFAULT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `phonenumber` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `is_deleted` bit(1) DEFAULT NULL,
  `uid` varchar(255) DEFAULT NULL,
  `device_token` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 donnearound.member_roles 구조 내보내기
CREATE TABLE IF NOT EXISTS `member_roles` (
  `member_id` bigint(20) NOT NULL,
  `roles` enum('ROLE_ADMIN','ROLE_USER') DEFAULT NULL,
  KEY `FKet63dfllh4o5qa9qwm7f5kx9x` (`member_id`),
  CONSTRAINT `FKet63dfllh4o5qa9qwm7f5kx9x` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 donnearound.trade 구조 내보내기
CREATE TABLE IF NOT EXISTS `trade` (
  `foreign_currency_amount` int(11) NOT NULL,
  `is_deleted` bit(1) NOT NULL,
  `korean_won_amount` int(11) NOT NULL,
  `korean_won_per_foreign_currency` double NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `buyer_id` bigint(20) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `seller_id` bigint(20) NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `administrative_area` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `country_code` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `locality` varchar(255) DEFAULT NULL,
  `status` enum('COMPLETE','PROGRESS','WAIT') NOT NULL,
  `sub_administrative_area` varchar(255) DEFAULT NULL,
  `sub_locality` varchar(255) DEFAULT NULL,
  `thoroughfare` varchar(255) DEFAULT NULL,
  `thumbnail_image_url` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `type` enum('DELIVERY','DIRECT') NOT NULL,
  `delivery_address` varchar(255) DEFAULT NULL,
  `delivery_address_detail` varchar(255) DEFAULT NULL,
  `delivery_address_zip_code` varchar(255) DEFAULT NULL,
  `delivery_recipient_name` varchar(255) DEFAULT NULL,
  `delivery_recipient_tel` varchar(255) DEFAULT NULL,
  `direct_trade_location_detail` varchar(255) DEFAULT NULL,
  `direct_trade_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK9vko5ar4e6a7q1cfnaaudxlvu` (`buyer_id`),
  KEY `FK8tbptehdpyc1sep8ec3miyhui` (`seller_id`),
  CONSTRAINT `FK8tbptehdpyc1sep8ec3miyhui` FOREIGN KEY (`seller_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FK9vko5ar4e6a7q1cfnaaudxlvu` FOREIGN KEY (`buyer_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 donnearound.trade_image 구조 내보내기
CREATE TABLE IF NOT EXISTS `trade_image` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `trade_id` bigint(20) NOT NULL,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKjgn3ynktjwwi6p9tc70livfl` (`trade_id`),
  CONSTRAINT `FKjgn3ynktjwwi6p9tc70livfl` FOREIGN KEY (`trade_id`) REFERENCES `trade` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 donnearound.trade_like 구조 내보내기
CREATE TABLE IF NOT EXISTS `trade_like` (
  `create_time` datetime DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) NOT NULL,
  `trade_id` bigint(20) NOT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKgupiu16t2ptej9fqoofa8sh7h` (`member_id`),
  KEY `FK6nafyeq9oo3qh97mpa9x5b1gl` (`trade_id`),
  CONSTRAINT `FK6nafyeq9oo3qh97mpa9x5b1gl` FOREIGN KEY (`trade_id`) REFERENCES `trade` (`id`),
  CONSTRAINT `FKgupiu16t2ptej9fqoofa8sh7h` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 donnearound.trade_review 구조 내보내기
CREATE TABLE IF NOT EXISTS `trade_review` (
  `score` int(11) NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `reviewee_id` bigint(20) NOT NULL,
  `reviewer_id` bigint(20) NOT NULL,
  `trade_id` bigint(20) NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `comment` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKlldk4yw48ciycv8y8vdfmbf5c` (`reviewee_id`),
  KEY `FKp6my23sr7f75xvgm8t3mp4c08` (`reviewer_id`),
  KEY `FKp78n9u31dcfw3eevmt48yrlra` (`trade_id`),
  CONSTRAINT `FKlldk4yw48ciycv8y8vdfmbf5c` FOREIGN KEY (`reviewee_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKp6my23sr7f75xvgm8t3mp4c08` FOREIGN KEY (`reviewer_id`) REFERENCES `member` (`id`),
  CONSTRAINT `FKp78n9u31dcfw3eevmt48yrlra` FOREIGN KEY (`trade_id`) REFERENCES `trade` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

-- 테이블 donnearound.transfer 구조 내보내기
CREATE TABLE IF NOT EXISTS `transfer` (
  `amount` int(11) NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `trade_id` bigint(20) NOT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKpfnp1dg9n8atmacfgk3j8g7pl` (`trade_id`),
  CONSTRAINT `FKpfnp1dg9n8atmacfgk3j8g7pl` FOREIGN KEY (`trade_id`) REFERENCES `trade` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 내보낼 데이터가 선택되어 있지 않습니다.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
