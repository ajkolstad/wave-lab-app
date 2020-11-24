-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 22, 2020 at 06:43 AM
-- Server version: 10.4.16-MariaDB
-- PHP Version: 7.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wave_lab_database`
--

-- --------------------------------------------------------

--
-- Table structure for table `depth_data`
--

CREATE TABLE `depth_data` (
  `Ddate` datetime NOT NULL,
  `Depth` float NOT NULL,
  `Depth_Flume_Name` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `depth_data`
--

INSERT INTO `depth_data` (`Ddate`, `Depth`, `Depth_Flume_Name`) VALUES
('2020-11-19 21:48:21', 0.25, 0),
('2020-11-19 21:48:32', 0.92, 1);

-- --------------------------------------------------------

--
-- Table structure for table `target_depth`
--

CREATE TABLE `target_depth` (
  `Tdepth` float NOT NULL,
  `Target_Flume_Name` int(11) NOT NULL,
  `Tdate` datetime NOT NULL,
  `Username` varchar(255) NOT NULL,
  `isComplete` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `target_depth`
--

INSERT INTO `target_depth` (`Tdepth`, `Target_Flume_Name`, `Tdate`, `Username`, `isComplete`) VALUES
(2, 0, '2020-11-21 01:48:48', 'ajkolstad', 0),
(2.78, 1, '2020-11-21 02:34:20', 'ajkolstad', 0);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `Username` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`Username`, `Password`, `Name`) VALUES
('admin', 'password', 'Doctor Wave'),
('ajkolstad', 'test', 'Alex Kolstad');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `depth_data`
--
ALTER TABLE `depth_data`
  ADD PRIMARY KEY (`Ddate`);

--
-- Indexes for table `target_depth`
--
ALTER TABLE `target_depth`
  ADD PRIMARY KEY (`Tdate`),
  ADD KEY `Username` (`Username`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`Username`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `target_depth`
--
ALTER TABLE `target_depth`
  ADD CONSTRAINT `target_depth_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `user` (`Username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
