-- phpMyAdmin SQL Dump
-- version 4.0.10.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 11, 2015 at 06:28 PM
-- Server version: 5.5.35-cll-lve
-- PHP Version: 5.4.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `ilankleiman`
--

-- --------------------------------------------------------

--
-- Table structure for table `portfolio`
--

CREATE TABLE IF NOT EXISTS `portfolio` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `hash` text NOT NULL,
  `amount` text NOT NULL,
  `symbol` text NOT NULL,
  `price` text NOT NULL,
  `total` text NOT NULL,
  `transaction` text NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `portfolio`
--

INSERT INTO `portfolio` (`ID`, `username`, `password`, `hash`, `amount`, `symbol`, `price`, `total`, `transaction`, `time`) VALUES
(1, 'ilan', '', 'pass', '0', 'APPL', '126.32', '2147.44', 'afhvquUsDRme8Q7C', '2015-05-12 00:04:37'),
(2, 'ilan', '', 'pass', '17', 'APPL', '126.534744', '2151.090648', 'lfwmhPyfpERSAH5W', '2015-05-12 00:04:44'),
(3, 'ilan', '', 'pass', '17', 'APPL', '126.7498530648', '2154.7475021016', 'Vcyr4uY67Pb7vRUW', '2015-05-12 00:04:45'),
(4, 'ilan', '', 'pass', '17', 'APPL', '126.96532781501', '2158.41057285517', '5shsnaiWcznTPDB6', '2015-05-12 00:04:47'),
(5, 'ilan', '', 'pass', '0', 'APPL', '127.181168872296', '12718.1168872296', 'Jw2NtPa9rg87EyPs', '2015-05-12 00:05:11'),
(6, 'ilan', '', 'pass', '100', 'APPL', '128.452980561019', '12845.2980561019', 'K8XQ6UcZnqHl1OBC', '2015-05-12 00:05:13'),
(7, 'ilan', '', 'pass', '100', 'APPL', '129.737510366629', '12973.7510366629', 'zmuNDrNDmrrL6PNy', '2015-05-12 00:05:15'),
(8, 'ilan', '', 'pass', '100', 'APPL', '131.034885470295', '13103.4885470295', 'svwaq1SwDTrHjMGL', '2015-05-12 00:05:16'),
(9, 'ilan', '', 'pass', '100', 'APPL', '132.345234324998', '13234.5234324998', 'iTOGHZrwfPU1fnWm', '2015-05-12 00:05:18');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
