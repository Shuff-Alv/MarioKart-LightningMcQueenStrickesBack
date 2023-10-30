----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Álvaro Castillo Pérez
-- 
-- Create Date: 26.10.2023 13:12:31
-- Design Name: 
-- Module Name: ControlCoche - Behavioral
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

ENTITY ControlCoche IS
    PORT (
        eje_x : IN STD_LOGIC;
        eje_y : IN STD_LOGIC;
        refresh : IN STD_LOGIC;
        left : IN STD_LOGIC;
        right : IN STD_LOGIC;
        RGB : OUT STD_LOGIC_VECTOR (0 DOWNTO 0));
END ControlCoche;

ARCHITECTURE Behavioral OF ControlCoche IS

BEGIN
END Behavioral;