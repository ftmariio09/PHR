----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 12:15:39
-- Design Name: 
-- Module Name: Utiles - Behavioral
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

library UNISIM;
use UNISIM.VComponents.all;

PACKAGE Utiles IS
    FUNCTION bin2ent (V: STD_LOGIC_VECTOR) RETURN INTEGER;
    FUNCTION ent2bin (E: INTEGER; L: NATURAL) RETURN STD_LOGIC_VECTOR;
    FUNCTION sum2bin (A, B: STD_LOGIC_VECTOR; L: NATURAL) RETURN STD_LOGIC_VECTOR;
    FUNCTION mult2bin (A, B: STD_LOGIC_VECTOR; L: NATURAL) RETURN STD_LOGIC_VECTOR;
END Utiles;

-- Cuerpo, formado por las operaciones necesarias para calcular esas funciones:
PACKAGE BODY Utiles IS
    -- Función que transforma un binario en entero:
    FUNCTION bin2ent (V: STD_LOGIC_VECTOR) RETURN INTEGER IS
        VARIABLE inter: INTEGER;
    BEGIN
        inter := 0;
        FOR i IN V'RANGE LOOP
            IF V(i) = '1' THEN inter := inter + 2**i;
            END IF;
        END LOOP;
        RETURN inter;
    END bin2ent;
    -- Función que transforma un entero en binario:
    FUNCTION ent2bin (E: INTEGER; L: NATURAL) RETURN STD_LOGIC_VECTOR IS
        VARIABLE inter: STD_LOGIC_VECTOR (L-1 DOWNTO 0);
        VARIABLE temp: INTEGER;
    BEGIN
        temp := E;
        FOR i IN 0 TO L-1 LOOP
            IF (temp MOD 2 = 1) THEN inter(i) := '1';
            ELSE inter(i) := '0';
            END IF;
            temp := temp/2;
        END LOOP;
        RETURN inter;
    END ent2bin;
    -- Continúa el cuerpo del paquete:
    -- Función que realiza la suma binaria:
    FUNCTION sum2bin (A, B: STD_LOGIC_VECTOR; L: NATURAL) RETURN STD_LOGIC_VECTOR IS
    BEGIN
        RETURN ent2bin(bin2ent(A)+bin2ent(B), L+1);
    END sum2bin;
    -- Función que realiza la multiplicación en binario:
    FUNCTION mult2bin (A, B: STD_LOGIC_VECTOR; L: NATURAL) RETURN STD_LOGIC_VECTOR IS
    BEGIN
        RETURN ent2bin(bin2ent(A)*bin2ent(B), 2*L);
    END mult2bin;
END Utiles;
