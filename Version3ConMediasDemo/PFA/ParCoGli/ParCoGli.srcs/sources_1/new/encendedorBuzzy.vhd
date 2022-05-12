----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 12:06:35
-- Design Name: 
-- Module Name: encendedorBuzzy - Behavior
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

Entity encendedorBuzzy Is
    port (
        --        swt : in STD_LOGIC_VECTOR(7 downto 0);
        --        led : out STD_LOGIC_VECTOR(7 downto 0)
        modopitido : in STD_LOGIC_VECTOR(1 downto 0);
        buzz : out STD_LOGIC;
        clk : in STD_LOGIC
    );
end encendedorBuzzy;

Architecture behavior of encendedorBuzzy Is

    Signal buzz_int : STD_LOGIC:= '0';
    Signal divisor : integer := 0;

begin

    process (clk, buzz_int)
    begin
        if (rising_edge(clk)) then
            if (modopitido(1) = '1') then
                if (modopitido(0) = '1') then
                    if (divisor >= 25000000) then -- Reloj central a 100 Mhz, debemos dividir tensión, 25000000 es 1 hercio
                        buzz_int <= NOT (buzz_int);
                        divisor <= 0;
                    else
                        divisor <= divisor + 1;
                    end if;
                else
                    if (divisor >= 100000000) then -- Reloj central a 100 Mhz, debemos dividir tensión, 100000000 es 1 hercio
                        buzz_int <= NOT (buzz_int);
                        divisor <= 0;
                    else
                        divisor <= divisor + 1;
                    end if;
                end if;
            else
                buzz_int <= '0';
            end if;
        end if;
        buzz <= buzz_int;

    end process;
end behavior;