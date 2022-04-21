----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2022 15:28:25
-- Design Name: 
-- Module Name: Conversor - Behavioral
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


entity Conversor is
    Port (
        clk : in std_logic;
        led : out std_logic_vector (9 downto 0);
        --JA : in STD_LOGIC_VECTOR (7 downto 0);
        --
        VpIn, VnIn, vauxp6, vauxn6, vauxp14, vauxn14 : in std_logic -- vaux 6 es sensor insulina, vaux 14 es sensor glucosa
    );
end Conversor;

architecture Behavioral of Conversor is
    Signal resultado_int : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    Signal dummy_int : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    Signal edaddr_in : STD_LOGIC_VECTOR (6 downto 0) := "0010110"; -- Son la MUX_address.
    -- It is related to the ADC AUX channel by:  MUX_address = ADC AUX channel + 16
    -- 00h es temperatura, 01h es resultado de Vccint,, 02h es Vccaux, 03h es Vp/Vn, 
    -- 04h es el resultado de medir Vrefp, 05h es el resultado de Vrefn, 06h es del Vccbram, 07h y 0Bh a 0Ch es INVALIDO, 08h es Supply A offset con ADC A,
    -- 09h es  el ADC A offset, 0Ah es ADC A gain error, 0Dh es Vccpint que es la conversion del PS supply, 0Eh es Vccpaux, 0fh es Vcco_ddr, 
    -- del 10h al 1Fh son los VAUXP[15:0]/VAUXN[15:0]
    -- Nosotros elegimos el pin 16h 
    -- Esto va de 00h a 3Fh son registros de solo lectura, de un total de 00h a 7Fh
    -- 
    -- Para mas inforación, ver paginas 39 a 39 de https://docs.xilinx.com/v/u/en-US/ug480_7Series_XADC
    Signal eden_in: STD_LOGIC:='1';
    Signal edrdy_out: STD_LOGIC;
    Signal edwe_in : STD_LOGIC := '0';
    Signal echannel_out : STD_LOGIC_VECTOR (4 downto 0);
    Signal terminadoSec : STD_LOGIC := '0';
    Signal terminadoConv : STD_LOGIC := '0';
    Signal ereset_in : STD_LOGIC := '0';
    Signal ocupado, alarma : std_logic;

    --    signal channel_out : std_logic_vector(4 downto 0);
    --    signal daddr_in  : std_logic_vector(6 downto 0);
    --    signal eoc_out : std_logic;
    --    signal do_out  : std_logic_vector(15 downto 0);
    --    signal anal_p, anal_n : std_logic;
    COMPONENT xadc_wiz_0
        port(
            daddr_in        : in  STD_LOGIC_VECTOR (6 downto 0);     -- Address bus for the dynamic reconfiguration port
            den_in          : in  STD_LOGIC;                         -- Enable Signal for the dynamic reconfiguration port
            di_in           : in  STD_LOGIC_VECTOR (15 downto 0);    -- Input data bus for the dynamic reconfiguration port
            dwe_in          : in  STD_LOGIC;                         -- Write Enable for the dynamic reconfiguration port
            do_out          : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
            drdy_out        : out  STD_LOGIC;                        -- Data ready signal for the dynamic reconfiguration port
            dclk_in         : in  STD_LOGIC;                         -- Clock input for the dynamic reconfiguration port
            reset_in        : in  STD_LOGIC;                         -- Reset signal for the System Monitor control logic
            vauxp6          : in  STD_LOGIC;                         -- Auxiliary Channel 5
            vauxn6          : in  STD_LOGIC;
            busy_out        : out  STD_LOGIC;                        -- ADC Busy signal
            channel_out     : out  STD_LOGIC_VECTOR (4 downto 0);    -- Channel Selection Outputs
            eoc_out         : out  STD_LOGIC;                        -- End of Conversion Signal
            eos_out         : out  STD_LOGIC;                        -- End of Sequence Signal
            alarm_out       : out STD_LOGIC;                         -- OR'ed output of all the Alarms
            vp_in           : in  STD_LOGIC;                         -- Dedicated Analog Input Pair
            vn_in           : in  STD_LOGIC
        );

    END COMPONENT;
    --FOR ALL: xadc_wiz_4 USE ENTITY WORK.xadc_wiz_4(xilinx);
begin

    uut:   xadc_wiz_0 PORT MAP(
            edaddr_in,
            eden_in,
            dummy_int,
            edwe_in,
            resultado_int,
            edrdy_out,
            clk,
            ereset_in,
            vauxp6,
            vauxn6,
            ocupado,
            echannel_out,
            terminadoConv,
            terminadoSec,
            alarma,
            VpIn,
            VnIn);
    --    inst_xadc : xadc_wiz_0
    --        port map
    --(
    --            daddr_in        => daddr_in,
    --            den_in          => eoc_out,
    --            di_in           => "0000000000000000",
    --            dwe_in          => '0',
    --            do_out          => do_out,
    --            drdy_out        => open,
    --            dclk_in         => clk,
    --            reset_in        => ereset_in,
    --            vauxp5          => VrefPos,
    --            vauxn5          => VrefNeg,
    --            busy_out        => open,
    --            channel_out     => channel_out,
    --            eoc_out         => eoc_out,
    --            eos_out         => open,
    --            alarm_out       => open,
    --            vp_in           => '0',
    --            vn_in           => '0'
    --        );
    --    daddr_in <= "00" & channel_out;
    --    anal_p <= JA(4);
    --    anal_n <= JA(0);
    --    led <= do_out;
    -- --    edaddr_in <= "00" & echannel_out;
    -- Tomo los 12 valores menores, los ajusto a 10 
    --    led <= do_out(15 DOWNTO 6);
    -- edaddr_in <= "00" & echannel_out;
    led <= resultado_int(15 DOWNTO 6);
    -- VER SI ESTA LÍNEA ES NECESARIA eden_in <= terminadoConv;
end Behavioral;
