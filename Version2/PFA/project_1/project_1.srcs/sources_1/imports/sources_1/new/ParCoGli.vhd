----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2022 14:50:25
-- Design Name: 
-- Module Name: ParCoGli - Arquitectura
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

entity ParCoGli is
    Port ( sNGlargina, sNLispro, sNGlucosa: IN std_logic; -- Entradas digitales
         VpIn, VnIn, vauxp6, vauxn6, vauxp14, vauxn14 : in std_logic; -- vaux 6 es sensor insulina, vaux 14 es sensor glucosa: sGlucosa, sInsulina, 
         datAdicionales : INOUT std_logic;  --Datos adicionales -EN DESARROLLO CON LA ESP-32
         ledRGB : OUT std_logic_vector (2 downto 0);  -- Salidas del RGB
         buzzer, bombaInsGlargina, bombaInsLispro, bombaGlucosa : OUT std_logic;  -- Salidas del Buzzer y actuadores
         clk : in std_logic -- Senial de reloj
         -- led : out std_logic_vector (11 downto 0);
        );
end ParCoGli;

architecture Arquitectura of ParCoGli is
    Signal nivelInsulina, nivelGlucosa: STD_LOGIC_VECTOR (15 downto 4);
    Signal resultado_int : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    Signal dummy_int : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    Signal edaddr_in : STD_LOGIC_VECTOR (6 downto 0) := "0010110"; -- Son la MUX_address.
    -- It is related to the ADC AUX channel by:  MUX_address = ADC AUX channel + 16
    -- 00h es temperatura, 01h es resultado de Vccint,, 02h es Vccaux, 03h es Vp/Vn, 
    -- 04h es el resultado de medir Vrefp, 05h es el resultado de Vrefn, 06h es del Vccbram, 07h y 0Bh a 0Ch es INVALIDO, 08h es Supply A offset con ADC A,
    -- 09h es  el ADC A offset, 0Ah es ADC A gain error, 0Dh es Vccpint que es la conversion del PS supply, 0Eh es Vccpaux, 0fh es Vcco_ddr, 
    -- del 10h al 1Fh son los VAUXP[15:0]/VAUXN[15:0]
    -- Nosotros elegimos el pin 16h (canal 6 para Insulina) y el 1Eh (canal 14 para Glucosa)
    -- Esto va de 00h a 3Fh son registros de solo lectura, de un total de 00h a 7Fh
    -- 
    -- Para mas información, ver paginas 39 a 39 de https://docs.xilinx.com/v/u/en-US/ug480_7Series_XADC
    Signal e16daddr_in : STD_LOGIC_VECTOR (6 downto 0) := "0010110"; -- Son la MUX_address.
    Signal e1Edaddr_in : STD_LOGIC_VECTOR (6 downto 0) := "0011110"; -- Son la MUX_address.
    Signal eden_in: STD_LOGIC:='1';
    Signal edrdy_out: STD_LOGIC;
    Signal edwe_in : STD_LOGIC := '0';
    Signal echannel_out : STD_LOGIC_VECTOR (4 downto 0);
    Signal terminadoSec : STD_LOGIC := '0';
    Signal terminadoConv : STD_LOGIC := '0';
    Signal ereset_in : STD_LOGIC := '0';
    Signal ocupado, alarma : std_logic;
    Signal divisor : integer :=0;
    Signal leoGlucosaOInsulina : integer := 0;

    constant tamComp : natural := 12;

    Signal nivelGlucemico : STD_LOGIC_VECTOR (1 downto 0) := "00";
    constant hipoglucemia : STD_LOGIC_VECTOR (1 downto 0) := "11";
    constant normal : STD_LOGIC_VECTOR (1 downto 0) := "00";
    constant hiperglucemia : STD_LOGIC_VECTOR (1 downto 0) := "10";

    constant limitehipoglucemico : STD_LOGIC_VECTOR (15 downto 4) := ent2bin(71, tamComp);
    constant limitehiperglucemicoayunas : STD_LOGIC_VECTOR (15 downto 4) := ent2bin(99, tamComp);
    constant limitehiperglucemicocomidas : STD_LOGIC_VECTOR (15 downto 4) := ent2bin(199, tamComp);
    constant insulinaLetal : STD_LOGIC_VECTOR (15 downto 4) := ent2bin(15, tamComp); -- No inyectar insulina si la insulian ya está por encima de 15 en sangre, podría ser letal.

    SIGNAL G_1, E_1, L_1, G, E, L: STD_LOGIC; -- Hipoglucemia
    SIGNAL G_2, E_2, L_2, G2, E2, L2: STD_LOGIC; -- Hiperglucemia
    SIGNAL G_3, E_3, L_3, G3, E3, L3: STD_LOGIC; -- Insulina Letal
    SIGNAL unDia : integer := 86400; -- Para la siguiente inyeccion de glargina
    SIGNAL segundos : integer; -- Cuenta segundos hasta siguiente inyeccion de signal
    SIGNAL inyectoGlucosa : STD_LOGIC := '0';
    SIGNAL inyectoInsGlargina : STD_LOGIC := '0';
    SIGNAL inyectoInsLispro : STD_LOGIC := '0';
    SIGNAL tiempoinyectoInsGlargina : integer := 0;
    SIGNAL tiempoinyectoInsLispro : integer := 0;
    SIGNAL tiempoinyectoGlucosa : integer := 0;
    SIGNAL tiempoInyeccion : integer := 5; -- Supongamos que un inyector tarda unos 5 segundos en descargar su carga. Estamos simulándolo.

    -- POR HACER
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
            vauxp6          : in  STD_LOGIC;                         -- Auxiliary Channel 6
            vauxn6          : in  STD_LOGIC;
            vauxp14         : in  STD_LOGIC;                         -- Auxiliary Channel 14
            vauxn14         : in  STD_LOGIC;
            busy_out        : out  STD_LOGIC;                        -- ADC Busy signal
            channel_out     : out  STD_LOGIC_VECTOR (4 downto 0);    -- Channel Selection Outputs
            eoc_out         : out  STD_LOGIC;                        -- End of Conversion Signal
            eos_out         : out  STD_LOGIC;                        -- End of Sequence Signal
            alarm_out       : out STD_LOGIC;                         -- OR'ed output of all the Alarms
            vp_in           : in  STD_LOGIC;                         -- Dedicated Analog Input Pair
            vn_in           : in  STD_LOGIC
        );
    END COMPONENT;
    COMPONENT Comp_N
        GENERIC (N: NATURAL := 12);
        PORT (A, B: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
             G_1, E_1, L_1: IN STD_LOGIC; G, E, L: OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT encendedorBuzzy
        port (
            modopitido : in STD_LOGIC_VECTOR(1 downto 0);
            buzz : out STD_LOGIC;
            clk : in STD_LOGIC
        );
    END COMPONENT;
    component inyector
        port (
            ent : in STD_LOGIC;
            res : out STD_LOGIC
        );
    END COMPONENT;
    FOR ALL: Comp_N USE ENTITY WORK.Comp_N_Reu(Iterativa);
    FOR ALL: inyector USE ENTITY WORK.inyector(behavior);
    FOR ALL: encendedorBuzzy USE ENTITY WORK.encendedorBuzzy(behavior);
    --FOR ALL: xadc_wiz_0 USE ENTITY WORK.xadc_wiz_0(xilinx);
    -- POR HACER: LED RGB

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
            vauxp14,
            vauxn14,
            ocupado,
            echannel_out,
            terminadoConv,
            terminadoSec,
            alarma,
            VpIn,
            VnIn);
    CHipo: Comp_N GENERIC MAP (12) PORT MAP (nivelGlucosa, limitehipoglucemico, G_1, E_1, L_1, G, E, L);
    CHiper: Comp_N GENERIC MAP (tamComp) PORT MAP (nivelGlucosa, limitehiperglucemicoayunas, G_2, E_2, L_2, G2, E2, L2);
    CInsulinaLetal: Comp_N GENERIC MAP (tamComp) PORT MAP (nivelInsulina, insulinaLetal, G_3, E_3, L_3, G3, E3, L3);
    Buzzy: encendedorBuzzy PORT MAP (nivelGlucemico, buzzer, clk);
    InyectorbombaInsGlargina: inyector PORT MAP (inyectoInsGlargina, bombaInsGlargina);
    InyectorbombaInsLispro: inyector PORT MAP (inyectoInsLispro, bombaInsLispro);
    InyectorGlucosa: inyector PORT MAP (inyectoGlucosa, bombaGlucosa);

    process (clk) --PROCESO RELACIONADO CON RELOJES Y TIMERS
    begin
        if (rising_edge(clk)) then
            if (divisor >= 25000000) then -- Reloj central a 100 Mhz, debemos dividir tensión, 25000000 es 1 hercio
                if (leoGlucosaOInsulina < 5) then -- Para ignorar las dos primeras lecturas
                    leoGlucosaOInsulina <= leoGlucosaOInsulina +1;
                else
                    leoGlucosaOInsulina <= 2;
                end if;
                divisor <= 0;
                -- INYECCIONES 
                -- INSULINA LARGO PLAZO
                if (segundos >= unDia) then -- Cada día
                    tiempoinyectoInsGlargina <= tiempoInyeccion;
                    segundos <= 0;
                else
                    segundos <= segundos + 1;
                end if;
                if (tiempoinyectoInsGlargina < 1) then
                    inyectoInsGlargina <= '0';
                else
                    if (inyectoInsGlargina = '0') then
                        if (L3 = '0') then -- Inyecto insulina de corto plazo si no estamos en niveles letales
                            inyectoInsGlargina <= '0';
                        else
                            inyectoInsGlargina <= '1';
                        end if;
                    else  
                    end if;
                    tiempoinyectoInsGlargina <= tiempoinyectoInsGlargina -1;
                end if;
                -- INSULINA CORTO PLAZO 
                if (tiempoinyectoInsLispro < 1) then
                    inyectoInsLispro <= '0';
                else
                    if (inyectoInsLispro = '0') then
                        if (L3 = '0') then -- Inyecto insulina de corto plazo si no estamos en niveles letales
                            inyectoInsLispro <= '0';
                        else
                            inyectoInsLispro <= '1';
                        end if;
                    else
                    end if;
                    tiempoinyectoInsLispro <= tiempoinyectoInsLispro -1;
                end if;
                -- GLUCOSA
                if (tiempoinyectoGlucosa < 1) then
                    inyectoGlucosa <= '0';
                else
                    if (inyectoGlucosa = '0') then
                        inyectoGlucosa <= '1';
                    else
                    end if;
                    tiempoinyectoGlucosa <= tiempoinyectoGlucosa -1;
                end if;
            else
                divisor <= divisor + 1;
            end if;
        end if;
    end process;

    process (leoGlucosaOInsulina) --DIGO CUÁL ENTRADA LEER
    begin
        if (leoGlucosaOInsulina = 2) then -- Leo insulina
            edaddr_in <= e16daddr_in;
            nivelInsulina <= resultado_int(15 DOWNTO 4);
        else if (leoGlucosaOInsulina = 3) then -- Leo glucosa
                edaddr_in <= e1Edaddr_in;
                nivelGlucosa <= resultado_int(15 DOWNTO 4);
            else
        end if;
        end if;
    end process;
    -- POR HACER: FILTRO DE KALMANN
    -- Esto en teoría es un sistema de control
    process (leoGlucosaOInsulina) -- ANÁLISIS DEL PACIENTE
    begin
        if (leoGlucosaOInsulina = 4) then
            -- Esto sería a ajustar a la medida apropiada 
            if (L = '1') then
                nivelGlucemico <= hipoglucemia;
            else
                if (L2 = '1') then
                    nivelGlucemico <= hiperglucemia;
                else
                    nivelGlucemico <= normal;
                end if;
            end if;
        else
        end if;
    end process;
    process (nivelGlucemico) -- Inyectar la sustancia adecuada segun señal. SUPONEMOS QUE INYECTAR UNA PRIMERA VEZ LO ARREGLA
    begin
        if (nivelGlucemico = hipoglucemia) then
            tiempoinyectoInsLispro <= 0;
            tiempoinyectoGlucosa <= tiempoInyeccion;
        else if (nivelGlucemico = hiperglucemia) then
                tiempoinyectoInsLispro <= tiempoInyeccion;
                tiempoinyectoGlucosa <= 0;
            else -- MEDIDA DE SEGURIDAD, SI NO TENEMOS NI IDEA NO INYECTES NADA
                tiempoinyectoInsLispro <= 0;
                tiempoinyectoGlucosa <= 0;
            end if;
        end if;
    end process;

    process
    begin
    end process;

end Arquitectura;
