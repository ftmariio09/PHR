----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2022 13:26:31
-- Design Name: 
-- Module Name: SumadorTotal - Behavioral
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

ENTITY SumTot1Bit IS
    PORT (X, Y, CarryIn: IN STD_LOGIC; Suma, CarryOut: OUT STD_LOGIC);
END ENTITY SumTot1Bit;

ARCHITECTURE Funcional OF SumTot1Bit IS
BEGIN
    PROCESS (X, Y, CarryIn)
        VARIABLE A: STD_LOGIC_VECTOR (2 DOWNTO 0);
    BEGIN
        A := X&Y&CarryIn;
        CASE A IS
            WHEN "000" => CarryOut <= '0'; Suma <= '0';
            WHEN "001" => CarryOut <= '0'; Suma <= '1';
            WHEN "010" => CarryOut <= '0'; Suma <= '1';
            WHEN "011" => CarryOut <= '1'; Suma <= '0';
            WHEN "100" => CarryOut <= '0'; Suma <= '1';
            WHEN "101" => CarryOut <= '1'; Suma <= '0';
            WHEN "110" => CarryOut <= '1'; Suma <= '0';
            WHEN "111" => CarryOut <= '1'; Suma <= '1';
            WHEN others => CarryOut <= '0'; Suma <= '0';
        END CASE;
    END PROCESS;
END Funcional;
