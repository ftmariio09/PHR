----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 11:56:02
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
        Port ( sNGlargina, sNLispro, sNGlucosa: IN std_logic; -- Entradas digitales
             VpIn, VnIn, vauxp6, vauxn6, vauxp14, vauxn14 : in std_logic; -- vaux 6 es sensor insulina, vaux 14 es sensor glucosa: sGlucosa, sInsulina, 
             datAdicionales : INOUT std_logic;  --Datos adicionales -EN DESARROLLO CON LA ESP-32
             ledRGB : OUT std_logic_vector (2 downto 0);  -- Salidas del RGB
             buzzer, bombaInsGlargina, bombaInsLispro, bombaGlucosa : OUT std_logic;  -- Salidas del Buzzer y actuadores
             clk : in std_logic -- Senial de reloj
             -- led : out std_logic_vector (11 downto 0);
            );
    end component;
    FOR ALL: parche USE ENTITY WORK.ParCoGli(Arquitectura);
    -- POR HACER
    SIGNAL glargina: std_logic := '1';
    SIGNAL lispro: std_logic := '1';
    SIGNAL glucosa : std_logic := '1';
    SIGNAL VpIn, VnIn, vauxp6, vauxn6, vauxp14, vauxn14 : std_logic;
    SIGNAL datAdicionales : std_logic;
    SIGNAL ledRGB : std_logic_vector (2 downto 0);
    SIGNAL buzzer, bombaInsGlargina, bombaInsLispro, bombaGlucosa : std_logic;
    SIGNAL clok : std_logic := '0';
begin
    aparato: parche PORT MAP (glargina, lispro, glucosa, VpIn, VnIn, vauxp6, vauxn6, vauxp14, vauxn14, datAdicionales, ledRGB, buzzer, bombaInsGlargina, bombaInsLispro, bombaGlucosa, clok);
    process
        variable i : integer := 0;
    begin
        for i in 0 to 127 loop
            clok <= '0';
            wait for 5 ns;
            clok <= '1';
            wait for 15 ns;
        end loop;
    end process;
    process
        variable j : integer := 0;
    begin
        for j in 0 to 127 loop
            wait for 15 ns;
            glargina <= '0';
            wait for 15 ns;
            glucosa <= '0';
            wait for 15 ns;
            lispro <= '0';
            wait for 15 ns;
            glucosa <= '1';
            wait for 15 ns;
            glargina <= '1';
            wait for 15 ns;
            lispro <= '1';
            wait for 15 ns;
        end loop;
    end process;
end Testeo;
