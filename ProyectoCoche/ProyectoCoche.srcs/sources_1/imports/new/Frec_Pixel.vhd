----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alvaro Castillo Perez 
-- 
-- Create Date: 05.10.2023 13:44:14
-- Design Name: 
-- Module Name: Frec_Pixel - Behavioral

----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

ENTITY Frec_Pixel IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        clk_pixel : OUT STD_LOGIC);
END Frec_Pixel;

ARCHITECTURE Behavioral OF Frec_Pixel IS

    SIGNAL count, p_count : unsigned(1 DOWNTO 0) := (OTHERS => '0');

BEGIN

    sinc : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            count <= (OTHERS => '0');

        ELSIF (rising_edge(clk)) THEN
            count <= p_count;

        END IF;
    END PROCESS;

    comb : PROCESS (count)
    BEGIN
        IF (count = "11") THEN
            p_count <= (OTHERS => '0');
            clk_pixel <= '1';

        ELSE
            p_count <= count + 1;
            clk_pixel <= '0';

        END IF;
    END PROCESS;
END Behavioral;