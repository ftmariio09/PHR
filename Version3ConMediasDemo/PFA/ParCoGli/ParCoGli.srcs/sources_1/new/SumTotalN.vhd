----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2022 13:24:59
-- Design Name: 
-- Module Name: SumTotalN - Behavioral
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

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2022 16:08:04
-- Design Name: 
-- Module Name: SumTotN - Behavioral
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

entity SumToN is
    GENERIC (N : NATURAL := 4);
    PORT (A, B: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         R : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         Carry: OUT STD_LOGIC);
end SumToN;

architecture Behavioral of SumToN is
    COMPONENT SumTot1Bit
        PORT (X, Y, CarryIn: IN STD_LOGIC; Suma, CarryOut: OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL CarryInt: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
begin
    general: FOR i IN 0 TO N-1 GENERATE
        primero: IF i = 0 GENERATE
            C_ini: SumTot1Bit PORT MAP (A(0), B(0), '0',  R(0), CarryInt(0)); END GENERATE;
        intermedio: IF i > 0 AND i < N-1 GENERATE
            C_int: SumTot1Bit PORT MAP (A(i), B(i), CarryInt(i-1), R(i), CarryInt(i)); END GENERATE;
        ultimo: IF i = N-1 GENERATE
            C_fin: SumTot1Bit PORT MAP (A(i), B(i), CarryInt(i-1), R(i), Carry); END GENERATE;
    END GENERATE;

end Behavioral;

