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

    SIGNAL posX, posY : unsigned(8 DOWNTO 0); --Señal que almacena la ubicacion del pixel identificador del coche
    SIGNAL p_posX, p_posY : unsigned(8 DOWNTO 0); --Valor proximo de la ubicacion del pixel identificador
    TYPE state IS (REPOSO, PREP_MOV, IZQ, DER); --Estados de la MEF del coche
    SIGNAL estado, p_estado : state; --señales para controlar el cambio de estado

BEGIN

    sinc : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            posX <= "000110010";
            posY <= "011001000";
            estado <= REPOSO;
        ELSIF (rising_edge(clk)) THEN
            posX <= p_posX;
            posY <= p_posY;
            estado <= p_estado;
        END IF;
    END PROCESS;

    MEF_coche : PROCESS (posX, posY, left, right, refresh)
    BEGIN
        p_posX <= posX;
        p_posY <= posY;
        p_estado <= estado;

        CASE (estado) IS
            WHEN REPOSO =>
                -- IF (start = '1') THEN
                p_estado <= PREP_MOV;
                --END IF;

            WHEN PREP_MOV =>
                IF (left = '1' AND right = '0' AND refresh = '1') THEN
                    p_estado <= IZQ;
                ELSIF (left = '0' AND right = '1' AND refresh = '1') THEN
                    p_estado <= DER;
                END IF;

            WHEN IZQ =>
                IF (refresh = '1') THEN
                    p_posX <= posX - 1;
                END IF;

                IF ((left = '0' AND right = '0') OR (left = '1' AND right = '1')) THEN
                    IF (refresh = '1') THEN
                        p_estado <= PREP_MOV;
                    END IF;
                END IF;

            WHEN DER =>
                IF (refresh = '1') THEN
                    p_posX <= posX + 1;
                END IF;

                IF ((left = '0' AND right = '0') OR (left = '1' AND right = '1')) THEN
                    IF (refresh = '1') THEN
                        p_estado <= PREP_MOV;
                    END IF;
                END IF;
            WHEN OTHERS =>
                p_estado <= REPOSO;
        END CASE;
        -- Parte de pintura 
        --FONDO
        RED <= "0000";
        BLU <= "1111";
        GRN <= "0000";
        --el rayo macqueen

        IF ((posX < unsigned(eje_x) AND unsigned(eje_x) < (posX + 16))) THEN
            IF ((posY < unsigned(eje_y) AND unsigned(eje_y) < (posY + 32))) THEN
                RED <= "1111";
                BLU <= "0000";
                GRN <= "0000";
            END IF;
        END IF;

        IF (((posX + 7) < unsigned(eje_x) AND unsigned(eje_x) < (posX + 9))) THEN
            IF (((posY + 9) < unsigned(eje_y) AND unsigned(eje_y) < (posY + 23))) THEN
                RED <= "1111";
                BLU <= "0000";
                GRN <= "1111";
            END IF;
        END IF;

    END PROCESS;

    --    dibuja : PROCESS (posX, posY, left, right, refresh)
    --    BEGIN
    --        p_posX <= posX;
    --        p_posY <= posY;

    --        IF (refresh = '1') THEN
    --            IF (left = '1') AND (right = '0') THEN
    --                p_posX <= posX - 1;
    --            ELSIF (left = '0') AND (right = '1') THEN
    --                p_posX <= posX + 1;
    --            END IF;
    --        END IF;

END Behavioral;

--- IMPLEMENTAR COMO DIAGRAMA DE BOLAS