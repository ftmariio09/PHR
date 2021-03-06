----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.04.2022 16:07:24
-- Design Name: 
-- Module Name: Inyector - Behavioral
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
        ent : in STD_LOGIC;
        res : out STD_LOGIC
    );
end inyector;

Architecture behavior of inyector Is

    Signal ent_int : STD_LOGIC := '0';

begin
     
    res <= ent_int;
    ent_int <= ent;

end behavior;
