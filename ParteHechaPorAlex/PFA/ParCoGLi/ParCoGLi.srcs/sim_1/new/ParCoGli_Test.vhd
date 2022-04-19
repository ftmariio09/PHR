----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2022 14:51:15
-- Design Name: 
-- Module Name: ParCoGli_Test - Testeo
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

entity ParCoGli_Test is
    --  Port ( );
end ParCoGli_Test;

architecture Testeo of ParCoGli_Test is
    component parche
        Port ( sGlucosa, sInsulina, sNGlargina, sNLispro, sNGlucosa: IN std_logic;
             datAdicionales : INOUT std_logic;
             ledRGB : OUT std_logic_vector (2 downto 0);
             buzzer, bombaInsGlargina, bombaInsLispro : OUT std_logic);
    end component;
    FOR ALL: parche USE ENTITY WORK.ParCoGli(Arquitectura);
    -- POR HACER
begin


end Testeo;
