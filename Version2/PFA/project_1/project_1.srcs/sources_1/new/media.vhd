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
--USE WORK.Utiles.ALL;

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
    process
        variable numDatos: integer:=0;
        variable ultimo: integer:=0;
        variable cola: cola_N;
        variable sumaAux: integer:=0;
    begin

        wait ON DatIn;

        if(numDatos = 0) then
            for i in 1 to (N - 1) loop
                cola(i):= 0;
            end loop;
            cola(0):= DatIn;
        end if; 

        if(numDatos < N) then
            cola(numDatos):= DatIn;
            numDatos := numDatos + 1;
        else
            cola(ultimo):= DatIn;
            if(ultimo = N -1 ) then ultimo := 0;
            else
                ultimo := ultimo + 1;
            end if;
        end if;
        sumaAux := 0;
        for i IN 0 to (N - 1) loop
            sumaAux := cola(i) + sumaAux;
        end loop;

        MediaOut <= (sumaAux / numDatos);

    end process ;
end Behavioral;

--architecture test_media of media is
--    component calcula_media
--        generic(N: integer := 5);
--        port(DatIn: IN integer; MediaOut: OUT integer);
--    end component;

--    for all: calcula_media  use entity work.media(Behavioral);

--    signal entrada: integer;
--    signal salida: integer;

--begin
--    circuito: calcula_media port map(entrada, salida);
--    entrada <= 0 after 0ns, 3 after 5ns, 4 after 15ns, 3 after 25ns, 4 after 35ns, 5 after 45ns,
-- 10 after 55ns, 2 after 65ns, 40 after 75ns, 3 after 85ns, 8 after 95ns;
--end test_media;


