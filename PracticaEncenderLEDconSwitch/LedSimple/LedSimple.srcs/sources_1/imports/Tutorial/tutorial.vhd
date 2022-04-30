--------------------------------------------
-- Module Name: tutorial
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

--Entity encendedorLed Is
--    port (
--        --        swt : in STD_LOGIC_VECTOR(7 downto 0);
--        --        led : out STD_LOGIC_VECTOR(7 downto 0)
--        swt : in STD_LOGIC_VECTOR(0 downto 0);
--        led : out STD_LOGIC_VECTOR(0 downto 0)
--    );
--end encendedorLed;

--Architecture behavior of encendedorLed Is

--    Signal led_int : STD_LOGIC_VECTOR(0 downto 0) := "0";

--begin

--    led <= led_int;
--    led_int(0) <= swt(0);

--end behavior;

Entity encendedorLed Is
    port (
        --        swt : in STD_LOGIC_VECTOR(7 downto 0);
        --        led : out STD_LOGIC_VECTOR(7 downto 0)
        swt : in STD_LOGIC_VECTOR(0 downto 0);
        led : out STD_LOGIC_VECTOR(0 downto 0);
        clk : in STD_LOGIC
    );
end encendedorLed;

Architecture behavior of encendedorLed Is

    Signal led_int : STD_LOGIC_VECTOR(0 downto 0) := "0";
    Signal divisor : integer := 0;

begin

    process (clk)
    begin
        if (rising_edge(clk)) then
            if (swt(0) = '1') then
                if (divisor >= 1000000000) then -- Reloj central a 100 Mhz, debemos dividir tensión, 1000000000 es 1 hercio
                    led_int(0) <= NOT (led_int(0));
                    divisor <= 0;
                else
                    divisor <= divisor + 1;
                end if;
            else 
        end if;
        end if;

        --        if swt(0) = '1' then
        --            if (clk'event and clk = '1') then
        --                led <= led_int;
        --                led_int(0) <= NOT (led_int(0));
        --            else 
        --            end if;
        --        else 
        --        end if;
        led <= led_int;

    end process;
end behavior;


