CREATE DATABASE IF NOT EXISTS `climb`
USE `climb`;

CREATE TABLE IF NOT EXISTS `maps` (
  `name` text NOT NULL,
  `pos` text NOT NULL,
  `ang` text NOT NULL,
  `pay` float NOT NULL DEFAULT '2500',
  `tops` longtext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `maps` (`name`, `pos`, `ang`, `pay`, `tops`) VALUES
('xc_cliff_of_kamoon', '1787.750, -7643.687, -63.968', '0, -90, 0', 2700, NULL),
('xc_cliffez', '242.71875, 753, 6323.031', '0, -90, 0', 3600, NULL),
('xc_complex', '-640, -1000, 112', '0, 0, 0', 7500, NULL),
('xc_dtt_anthologie3', '5800, -4700, 6176', '0, 90, 0', 9600, NULL),
('xc_dtt_hope', '90, 75, 8256', '0, -180, 0', 9700, NULL),
('xc_dtt_tixi', '6204, -975, 2655', '0, 90, 0', 6200, NULL),
('xc_easyclimb', '2079, -107, 1536', '0, 180, 0', 5600, NULL),
('xc_factory_gm', '-1184, -1392, 1176', '0, 0, 0', 3600, NULL),
('xc_flow', '3210, -1500, 66', '0, 0, 0', 4500, NULL),
('xc_galaxy', '890, -2625, 1582', '0, 0, 0', 3500, NULL),
('xc_into_the_mainframe_v4', '-2544, -496, 44', '0, 45, 0', 20000, NULL),
('xc_karo3_v2', '425, 683, -579.03125', '0, 90, 0', 4000, NULL),
('xc_medium_vxx', '-243, -376, 4682', '0, -90, 0', 9000, NULL),
('xc_nature', '2215, 5700, 1536', '0, 180, 0', 2800, NULL),
('xc_natureblock', '-432, 1635, 2560', '0, 135, 0', 3000, NULL),
('xc_obsidian', '-1625, -2875, 7936', '0, 0, 0', 7200, NULL),
('xc_paris', '3509.8125, -654.78125, 3168.03125', '0, 0, 0', 4800, NULL),
('xc_peak', '1550, 1325, 2240', '0, -180, 0', 4200, NULL),
('xc_pharaoh_v2', '5287, 8593, 1088', '0, 180, 0', 7500, NULL),
('xc_piscine_v2', '-177, -2918, 1344.03125', '0, 180, 0', 3200, NULL),
('xc_rat_bath_v3', '-113, 2922, 238.54125', '0, 90, 0', 4500, NULL),
('xc_rat_kit_v2', '-14050, 560, -14265', '0, 90, 0', 4000, NULL),
('xc_sanctuary', '-69, 1987, 4222', '0, -90, 0', 5000, NULL),
('xc_sanctuary2', '1832, 665, 3240', '0, 90, 0', 15000, NULL),
('xc_sewers', '-925, -1270, 1288', '0, 90, 0', 4500, NULL),
('xc_stonetowers_v2', '256, 364, 8792', '0, -90, 0', 4200, NULL),
('xc_toonrun2_gm', '-2245, -546, -1376', '0, 180, 0', 4800, NULL),
('xc_toonrun3', '3301, -7583, 0', '0, -90, 0', 7000, NULL),
('xc_unknownposition', '5869, -1525, 696', '0, 0, 0', 3200, NULL),
('xc_water_light_blue', '-304, -1635, 10880', '0, 0, 0', 5600, NULL),
('xc_7in1_gm', '-14050, 10975, 8.03', '0, -90, 0', 7200, NULL),
('xc_azteclimb', '-9100, -7650, 2048', '0, -90, 0', 6000, NULL),
('xc_canyon', '-4658.5, -554.71875, 1280.03125', '0, 0, 0', 5400, NULL),
('xc_xand', '3513, 5910, 2858.2', '0, -180, 0', 5000, NULL);

CREATE TABLE IF NOT EXISTS `players` (
  `sid` bigint(64) NOT NULL COMMENT 'SteamID64',
  `name` text COMMENT 'Name',
  `wins` int(32) NOT NULL COMMENT 'Total Wins',
  `time` int(64) NOT NULL COMMENT 'Total Time',
  `saves` int(32) NOT NULL COMMENT 'Total Saves',
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
