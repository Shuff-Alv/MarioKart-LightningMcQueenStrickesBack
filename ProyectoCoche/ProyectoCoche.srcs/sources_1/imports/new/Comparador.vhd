----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alvaro Castillo Perez
-- 
-- Create Date: 05.10.2023 14:13:44
-- Design Name: 
-- Module Name: Comparador - Behavioral
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

ENTITY Comparador IS
    GENERIC (
        bits : INTEGER := 8;
        End_Of_Screen : INTEGER := 10;
        Start_Of_Pulse : INTEGER := 20;
        End_Of_Pulse : INTEGER := 30;
        End_Of_Line : INTEGER := 40);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        data : IN STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
        O1 : OUT STD_LOGIC; --pulso apaga cañon
        O2 : OUT STD_LOGIC; --pulso de espera de tiempos
        O3 : OUT STD_LOGIC); --pulso de final de carro
END Comparador;

ARCHITECTURE Behavioral OF Comparador IS
    SIGNAL p_O1 : STD_LOGIC := '0';
    SIGNAL p_O2 : STD_LOGIC := '0';
    SIGNAL p_O3 : STD_LOGIC := '0';

BEGIN

    sinc : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            O1 <= '0';
            O2 <= '0';
            O3 <= '0';
        ELSIF (rising_edge(clk)) THEN
            O1 <= p_O1;
            O2 <= p_O2;
            O3 <= p_O3;
        END IF;

    END PROCESS;

    comb : PROCESS (data)
    BEGIN
        IF (unsigned(data) > End_Of_Screen) THEN
            p_O1 <= '1';
        ELSE
            p_O1 <= '0';
        END IF;

        IF ((Start_Of_Pulse < unsigned(data)) AND (unsigned(data) < End_Of_Pulse)) THEN
            p_O2 <= '0';
        ELSE
            p_O2 <= '1';
        END IF;

        IF (unsigned(data) = End_Of_Line) THEN
            p_O3 <= '1';
        ELSE
            p_O3 <= '0';
        END IF;

    END PROCESS;
END Behavioral;