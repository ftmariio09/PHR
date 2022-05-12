----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 12:08:52
-- Design Name: 
-- Module Name: Comp_1 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Comparador de 1 bit con entradas de expansión.
ENTITY Comp_1 IS
    PORT (A, B, May_1, Igu_1, Men_1: IN STD_LOGIC;
         May, Igu, Men: OUT STD_LOGIC);
END Comp_1;
ARCHITECTURE Flujo OF Comp_1 IS
BEGIN
    May <= ((A AND (NOT B)) OR ((A XNOR B) AND May_1));
    Igu <= ((A XNOR B) AND Igu_1);
    Men <= (((NOT A) AND B) OR ((A XNOR B) AND Men_1));
END Flujo;
