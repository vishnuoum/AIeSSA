-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 21, 2022 at 05:50 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aiessa`
--

-- --------------------------------------------------------

--
-- Table structure for table `audio`
--

CREATE TABLE `audio` (
  `id` int(255) NOT NULL,
  `userId` int(255) NOT NULL,
  `label` varchar(50) NOT NULL,
  `path` text NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `audio`
--

INSERT INTO `audio` (`id`, `userId`, `label`, `path`, `date`) VALUES
(5, 1, 'Hello', './audioUploads\\20052022124756recording.wav', '2022-05-20 12:47:56'),
(6, 1, 'Hungry', './audioUploads\\20052022135539recording.wav', '2022-05-20 13:55:39'),
(7, 1, 'I want food', './audioUploads\\20052022135729recording.wav', '2022-05-20 13:57:29'),
(8, 1, 'I want to go to wash room', './audioUploads\\20052022135927recording.wav', '2022-05-20 13:59:27');

-- --------------------------------------------------------

--
-- Table structure for table `location`
--

CREATE TABLE `location` (
  `id` int(255) NOT NULL,
  `userId` int(255) NOT NULL,
  `latitude` varchar(20) NOT NULL,
  `longitude` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `location`
--

INSERT INTO `location` (`id`, `userId`, `latitude`, `longitude`) VALUES
(1, 1, '10.428575', '10.428575'),
(2, 1, '10.428575', '10.428575'),
(3, 1, '10.4285751', '10.4285751'),
(4, 1, '10.4285749', '10.4285749'),
(5, 1, '10.428575', '10.428575'),
(6, 1, '10.4285755', '10.4285755'),
(7, 1, '10.4285749', '10.4285749'),
(8, 1, '10.428575', '10.428575'),
(9, 1, '10.4285755', '10.4285755'),
(10, 1, '10.428575', '10.428575'),
(11, 1, '10.428575', '10.428575'),
(12, 1, '10.428575', '10.428575'),
(13, 1, '10.428575', '10.428575'),
(14, 1, '10.4285751', '10.4285751'),
(15, 1, '10.4285751', '10.4285751'),
(16, 1, '10.4285749', '10.4285749'),
(17, 1, '10.4285749', '10.4285749'),
(18, 1, '10.428575', '10.428575'),
(19, 1, '10.428575', '10.428575'),
(20, 1, '10.428575', '10.428575'),
(21, 1, '10.428575', '10.428575'),
(22, 1, '10.428575', '10.428575'),
(23, 1, '10.428575', '10.428575'),
(24, 1, '10.428575', '10.428575'),
(25, 1, '10.428575', '10.428575'),
(26, 1, '10.4285749', '10.4285749'),
(27, 1, '10.4285749', '10.4285749'),
(28, 1, '10.4285749', '10.4285749'),
(29, 1, '10.4285752', '10.4285752'),
(30, 1, '10.428575', '10.428575'),
(31, 1, '10.428575', '10.428575'),
(32, 1, '10.428575', '10.428575'),
(33, 1, '10.428575', '10.428575'),
(34, 1, '10.4285752', '10.4285752'),
(35, 1, '10.4285752', '10.4285752'),
(36, 1, '10.428575', '10.428575'),
(37, 1, '10.428575', '10.428575'),
(38, 1, '10.428575', '10.428575'),
(39, 1, '10.428575', '10.428575'),
(40, 1, '10.4284187', '10.4284187'),
(41, 1, '10.4284423', '10.4284423'),
(42, 1, '10.4285589', '10.4285589'),
(43, 1, '10.4285776', '10.4285776'),
(44, 1, '10.4283143', '10.4283143'),
(45, 1, '10.4282776', '10.4282776'),
(46, 1, '10.428575', '10.428575'),
(47, 6, '10.4285749', '10.4285749'),
(48, 6, '10.4285749', '10.4285749'),
(49, 6, '10.4286145', '10.4286145'),
(50, 6, '10.4285539', '10.4285539'),
(51, 6, '10.4285398', '10.4285398'),
(52, 1, '10.4285747', '10.4285747'),
(53, 1, '10.4285745', '10.4285745'),
(54, 1, '10.4285747', '10.4285747'),
(55, 1, '10.4285735', '10.4285735'),
(56, 1, '10.4285122', '10.4285122'),
(57, 1, '10.4285081', '10.4285081'),
(58, 1, '10.4285357', '10.4285357'),
(59, 1, '10.42849', '10.42849'),
(60, 1, '10.4284409', '10.4284409'),
(61, 1, '10.428343', '10.428343'),
(62, 1, '10.4283201', '10.4283201'),
(63, 1, '10.4283557', '10.4283557'),
(64, 1, '10.4283649', '10.4283649'),
(65, 1, '10.428365', '10.428365'),
(66, 1, '10.428365', '10.428365'),
(67, 1, '10.4283684', '10.4283684'),
(68, 1, '10.4283683', '10.4283683'),
(69, 1, '10.4283683', '10.4283683'),
(70, 1, '10.4283618', '10.4283618'),
(71, 1, '10.4285725', '10.4285725'),
(72, 1, '10.4285725', '10.4285725'),
(73, 1, '10.4285725', '10.4285725'),
(74, 1, '10.4285706', '10.4285706'),
(75, 1, '10.4285742', '10.4285742'),
(76, 1, '10.4285748', '10.4285748');

-- --------------------------------------------------------

--
-- Table structure for table `signprocessing`
--

CREATE TABLE `signprocessing` (
  `id` int(255) NOT NULL,
  `dateTime` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `signprocessing`
--

INSERT INTO `signprocessing` (`id`, `dateTime`) VALUES
(1, '2022-05-20 20:32:04'),
(2, '2022-05-20 20:32:39'),
(3, '2022-05-20 20:32:39'),
(4, '2022-05-21 03:57:44'),
(5, '2022-05-21 07:52:44'),
(6, '2022-05-21 08:35:46');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(255) NOT NULL,
  `username` varchar(30) NOT NULL,
  `companionName` varchar(50) NOT NULL,
  `companionMail` text NOT NULL,
  `mail` text NOT NULL,
  `password` varchar(100) NOT NULL,
  `deaf` varchar(5) NOT NULL DEFAULT 'no',
  `mute` varchar(5) NOT NULL DEFAULT 'no',
  `blind` varchar(5) NOT NULL DEFAULT 'no',
  `other` varchar(5) NOT NULL DEFAULT 'no',
  `joinDate` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `companionName`, `companionMail`, `mail`, `password`, `deaf`, `mute`, `blind`, `other`, `joinDate`) VALUES
(1, 'user', '', '', 'user@gmail.com', 'dcb694aa0322f143ed970e275c807bf123bd5db4f73140b94ccc757f42dc8043', 'no', 'yes', 'yes', 'no', '2022-05-20'),
(6, 'User1', 'Companion', 'companion@gmail.com', 'user1@gmail.com', '41ca9b6b3bff1e6c4cac2268534ad9e495a13c7084b28f7257c39ead9a48ac10', 'no', 'yes', 'yes', 'no', '2022-05-21');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audio`
--
ALTER TABLE `audio`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `location`
--
ALTER TABLE `location`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `signprocessing`
--
ALTER TABLE `signprocessing`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mail` (`mail`) USING HASH;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audio`
--
ALTER TABLE `audio`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `location`
--
ALTER TABLE `location`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT for table `signprocessing`
--
ALTER TABLE `signprocessing`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
