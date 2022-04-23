----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2022 16:04:21
-- Design Name: 
-- Module Name: media - Behavioral
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
USE WORK.Utiles.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--Componente que calcula la media de los ultimos N datos recividos

entity media is
    GENERIC (N: NATURAL := 10);
    Port ( DatIn: IN integer; MediaOut: OUT integer);
end media;

architecture Behavioral of media is
    TYPE cola_N IS ARRAY (0 TO (N - 1)) OF integer;
begin
    process(DatIn)
        variable numDatos: integer := 0;
        variable ultimo: integer := 0;
        variable cola: cola_N;
        variable sumaAux: integer :=0;
    begin
    if(numDatos < N) then
        cola(numDatos):= DatIn;
        numDatos := numDatos + 1;
    else
        cola(ultimo):= DatIn;
        if(ultimo = N) then ultimo := 0;
        else 
            ultimo := ultimo + 1;
        end if;
    end if; 
    
    for i IN (0 to numDatos) loop
        sumaAux := cola(i) + sumaAux;
    end loop;
    
    MediaOut <= sumaAux / numDatos;
    
    end process ;

end Behavioral;
