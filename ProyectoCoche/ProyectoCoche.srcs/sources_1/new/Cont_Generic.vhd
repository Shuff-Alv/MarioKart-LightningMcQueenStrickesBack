----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alvaro Castillo Perez 
-- 
-- Create Date: 05.10.2023 12:56:38
-- Design Name: 
-- Module Name: Cont_Generic - Behavioral
-----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

ENTITY Cont_Generic IS
    GENERIC (Bits : INTEGER := 8);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        resets : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR (Bits - 1 DOWNTO 0));
END Cont_Generic;

ARCHITECTURE Behavioral OF Cont_Generic IS

    SIGNAL count, p_count : unsigned (Bits - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN

    Sinc : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            count <= (OTHERS => '0');

        ELSIF (rising_edge(clk)) THEN
            count <= p_count;
        END IF;
    END PROCESS;

    Comb : PROCESS (resets, enable, count)
    BEGIN
        IF (resets = '1') THEN
            p_count <= (OTHERS => '0');
        ELSIF (enable = '1') THEN
            p_count <= count + 1;
        ELSE
            p_count <= count;
        END IF;

        Q <= STD_LOGIC_VECTOR(count);
    END PROCESS;

END Behavioral;