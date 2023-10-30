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

ENTITY dibuja IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        refresh : IN STD_LOGIC;
        left : IN STD_LOGIC;
        right : IN STD_LOGIC;
        eje_x : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        eje_y : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        RED : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        GRN : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        BLU : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END dibuja;

ARCHITECTURE Behavioral OF Dibuja IS

    SIGNAL posX, posY : unsigned(9 DOWNTO 0);
    SIGNAL p_posX, p_posY : unsigned(9 DOWNTO 0);

BEGIN

    sinc : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            posX <= 50;
            posY <= 200;
        ELSIF (rising_edge(clk)) THEN
            posX <= p_posX;
            posY <= p_posY;
        END IF;
    END PROCESS;

    dibuja : PROCESS (posX, posY, left, right, refresh)
    BEGIN
        p_posX <= posX;
        p_posY <= posY;

        IF (refresh = '1') THEN
            IF (left = '1') AND (right = '0') THEN
                p_posX <= posX - 1;
            ELSIF (left = '0') AND (right = '1') THEN
                p_posX <= posX + 1;
            END IF;
        END IF;

        -- Parte de pintura 
        --FONDO
        RED <= "0000";
        BLU <= "1111";
        GRN <= "0000";
        --el rayo macqueen

        IF (posX < unsigned(eje_x) AND unsigned(eje_x) > posX + 16 AND posY < unsigned(eje_y) AND unsigned(eje_y) > posY + 32)
            RED <= "1111";
            BLU <= "0000";
            GRN <= "0000";
        END IF;
    END PROCESS;

END Behavioral;