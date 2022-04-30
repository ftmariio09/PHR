--------------------------------------------
-- Module Name: tutorial
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

Entity encendedorLed Is
    port (
        --        swt : in STD_LOGIC_VECTOR(7 downto 0);
        --        led : out STD_LOGIC_VECTOR(7 downto 0)
--        ja1: in std_logic_vector(0 downto 0);
--        ja2: out std_logic_vector(0 downto 0);
        swt : in STD_LOGIC_VECTOR(0 downto 0);
        led : out STD_LOGIC_VECTOR(0 downto 0)
    );
end encendedorLed;

Architecture behavior of encendedorLed Is

    Signal led_int : STD_LOGIC_VECTOR(0 downto 0) := "0";

begin
     
    led <= led_int;
    led_int(0) <= swt(0);

end behavior;


