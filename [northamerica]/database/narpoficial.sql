-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 19-Fev-2023 às 08:44
-- Versão do servidor: 10.4.27-MariaDB
-- versão do PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `narpoficial`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_arrestedvehs`
--

CREATE TABLE `an_arrestedvehs` (
  `id` int(11) NOT NULL,
  `Owner` int(11) NOT NULL,
  `Vehid` int(11) NOT NULL,
  `Value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_atmrobb`
--

CREATE TABLE `an_atmrobb` (
  `id` int(11) NOT NULL,
  `plyid` int(11) NOT NULL,
  `atmdate` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_character`
--

CREATE TABLE `an_character` (
  `id` int(255) NOT NULL,
  `Playerid` int(255) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `SName` varchar(255) NOT NULL,
  `Age` varchar(255) NOT NULL,
  `User_group` varchar(255) NOT NULL DEFAULT 'desempregado',
  `Skin` varchar(255) NOT NULL,
  `TSkin` varchar(255) NOT NULL,
  `Walkstyle` varchar(255) NOT NULL,
  `Phone` varchar(255) NOT NULL,
  `Bank` varchar(255) NOT NULL,
  `MocStats` int(255) NOT NULL,
  `Food` int(25) NOT NULL,
  `Weather` int(255) NOT NULL,
  `Health` varchar(255) NOT NULL,
  `Armor` varchar(255) NOT NULL,
  `Position` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_chests`
--

CREATE TABLE `an_chests` (
  `id` varchar(255) NOT NULL,
  `pos` varchar(255) NOT NULL,
  `usedslots` varchar(255) NOT NULL DEFAULT '0',
  `maxslots` varchar(255) NOT NULL DEFAULT '500',
  `owner` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `an_chests`
--

INSERT INTO `an_chests` (`id`, `pos`, `usedslots`, `maxslots`, `owner`) VALUES
('10000001', '[ [ 1456.5, -1508.599, 15.325, 0, 0, 75 ] ]', '0', '5000', 10000001),
('10000002', '[ [ -2308.1, -132.128, 34.4, 0, 0, 90 ] ]', '0', '1500', 10000002),
('10000003', '[ [ -2337, -110.4, 29.334, 0, 0, 180 ] ]', '0', '1500', 10000003),
('10000004', '[ [ 2537.289, -1633.233, 13.1, 0, 0, 270 ] ]', '0', '1500', 10000004),
('10000005', '[ [ 2697.832, -1120.5, 68.59999999999999, 0, 0, -0.5 ] ]', '0', '1500', 10000005),
('10000006', '[ [ 2528, -1273.783, 34.023, 0, 0, 270 ] ]', '0', '1500', 10000006),
('10000007', '[ [ 1691.102, -2010.622, 13.2, 0, 0, 360 ] ]', '0', '1500', 10000007),
('10000008', '[ [ 2484.253, 1206, 9.845000000000001, 0, 0, 180.983 ] ]', '0', '1500', 10000008),
('10000009', '[ [ 1436.203, 2351.481, 16.603, 0, 0, 90 ] ]', '0', '1500', 10000009),
('2', '[ [ 1597.2715, 747.41315, 14.056621, 0, 0, 0 ] ]', '0', '300', 1),
('3', '[ [ 1583.1312, 741.27795, 14.006611, 0, 0, 90 ] ]', '0', '300', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_chests_item`
--

CREATE TABLE `an_chests_item` (
  `id` int(255) NOT NULL,
  `item_owner` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `item_count` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_clothing`
--

CREATE TABLE `an_clothing` (
  `id` int(255) NOT NULL,
  `plyid` int(255) NOT NULL,
  `skin` int(255) NOT NULL,
  `clotherid` varchar(255) NOT NULL,
  `typ` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_contas`
--

CREATE TABLE `an_contas` (
  `id` int(11) NOT NULL,
  `serial` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ip` varchar(255) NOT NULL,
  `username` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `password` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `whitelisted` tinyint(4) DEFAULT NULL,
  `Admin` int(4) DEFAULT NULL,
  `ban` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_death`
--

CREATE TABLE `an_death` (
  `id` int(255) NOT NULL,
  `playerid` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_houseobjects`
--

CREATE TABLE `an_houseobjects` (
  `id` int(11) NOT NULL,
  `Pos` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `ObjID` int(255) NOT NULL,
  `Owner` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_houses`
--

CREATE TABLE `an_houses` (
  `id` int(11) NOT NULL,
  `id_owner` int(11) NOT NULL,
  `id_acess` varchar(255) NOT NULL DEFAULT '[[0]]',
  `house_vehslot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_paytimes`
--

CREATE TABLE `an_paytimes` (
  `plyid` int(255) NOT NULL,
  `time` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_phonecontacts`
--

CREATE TABLE `an_phonecontacts` (
  `id` int(255) NOT NULL,
  `Owner` int(255) NOT NULL,
  `Phonenumber` varchar(255) NOT NULL,
  `Phonename` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_phonemessages`
--

CREATE TABLE `an_phonemessages` (
  `id` int(255) NOT NULL,
  `owner` int(255) NOT NULL,
  `message` text NOT NULL,
  `numbowner` varchar(255) NOT NULL,
  `numbsended` varchar(255) NOT NULL,
  `sendedname` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_prision`
--

CREATE TABLE `an_prision` (
  `plyid` int(255) NOT NULL,
  `time` int(255) NOT NULL,
  `prision` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_thunk`
--

CREATE TABLE `an_thunk` (
  `id` int(255) NOT NULL,
  `item_owner` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_count` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_useritem`
--

CREATE TABLE `an_useritem` (
  `id` int(255) NOT NULL,
  `item_owner` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_count` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_vehicle`
--

CREATE TABLE `an_vehicle` (
  `id` int(50) NOT NULL,
  `veicid` int(11) NOT NULL,
  `Account` int(11) NOT NULL,
  `Model` int(50) NOT NULL,
  `X` varchar(255) NOT NULL,
  `Y` varchar(255) NOT NULL,
  `Z` varchar(255) NOT NULL,
  `RotZ` varchar(255) NOT NULL,
  `interior` int(11) NOT NULL,
  `dimension` int(11) NOT NULL,
  `Colors` varchar(255) NOT NULL DEFAULT '[ [255, 255, 255] ]',
  `lightColor` varchar(255) NOT NULL DEFAULT '[ [255, 255, 255] ]',
  `Upgrades` varchar(255) NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]',
  `Paintjob` varchar(255) NOT NULL DEFAULT '0',
  `HP` int(255) NOT NULL DEFAULT 0,
  `Mala` int(255) NOT NULL DEFAULT 0,
  `Handlings` int(100) NOT NULL,
  `Fuel` int(11) NOT NULL,
  `Number` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `Toner` varchar(255) NOT NULL DEFAULT '0',
  `Variant` int(255) NOT NULL DEFAULT 0,
  `usedslots` varchar(255) NOT NULL,
  `Nome` text NOT NULL,
  `Snome` text NOT NULL,
  `Nitrous` int(11) DEFAULT 0,
  `vehtaxstatus` varchar(255) DEFAULT NULL,
  `Arrested` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_vehtax`
--

CREATE TABLE `an_vehtax` (
  `id` int(255) NOT NULL,
  `vehid` int(255) NOT NULL,
  `veh_owner` int(255) NOT NULL,
  `taxdate` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_vips`
--

CREATE TABLE `an_vips` (
  `id` int(255) NOT NULL,
  `plyid` int(255) NOT NULL,
  `viptype` varchar(255) NOT NULL,
  `time` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_wanted`
--

CREATE TABLE `an_wanted` (
  `plyid` int(255) NOT NULL,
  `time` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `an_weedplant`
--

CREATE TABLE `an_weedplant` (
  `id` int(255) NOT NULL,
  `pos` varchar(255) NOT NULL,
  `progress` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `ucp_name`
--

CREATE TABLE `ucp_name` (
  `id` int(11) NOT NULL,
  `old_name` varchar(255) NOT NULL,
  `new_name` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `owner` int(11) NOT NULL,
  `status` int(1) NOT NULL DEFAULT 0,
  `reason` varchar(250) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `ucp_serial`
--

CREATE TABLE `ucp_serial` (
  `id` int(255) NOT NULL,
  `serial` text NOT NULL,
  `reason` text NOT NULL,
  `owner` int(11) NOT NULL,
  `date` date NOT NULL,
  `accepted` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `ucp_whitelistrequest`
--

CREATE TABLE `ucp_whitelistrequest` (
  `id` int(255) NOT NULL,
  `passaporte` text NOT NULL,
  `discord` text NOT NULL,
  `realage` text NOT NULL,
  `ppersonalidade` text NOT NULL,
  `pidade` text NOT NULL,
  `safezone` text NOT NULL,
  `citerules` text NOT NULL,
  `date` date NOT NULL,
  `status` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `an_arrestedvehs`
--
ALTER TABLE `an_arrestedvehs`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_atmrobb`
--
ALTER TABLE `an_atmrobb`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_character`
--
ALTER TABLE `an_character`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_chests`
--
ALTER TABLE `an_chests`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_chests_item`
--
ALTER TABLE `an_chests_item`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_clothing`
--
ALTER TABLE `an_clothing`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_contas`
--
ALTER TABLE `an_contas`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_death`
--
ALTER TABLE `an_death`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_houseobjects`
--
ALTER TABLE `an_houseobjects`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_houses`
--
ALTER TABLE `an_houses`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_paytimes`
--
ALTER TABLE `an_paytimes`
  ADD PRIMARY KEY (`plyid`);

--
-- Índices para tabela `an_phonecontacts`
--
ALTER TABLE `an_phonecontacts`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_phonemessages`
--
ALTER TABLE `an_phonemessages`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_prision`
--
ALTER TABLE `an_prision`
  ADD PRIMARY KEY (`plyid`);

--
-- Índices para tabela `an_thunk`
--
ALTER TABLE `an_thunk`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_useritem`
--
ALTER TABLE `an_useritem`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_vehicle`
--
ALTER TABLE `an_vehicle`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_vehtax`
--
ALTER TABLE `an_vehtax`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_vips`
--
ALTER TABLE `an_vips`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `an_wanted`
--
ALTER TABLE `an_wanted`
  ADD PRIMARY KEY (`plyid`);

--
-- Índices para tabela `an_weedplant`
--
ALTER TABLE `an_weedplant`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `ucp_name`
--
ALTER TABLE `ucp_name`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `ucp_serial`
--
ALTER TABLE `ucp_serial`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `ucp_whitelistrequest`
--
ALTER TABLE `ucp_whitelistrequest`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `an_character`
--
ALTER TABLE `an_character`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `ucp_name`
--
ALTER TABLE `ucp_name`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `ucp_serial`
--
ALTER TABLE `ucp_serial`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `ucp_whitelistrequest`
--
ALTER TABLE `ucp_whitelistrequest`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
