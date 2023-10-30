----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alvaro Castillo Perez
-- 
-- Create Date: 06.10.2023 02:18:09
-- Design Name: 
-- Module Name: controladorVGA - Behavioral
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

ENTITY controladorVGA IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        Spain : IN STD_LOGIC;
        LEFT : IN STD_LOGIC;
        RIGHT : IN STD_LOGIC;
        VS : OUT STD_LOGIC;
        HS : OUT STD_LOGIC;
        RED : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        BLU : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        GRN : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END controladorVGA;

ARCHITECTURE Behavioral OF controladorVGA IS

    COMPONENT Frec_Pixel
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            clk_pixel : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT Cont_Generic
        GENERIC (Bits : INTEGER := 8);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            resets : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR (Bits - 1 DOWNTO 0));
    END COMPONENT;

    COMPONENT Comparador
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
            O1 : OUT STD_LOGIC := '0'; --pulso apaga cañon
            O2 : OUT STD_LOGIC := '1'; --pulso de espera de tiempos
            O3 : OUT STD_LOGIC := '0'); --pulso de final de carro
    END COMPONENT;

    COMPONENT Dibuja
        GENERIC (
            BITS : INTEGER := 3);
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
    END COMPONENT;

    COMPONENT Gen_Color
        PORT (
            Blank_v : IN STD_LOGIC;
            Blank_h : IN STD_LOGIC;
            RED_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            GRN_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            BLU_in : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            RED : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            GRN : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            BLU : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
    END COMPONENT;
    SIGNAL clk_pixel_aux : STD_LOGIC;
    SIGNAL enable_and : STD_LOGIC;
    SIGNAL ejeX_aux, ejeY_aux : STD_LOGIC_VECTOR (9 DOWNTO 0);
    SIGNAL O1_aux1, O3_aux1, O1_aux2, O3_aux2 : STD_LOGIC;
    SIGNAL RED_aux, BLU_aux, GRN_aux : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL dataX_aux, dataY_aux : STD_LOGIC_VECTOR (9 DOWNTO 0);
BEGIN
    RelojPixel : Frec_Pixel
    PORT MAP(
        clk => clk,
        reset => reset,
        clk_pixel => clk_pixel_aux);

    enable_and <= clk_pixel_aux AND O3_aux1;

    ContadorX : Cont_Generic
    GENERIC MAP(
        Bits => 10)
    PORT MAP(
        clk => clk,
        reset => reset,
        resets => enable_and,
        enable => clk_pixel_aux,
        Q => ejeX_aux);

    ContadorY : Cont_Generic
    GENERIC MAP(
        Bits => 10)
    PORT MAP(
        clk => clk,
        reset => reset,
        resets => O3_aux2,
        enable => enable_and,
        Q => ejeY_aux);

    ComparadorX : Comparador
    GENERIC MAP(
        bits => 10,
        End_Of_Screen => 639,
        Start_Of_Pulse => 655,
        End_Of_Pulse => 751,
        End_Of_Line => 799)
    PORT MAP(
        clk => clk,
        reset => reset,
        data => ejeX_aux,
        O1 => O1_aux1,
        O2 => HS,
        O3 => O3_aux1);

    ComparadorY : Comparador
    GENERIC MAP(
        bits => 10,
        End_Of_Screen => 479,
        Start_Of_Pulse => 489,
        End_Of_Pulse => 491,
        End_Of_Line => 520)
    PORT MAP(
        clk => clk,
        reset => reset,
        data => ejeY_aux,
        O1 => O1_aux2,
        O2 => VS,
        O3 => O3_aux2);

    Coche : Dibuja
    PORT MAP(
        clk => clk,
        reset => reset,
        refresh => O3_aux2,
        left => LEFT,
        right => RIGHT,
        eje_x => ejeX_aux,
        eje_y => ejeY_aux,
        RED => RED_aux,
        GRN => GRN_aux,
        BLU => BLU_aux);

    CanonGenerador : Gen_Color
    PORT MAP(
        Blank_v => O1_aux2,
        Blank_h => O1_aux1,
        RED_in => RED_aux,
        GRN_in => GRN_aux,
        BLU_in => BLU_aux,
        RED => RED,
        GRN => GRN,
        BLU => BLU);

END Behavioral;