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

Entity encendedorBuzzy Is
    port (
        --        swt : in STD_LOGIC_VECTOR(7 downto 0);
        --        led : out STD_LOGIC_VECTOR(7 downto 0)
        modopitido : in STD_LOGIC_VECTOR(1 downto 0);
        buzz : out STD_LOGIC_VECTOR(0 downto 0);
        clk : in STD_LOGIC
    );
end encendedorBuzzy;

Architecture behavior of encendedorBuzzy Is

    Signal buzz_int : STD_LOGIC_VECTOR(0 downto 0) := "0";
    Signal divisor : integer := 0;

begin

    process (clk)
    begin
        if (rising_edge(clk)) then
            if (modopitido(1) = '1') then
                if (modopitido(0) = '1') then
                    if (divisor >= 25000000) then -- Reloj central a 100 Mhz, debemos dividir tensión, 25000000 es 1 hercio
                        buzz_int(0) <= NOT (buzz_int(0));
                        divisor <= 0;
                    else
                        divisor <= divisor + 1;
                    end if;
                else
                    if (divisor >= 100000000) then -- Reloj central a 100 Mhz, debemos dividir tensión, 100000000 es 1 hercio
                        buzz_int(0) <= NOT (buzz_int(0));
                        divisor <= 0;
                    else
                        divisor <= divisor + 1;
                    end if;
                end if;
            else
                buzz_int(0) <= '0';
            end if;
        end if;
        buzz <= buzz_int;

    end process;
end behavior;


