----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 12:09:53
-- Design Name: 
-- Module Name: Comp_N_Reu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY Comp_N_Reu IS
    GENERIC (N: NATURAL := 12);
    PORT (A, B: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         G_1, E_1, L_1: IN STD_LOGIC; G, E, L: OUT STD_LOGIC);
END Comp_N_Reu;
ARCHITECTURE Iterativa OF Comp_N_Reu IS
    -- En este caso, nombre compon. debe ser = nombre entidad.
    COMPONENT Comp_1
        PORT (A, B, May_1, Igu_1, Men_1: IN STD_LOGIC;
             May, Igu, Men: OUT STD_LOGIC);
    END COMPONENT;
    -- No hay que utilizar la sentencia: "FOR ALL: ... USE ENTITY ...;
    -- pues la sentencia GENERATE ya lo referencia.
    SIGNAL X, Y, Z: STD_LOGIC_VECTOR(1 TO N-1);
BEGIN
    general: FOR i IN 0 TO N-1 GENERATE
        primero: IF i = 0 GENERATE
            C_ini: Comp_1 PORT MAP (A(0), B(0), G_1, E_1, L_1,
                         X(1), Y(1), Z(1)); END GENERATE;
        intermedio: IF i > 0 AND i < N-1 GENERATE
            C_int: Comp_1 PORT MAP (A(i), B(i), X(i), Y(i), Z(i),
                         X(i+1), Y(i+1), Z(i+1)); END GENERATE;
        ultimo: IF i = N-1 GENERATE
            C_fin: Comp_1 PORT MAP (A(i), B(i), X(i), Y(i), Z(i),
                         G, E, L); END GENERATE;
    END GENERATE;
END Iterativa;
