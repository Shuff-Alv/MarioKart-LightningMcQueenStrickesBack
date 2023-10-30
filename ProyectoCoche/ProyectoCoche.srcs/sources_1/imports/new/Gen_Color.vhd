----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alvaro Castillo Perez
-- 
-- Create Date: 05.10.2023 19:08:59
-- Design Name: 
-- Module Name: Gen_Color - Behavioral
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

ENTITY Gen_Color IS
    PORT (
        Blank_v : IN STD_LOGIC;
        Blank_h : IN STD_LOGIC;
        RED_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        GRN_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        BLU_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        RED : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        GRN : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        BLU : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END Gen_Color;

ARCHITECTURE Behavioral OF Gen_Color IS
BEGIN
Color : Process (Blank_h, Blank_v, RED_in, GRN_in, BLU_in)
begin
    IF (Blank_h = '1' OR Blank_v = '1') THEN
        RED <= (OTHERS => '0');
        BLU <= (OTHERS => '0');
        GRN <= (OTHERS => '0');
    ELSE
        RED <= RED_in;
        BLU <= BLU_in;
        GRN <= GRN_in;
    END IF;
end process;
END Behavioral;