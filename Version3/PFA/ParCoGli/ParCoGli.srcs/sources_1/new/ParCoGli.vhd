----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 11:53:26
-- Design Name: 
-- Module Name: ParCoGli - Behavioral
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
    Port (sNGlargina, sNLispro, sNGlucosa: IN std_logic; -- Entradas digitales
         VpIn, VnIn, vauxp6, vauxn6, vauxp14, vauxn14 : in std_logic; -- vaux 6 es sensor insulina, vaux 14 es sensor glucosa: sGlucosa, sInsulina, 
         datAdicionales : INOUT std_logic;  --Datos adicionales -EN DESARROLLO CON LA ESP-32
         ledRGB : OUT std_logic_vector (2 downto 0);  -- Salidas del RGB
         buzzer: OUT std_logic;
         bombaInsGlargina, bombaInsLispro, bombaGlucosa : OUT std_logic_vector(3 downto 0);  -- Salidas del Buzzer y actuadores
         clk : in std_logic -- Senial de reloj
        );
end ParCoGli;

architecture Arquitectura of ParCoGli is
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
            enable : in STD_LOGIC;
            clk : in STD_LOGIC;
            res : out STD_LOGIC_VECTOR(3 downto 0)
        );
    END COMPONENT;
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
    COMPONENT SumToN is
        GENERIC (N : NATURAL := 4);
        PORT (A, B: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
             R : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
             Carry: OUT STD_LOGIC);
    end COMPONENT;
    FOR ALL: Comp_N USE ENTITY WORK.Comp_N_Reu(Iterativa);
    FOR ALL: inyector USE ENTITY WORK.inyector(behavior);
    FOR ALL: encendedorBuzzy USE ENTITY WORK.encendedorBuzzy(behavior);
    FOR ALL: SumToN USE ENTITY WORK.SumToN(Behavioral);

    constant hipoglucemia : STD_LOGIC_VECTOR (1 downto 0) := "11"; -- Almacenamos estas constantes para saber que es hiperglucemia,
    constant normal : STD_LOGIC_VECTOR (1 downto 0) := "00"; -- hipoglucemia
    constant hiperglucemia : STD_LOGIC_VECTOR (1 downto 0) := "10"; -- o estado habitual.

    constant tamComp : natural := 9; -- Utilizado para poder traducir enteros en forma decimal a forma binaria de tamComp bits

    constant limitehipoglucemico : STD_LOGIC_VECTOR (15 downto (16-tamComp)) := ent2bin(71, tamComp); -- <70 mg por dl es hipoglucemia
    constant limitehiperglucemicoayunas : STD_LOGIC_VECTOR (15 downto (16-tamComp)) := ent2bin(99, tamComp); -- >100 mg por dl es hiperglucemia en ayunas
    constant limitehiperglucemicocomidas : STD_LOGIC_VECTOR (15 downto (16-tamComp)) := ent2bin(199, tamComp); -- >200 mg por dl es hiperglucemia tras las comidas
    constant insulinaLetal : STD_LOGIC_VECTOR (15 downto (16-tamComp)) := ent2bin(15, tamComp); -- No inyectar insulina si la insulina ya está por encima de 15 en sangre, podría ser letal.
    constant cerosDeLectura : STD_LOGIC_VECTOR (15 downto (16-tamComp)) := "000000000";


    SIGNAL ledRGBint :std_logic_vector (2 downto 0) := "010"; -- Del Led RGB
    signal faltaNInsulina : std_logic := '0';
    signal faltaNGlucosa : std_logic := '0';
    
    Signal nivelGlucemicoPrevio : STD_LOGIC_VECTOR (1 downto 0) := "01"; -- Para que siempre sea diferente la primera vez tiene el valor 01, lectura anterior del nivel glucemico.
    Signal nivelGlucemico : STD_LOGIC_VECTOR (1 downto 0) := "00"; -- Nivel glucemico que la ultima lectura ha dado.

    TYPE matriz IS ARRAY (4 downto 0) of std_logic_vector(15 downto(16-tamComp));
    -- Usamos la matriz para calcular las medias, para ello guardamos en las N-1 filas el valor leído, y en la última la suma, que se divide por 4 (entendido como mover el resultado dos a la derecha)
    Signal lectInsulina, lectGlucosa: matriz;
    Signal nivelInsulina, nivelGlucosa: STD_LOGIC_VECTOR (15 downto (16-tamComp)) := "000000000";
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
    Signal e16daddr_in : STD_LOGIC_VECTOR (6 downto 0) := "0010110"; -- Son la MUX_address, es el del vauxp6
    Signal e1Edaddr_in : STD_LOGIC_VECTOR (6 downto 0) := "0011110"; -- Son la MUX_address, es el del vauxp14
    Signal eden_in: STD_LOGIC:='1'; -- Lo de abajo son mas parametros para el modulo XADC
    Signal edrdy_out: STD_LOGIC;
    Signal edwe_in : STD_LOGIC := '0';
    Signal echannel_out : STD_LOGIC_VECTOR (4 downto 0);
    Signal terminadoSec : STD_LOGIC := '0';
    Signal terminadoConv : STD_LOGIC := '0';
    Signal ereset_in : STD_LOGIC := '0'; -- Senial reseteo XADC
    Signal ocupado, alarma : std_logic; -- Seniales de ocupado y alarma
    
    Signal divisor : integer :=0; -- Divisor de frecuencias
    Signal leoGlucosaOInsulina : integer := 0; -- A pesar de su nombre, tambien se usa para saber en que fase del cicl oestamos

    SIGNAL G_1, E_1, L_1, G_2, E_2, L_2, G_3, E_3, L_3: STD_LOGIC := '0';
    SIGNAL G, E, L: STD_LOGIC; -- Para el comparador de hipoglucemia
    SIGNAL G2, E2, L2: STD_LOGIC; -- Para el comaprador de hiperglucemia
    SIGNAL G3, E3, L3: STD_LOGIC; -- Para el comaprador de insulina Letal
    SIGNAL unDia : integer := 172800; -- Tiempo entre inyecciones de glargina, 86400 segundos * 2 ciclos/seg = 172800
    SIGNAL segundos : integer; -- Cuenta segundos hasta siguiente inyeccion de glargina
    SIGNAL inyectoGlucosa : STD_LOGIC := '0'; -- Enable para inyector de glucosa
    SIGNAL inyectoInsGlargina : STD_LOGIC := '0'; -- Enable para inyector de insulina de accion rapida
    SIGNAL inyectoInsLispro : STD_LOGIC := '0'; -- Enable para inyector de insulina de accion lenta
    SIGNAL tiempoinyectoInsGlargina : integer := 0; -- Tiempo que debo estar inyectando insulina lenta
    SIGNAL tiempoinyectoInsLispro : integer := 0; -- Tiempo que debo estar inyectando insulina rapida
    SIGNAL tiempoinyectoGlucosa : integer := 0; -- Tiempo que debo estar inyectando glucosa
    SIGNAL tiempoInyeccion : integer := 10; -- Supongamos que un inyector tarda unas 10 fases (eso son 5 segundos) en descargar su carga. Estamos simulándolo.

    SIGNAL variableConfigESP : std_logic_vector(15 downto 0) := "0000000000000000"; -- Usaremos todo ceros para decir no hay comandos que recibir, es del ESP
    
    SIGNAL errorFases : STD_LOGIC := '0'; -- En un futuro, para informar de un tipo de error.
    
    SIGNAL SumA1, SumB1, ResulSum1, SumA2, SumB2, ResulSum2 : STD_LOGIC_VECTOR(15 downto (16-tamComp)) := "000000000";
    SIGNAL SumOverflow1, SumOverflow2 : STD_LOGIC := '0';
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
    CHipo: Comp_N GENERIC MAP (tamComp) PORT MAP (nivelGlucosa, limitehipoglucemico, G_1, E_1, L_1, G, E, L);
    CHiper: Comp_N GENERIC MAP (tamComp) PORT MAP (limitehiperglucemicoayunas, nivelGlucosa, G_2, E_2, L_2, G2, E2, L2);
    CInsulinaLetal: Comp_N GENERIC MAP (tamComp) PORT MAP (nivelInsulina, insulinaLetal, G_3, E_3, L_3, G3, E3, L3);
    Buzzy: encendedorBuzzy PORT MAP (nivelGlucemico, buzzer, clk);
    InyectorbombaInsGlargina: inyector PORT MAP (inyectoInsGlargina, clk, bombaInsGlargina);
    InyectorbombaInsLispro: inyector PORT MAP (inyectoInsLispro, clk, bombaInsLispro);
    InyectorGlucosa: inyector PORT MAP (inyectoGlucosa, clk, bombaGlucosa);
    SumadorSistema1: SumToN GENERIC MAP (tamComp) PORT MAP (SumA1, SumB1, ResulSum1, SumOverflow1); -- Hemos decidido tener 2 unidades funcionales de suma 
    SumadorSistema2: SumToN GENERIC MAP (tamComp) PORT MAP (SumA2, SumB2, ResulSum2, SumOverflow2); -- Para agilizar los cálculos
    
    process (sNGlargina, sNLispro, sNGlucosa, clk) -- PROCESO RELACIONADO CON LEDES RGB
        variable queLefalta : std_logic_vector(1 downto 0); -- Consideramos si falta insulina o glucosa, lo revisa periódicamente o cuando uno cambie.
    begin
        queLefalta := ((NOT((sNGlargina) AND (sNLispro))))&(NOT(sNGlucosa));
        case (queLefalta) is
            when "00" => ledRGBint <= "010"; -- Verde es todo correcto.
            when "01" => ledRGBint <= "001"; -- Azul es que falta glucosa en el inyector
            when "10" => ledRGBint <= "100"; -- Rojo es que falta insulina (de cualquier tipo) en el inyector
            when "11" => ledRGBint <= "101"; -- Morado es que faltan insulina y glucosa en inyector
            when others => ledRGBint <= "111"; -- Color blanco es mensaje de error
        end case;
        ledRGB <= ledRGBint; -- Pasar valor al ledRGB
    end process;

    process (clk) --PROCESO RELACIONADO CON RELOJES Y TIMERS
    begin
        if (rising_edge(clk)) then
            if (divisor >= 50000000) then -- Reloj central a 100 Mhz, periodo inverso de la frecuencia, 1 entre 100 MHz, debemos dividir tensión, 100000000 subidas es 1 hercio.
                if (leoGlucosaOInsulina < 8) then -- El sistema tiene ciertos ciclos segun el divisor de frecuencia
                    leoGlucosaOInsulina <= leoGlucosaOInsulina +1; -- Cada vez que pasa el suficiente periodo de tiempo, se pasa a la siguiente fase
                else
                    leoGlucosaOInsulina <= 2; -- Para ignorar las dos primeras lecturas
                end if;
                divisor <= 0;
                -- INYECCIONES 
                -- CUANDO INYECTAR INSULINA LARGO PLAZO
                if (segundos >= unDia) then -- Cada 24-30h se debe inyectar una dosis de insulina de largo plazo. Esto luego se deberia ajustar al paciente
                    tiempoinyectoInsGlargina <= tiempoInyeccion; -- Cuanto inyectar tambien deberia ajustarse al paciente
                    segundos <= 0; -- Resetea el contador
                else
                    segundos <= segundos + 1;
                end if;
                -- DURANTE CUANTO TIEMPO INYECTAR INSULINA A LARGO PLAZO
                if (tiempoinyectoInsGlargina < 1) then
                    inyectoInsGlargina <= '0'; -- No inyectar insulina a largo plazo si el timer es menor que cero
                else
                    if (inyectoInsGlargina = '0') then -- Si dice no inyectar insulina de largo plazo
                        if (L3 = '0') then -- Inyecto insulina de largo plazo si no estamos en niveles letales de concentracion de insulina
                            inyectoInsGlargina <= '0';
                        else
                            inyectoInsGlargina <= '1';
                        end if;
                    else  
                        end if;
                    tiempoinyectoInsGlargina <= tiempoinyectoInsGlargina -1; -- Reducir el timer si es mayor que cero
                end if;
                -- CUANDO INYECTAR LISPRO Y GLUCOSA, antes fuera pero el Vivado se queja de multiply-driven si lo ponemos en otro sitio al escribir una senial en 
                -- dos sitios 
                if ((leoGlucosaOInsulina = 15)) then -- En la ultima fase del ciclo es cuando inyectamos estas sustancias, debo dar tiempo a completar calculos
                    if ((nivelGlucemicoPrevio = nivelGlucemico)) then
                        datAdicionales <= '1'; -- A lo mejor es útil para el futuro que pueda mantener niveles estables e informar al exterior
                    else
                        if (nivelGlucemico = hipoglucemia) then -- En caso de hipoglucemia, inyectar glucosa y no insulina
                            tiempoinyectoInsLispro <= 0;
                            tiempoinyectoGlucosa <= tiempoInyeccion;
                        else if (nivelGlucemico = hiperglucemia) then -- En caso de hiperglucemia, no inyectes mas glucosa y considerar inyectar insulina lispro
                                tiempoinyectoGlucosa <= 0;
                                if (L3 = '1') then -- No inyectar esta insulina si estamos a niveles letales de concentracion de insulina
                                    tiempoinyectoInsLispro <= tiempoInyeccion;
                                else
                                end if;
                            else -- MEDIDA DE SEGURIDAD, SI NO TENEMOS NI IDEA NO INYECTES NADA
                                tiempoinyectoInsLispro <= 0;
                                tiempoinyectoGlucosa <= 0;
                            end if;
                        end if;
                    end if;
                    nivelGlucemicoPrevio <= nivelGlucemico; --Guardamos historial previo de niveles glucemicos.
                else 
                end if;
                -- DURANTE CUANTO TIEMPO INYECTAR LISPRO
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
                -- DURANTE CUANTO TIEMPO INYECTAR GLUCOSA
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
        else
        end if;  
    end process;

    process (leoGlucosaOInsulina) --DIGO CUAL ENTRADA LEER, SEGUN FASES
    begin
    case (leoGlucosaOInsulina) is
        when 0 => -- No hacer nada en las dos primeras fases, suponemos que
        when 1 => -- las dos primeras lecturas de los sensores del paciente estan mal.
        when 2 => edaddr_in <= e16daddr_in; -- Leo insulina, para ello primero indico cual es el registro del XADC que tiene el valor de la insulina
        when 3 => sumA1 <= cerosDeLectura;  -- y luego, en el ciclo siguiente para dar tiempo, tomo el valor de la lectura y lo guardo para media
                  sumB1 <= resultado_int(15 DOWNTO (16-tamComp)); -- Para ello comienzo a sumarlo al resultado anterior
                  lectInsulina(0) <= resultado_int(15 DOWNTO (16-tamComp)); -- registro el valor por si acaso lo usamos en algún futuro (ej ESP-32)
        when 4 => sumA2 <= ResulSum1; -- y luego, en el ciclo siguiente para dar tiempo, tomo el valor de la lectura y lo guardo para media
                  sumB2 <= resultado_int(15 DOWNTO (16-tamComp)); -- Para ello comienzo a sumarlo al resultado anterior
                  lectInsulina(1) <= resultado_int(15 DOWNTO (16-tamComp));
        when 5 => sumA1 <= ResulSum2;
                  sumB1 <= resultado_int(15 DOWNTO (16-tamComp)); -- Hago lo mismo que en el ciclo anterior
                  lectInsulina(2) <= resultado_int(15 DOWNTO (16-tamComp));
        when 6 => sumA2 <= ResulSum1;
                  sumB2 <= resultado_int(15 DOWNTO (16-tamComp)); -- Finalmente cuando tengo el num de lecturas deseadas
                  lectInsulina(3) <= resultado_int(15 DOWNTO (16-tamComp));
        when 7 => lectInsulina(4) <= "00"&ResulSum2(15 downto (16-tamComp+2)); -- Dividimos por 4 para calcular la media (mover registro a la derecha en este caso)
                  nivelInsulina <= "00"&ResulSum2(15 downto (16-tamComp+2)); -- y lo enviamos al comparador                                                  
        when 8 => edaddr_in <= e1Edaddr_in; -- Leo glucosa, para ello primero indico cual es el registro del XADC que tiene el valor de la glucosa
        when 9 => sumA1 <= cerosDeLectura;  -- y luego, en el ciclo siguiente para dar tiempo, tomo el valor de la lectura y lo guardo para media
                  sumB1 <= resultado_int(15 DOWNTO (16-tamComp)); -- Para ello comienzo a sumarlo al resultado anterior
                  lectGlucosa(0) <= resultado_int(15 DOWNTO (16-tamComp)); -- Igual que para la insulina   
        when 10 => sumA2 <= ResulSum1; 
                   sumB2 <= resultado_int(15 DOWNTO (16-tamComp)); -- Para ello comienzo a sumarlo al resultado anterior
                   lectGlucosa(1) <= resultado_int(15 DOWNTO (16-tamComp));
        when 11 => sumA1 <= ResulSum2;
                   sumB1 <= resultado_int(15 DOWNTO (16-tamComp)); -- Hago lo mismo que en el ciclo anterior
                   lectGlucosa(2) <= resultado_int(15 DOWNTO (16-tamComp));
        when 12 => sumA2 <= ResulSum1;
                   sumB2 <= resultado_int(15 DOWNTO (16-tamComp)); -- Finalmente cuando tengo el num de lecturas deseadas
                   lectGlucosa(3) <= resultado_int(15 DOWNTO (16-tamComp));
        when 13 => lectGlucosa(4) <= "00"&ResulSum2(15 downto (16-tamComp+2)); -- Dividimos por 4 para calcular la media (mover registro a la derecha en este caso)
                   nivelGlucosa <= "00"&ResulSum2(15 downto (16-tamComp+2)); -- y lo enviamos al comparador 
        when 14 => -- Fase de calculo de estado del paciente, en la que este proceso no participa.
        when 15 => -- Fase de calculo de tiempos de inyecciones, en la que este proceso no participa.
        when others => errorFases <= '1'; -- Informar de error
    end case;
    end process;
    -- POR HACER: FILTRO DE KALMANN
    -- Esto en teoría es un sistema de control
    process (leoGlucosaOInsulina) -- PROCESO ENCARGADO DE LA FASE DE ANALISIS DEL PACIENTE
    begin
        if (leoGlucosaOInsulina = 14) then
            -- Esto seria a ajustar a la medida apropiada segun el sensor empleado.
            if (L = '1') then
                nivelGlucemico <= hipoglucemia; -- Si el nivel de glucosa es menor que el valor hipoglucemico dado, decimos que el paciente esta hipoglucemico
            else
                if (L2 = '1') then -- Si el nivel de glucosa es mayor que el valor hiperglucemico dado, decimos que el paciente esta hiperglucemico
                    nivelGlucemico <= hiperglucemia;
                else -- En otro caso, diremos que el paciente se encuentra en paramteros normales.
                    nivelGlucemico <= normal;
                end if;
            end if;
        else
        end if;
    end process;
    process (datAdicionales) -- PROCESO DE LA ESP32
    begin
        -- Aqui es donde hariamos algo con esto mediante ESP-32.
        -- Esto es un STUB 
        variableConfigESP <= variableConfigESP(14 downto 0)&datAdicionales;
        if (variableConfigESP(14) = '1') then
            --Ejecutar accion leyendo valores establecidos por variableConfigEspecial
            --Resetear varaible config
            variableConfigESP <= "0000000000000000";
        --Enviar respuesta
        --datAdicionales <= '0';
        else
           --A lo mejor ejecutar otra accion
        end if;
    end process;

end Arquitectura;
