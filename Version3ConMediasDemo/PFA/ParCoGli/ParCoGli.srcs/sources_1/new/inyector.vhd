----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 12:11:04
-- Design Name: 
-- Module Name: inyector - Behavioral
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

Entity inyector Is
    port (
        enable : in STD_LOGIC;
        clk : in STD_LOGIC;
        res : out STD_LOGIC_VECTOR(3 downto 0)
    );
end inyector;

Architecture behavior of inyector Is

    Signal estado : STD_LOGIC_VECTOR (3 downto 0) := "1000";
    Signal estado_anterior : STD_LOGIC_VECTOR (3 downto 0) := "1000";
    constant frecuencia : integer := 8000000; -- Frecuencia de rotacion, 25 millones para nuestro reloj es un cuarto de hercio
    Signal divisor : integer := 0;

begin
    process (clk, enable, estado)
    begin
        if (enable = '1') then
            -- Que el motor se mueva en ciertos ciclos
            if (rising_edge(clk)) then -- Divisor de tension, ahcemos que el motor vaya a una potencia determinada
                if (divisor >= frecuencia) then -- Reloj central a 100 Mhz, debemos dividir tensión, 25000000 es 1 hercio
                    estado_anterior <= estado;
                    case (estado_anterior) is
                            when "1010" => estado <= "1001"; -- Se va moviendo
                            when "1001" => estado <= "0101"; -- hacia la siguiente fase
                            when "0101" => estado <= "0110"; -- del motor
                            when "0110" => estado <= "1010"; -- para moverlo
                            when others => estado <= "1010"; -- En caso de error, pasamos a la primera fase
                        end case;
                    divisor <= 0;
                else
                    divisor <= divisor + 1;
                end if;
            else             
         end if;
        else
        -- Parar, que haga 0 ciclos.
        -- Nuestro motor es cuadrafasico, asi que no darle orden es no hacer nada.
        end if;
        res <= estado;
    end process;

end behavior;
