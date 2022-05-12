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
         nivelGlucosaE : OUT std_logic_vector (8 downto 0); -- PARA PRUEBAS DE MEDIAS
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
    constant inicialPromedioGlucosa : STD_LOGIC_VECTOR (15 downto (16-tamComp)) := "001010101"; -- Asumimos que inicialmente, para la media, se considera un nivel inicial promedio, que no causa que ningun dispositivo actue
    constant inicialPromedioInsulina : STD_LOGIC_VECTOR (15 downto (16-tamComp)) := "000011110"; -- Asumimos que casi esta en insulina letal para que las primeras lecturas se tengan en cuenta (así si hay letalidad de insulina, no se inyecta)


    signal faltaNInsulina : std_logic := '0';
    signal faltaNGlucosa : std_logic := '0';

    Signal nivelGlucemicoPrevio : STD_LOGIC_VECTOR (1 downto 0) := "01"; -- Para que siempre sea diferente la primera vez tiene el valor 01, lectura anterior del nivel glucemico.
    Signal nivelGlucemico : STD_LOGIC_VECTOR (1 downto 0) := normal; -- Nivel glucemico que la ultima lectura ha dado. Asumimos que inicial es normal

    TYPE matriz IS ARRAY (3 downto 0) of std_logic_vector(15 downto (16-tamComp));
    -- Usamos la matriz para guardar los valores para calculos de la media, escribiendo el resultado del ciclo t en el elemento i, y el t+1 en el elemento i+1, actuando casi como un array ciclico.
    Signal lectInsulina: matriz :=((others=> (inicialPromedioInsulina))); -- Incializar matriz para tener la media lista en los primeros ciclos
    Signal lectGlucosa: matriz := ((others=> (inicialPromedioGlucosa))); -- Incializar matriz para tener la media lista en los primeros ciclos
    SIGNAL Cual : integer := 3; -- Me dice cual elemento de las dos matrices a sobreescribir, si 0, 1, 2 o 3

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
    constant e16daddr_in : STD_LOGIC_VECTOR (6 downto 0) := "0010110"; -- Son la MUX_address, es el del vauxp6
    constant e1Edaddr_in : STD_LOGIC_VECTOR (6 downto 0) := "0011110"; -- Son la MUX_address, es el del vauxp14
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

    SIGNAL SumA1, SumB1, ResulSum1, SumA2, SumB2, ResulSum2, SumA3, SumB3, ResulSum3, SumA4, SumB4, ResulSum4 : STD_LOGIC_VECTOR(15 downto (16-tamComp)) := "000000000"; -- Para los sumadores
    SIGNAL ResulSumInsulina, ResulSumGlucosa, AuxSuma1, AuxSuma2, AuxSuma3, AuxSuma4 : STD_LOGIC_VECTOR(15 downto (16-tamComp-1)) := "0000000000"; -- Para el segundo nivel de sumadores, necesitamos 1 bit adicional para evitar posible overflow.
    SIGNAL SumOverflow1, SumOverflow2, SumOverFlowI, SumOverflow3, SumOverflow4, SumOverflowG : STD_LOGIC := '0';

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

    AuxSuma1 <=  SumOverflow1&ResulSum1; --Para que el Vivado no de un warning de que los PORT MAP deben tener nombres estaticos o expresiones globalmente estaticas,
    AuxSuma2 <=  SumOverflow2&ResulSum2; --  en realidad esto no da problemas en Vivado, pero si en otras herramientas. 
    AuxSuma3 <=  SumOverflow3&ResulSum3; -- Esto se debe hacer para todos los valores intermedios 
    AuxSuma4 <=  SumOverflow4&ResulSum4; -- que deseemos poner.
    nivelInsulina <= SumOverflowI&ResulSumInsulina(15 downto (16-tamComp+1)); -- Tambien incluye los valores de insulina
    nivelGlucosa <= SumOverflowG&ResulSumGlucosa(15 downto (16-tamComp+1));  -- y de glucosa promedio
    -- Hacemos la division de insulina (y la de glucosa) entre 4, que equivale a quitar los dos bits de la derecha y rellenar con ceros a la izquierda hasta tener el tamanio exacto
    -- Como en este caso tanto nivelInsulina como nivelGlucosa son ya de por sí 2 bits más cortos (9 bits) que la longitud del vector de 10 bits y su overflow, no aniadimos ceros adicionales a la izq.
    nivelGlucosaE <= SumOverflowG&ResulSumGlucosa(15 downto (16-tamComp+1));
    -- LO DE NIVEL GLUCOSA ESTA SOLO PARA DEBUGGING, BORRALO/COMENTALO LUEGO

    CHipo: Comp_N GENERIC MAP (tamComp) PORT MAP (nivelGlucosa, limitehipoglucemico, G_1, E_1, L_1, G, E, L);
    CHiper: Comp_N GENERIC MAP (tamComp) PORT MAP (limitehiperglucemicoayunas, nivelGlucosa, G_2, E_2, L_2, G2, E2, L2);
    CInsulinaLetal: Comp_N GENERIC MAP (tamComp) PORT MAP (nivelInsulina, insulinaLetal, G_3, E_3, L_3, G3, E3, L3);
    Buzzy: encendedorBuzzy PORT MAP (nivelGlucemico, buzzer, clk);
    InyectorbombaInsGlargina: inyector PORT MAP (inyectoInsGlargina, clk, bombaInsGlargina);
    InyectorbombaInsLispro: inyector PORT MAP (inyectoInsLispro, clk, bombaInsLispro);
    InyectorGlucosa: inyector PORT MAP (inyectoGlucosa, clk, bombaGlucosa);

    SumadorSistema1: SumToN GENERIC MAP (tamComp) PORT MAP (lectInsulina(0), lectInsulina(1), ResulSum1, SumOverflow1); -- Hemos decidido tener 3 sumadores por cada media. 
    SumadorSistema2: SumToN GENERIC MAP (tamComp) PORT MAP (lectInsulina(2), lectInsulina(3), ResulSum2, SumOverflow2); -- Para agilizar los cálculos
    Media1: SumToN GENERIC MAP (tamComp+1) PORT MAP (AuxSuma1, AuxSuma2, ResulSumInsulina, SumOverflowI); -- Con el tercero reservado para hacer la media
    SumadorSistema3: SumToN GENERIC MAP (tamComp) PORT MAP (lectGlucosa(0), lectGlucosa(1), ResulSum3, SumOverflow3); -- Estos 3 son para lo mismo
    SumadorSistema4: SumToN GENERIC MAP (tamComp) PORT MAP (lectGlucosa(2), lectGlucosa(3), ResulSum4, SumOverflow4); -- Pero en vez de para insulina
    Media2: SumToN GENERIC MAP (tamComp+1) PORT MAP (AuxSuma3, AuxSuma4, ResulSumGlucosa, SumOverflowG); -- Son para glucosa

    process (sNGlargina, sNLispro, sNGlucosa, clk) -- PROCESO RELACIONADO CON LEDES RGB
        variable queLefalta : std_logic_vector(1 downto 0); -- Consideramos si falta insulina o glucosa, lo revisa periódicamente o cuando uno cambie.
        variable ledRGBint :std_logic_vector (2 downto 0) := "010"; -- Del Led RGB, como no lo usa ningun otro proceso y se reescribe cada vez, pues lo dejamos aca para prevenir warnings
    begin
        queLefalta := ((NOT((sNGlargina) AND (sNLispro))))&(NOT(sNGlucosa));
        case (queLefalta) is
            when "00" => ledRGBint := "010"; -- Verde es todo correcto.
            when "01" => ledRGBint := "001"; -- Azul es que falta glucosa en el inyector
            when "10" => ledRGBint := "100"; -- Rojo es que falta insulina (de cualquier tipo) en el inyector
            when "11" => ledRGBint := "101"; -- Morado es que faltan insulina y glucosa en inyector
            when others => ledRGBint := "111"; -- Color blanco es mensaje de error
        end case;
        ledRGB <= ledRGBint; -- Pasar valor al ledRGB
    end process;

    process (clk) --PROCESO RELACIONADO CON RELOJES Y TIMERS
    begin
        if (rising_edge(clk)) then
            if (divisor >= 50000000) then -- Reloj central a 100 Mhz, periodo inverso de la frecuencia, 1 entre 100 MHz, debemos dividir tensión, 100000000 subidas es 1 hercio.
                if (leoGlucosaOInsulina < 7) then -- El sistema tiene ciertos ciclos segun el divisor de frecuencia PUSE 7 EN VEZ DE 8, VER SI ESO ALTERA FUNCIONAMIENTO
                    if (leoGlucosaOInsulina = 3) then -- Si ya se ha elegido que se va a leer del registro de insulina 
                        lectInsulina(Cual) <= resultado_int(15 DOWNTO (16-tamComp));
                    -- Entonces guardamos el valor de dicho registro en nuestra variable de insulina correspondiente (segun el ciclo) para poder computar su media.
                    else
                        if(leoGlucosaOinsulina = 5) then -- Si ya se ha elegido que se va a leer del registro de glucosa
                            lectGlucosa(Cual) <= resultado_int(15 DOWNTO (16-tamComp));
                        -- Entonces guardamos el valor de dicho registro en nuestra variable de glucosa correspondiente (segun el ciclo) para poder computar su media.
                        else
                            if (leoGlucosaOInsulina = 6) then
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
                        end if;
                    end if;
                    -- Lo de arriba es un ajuste para evitar gated clocks
                    leoGlucosaOInsulina <= leoGlucosaOInsulina +1; -- Cada vez que pasa el suficiente periodo de tiempo, se pasa a la siguiente fase
                else
                    leoGlucosaOInsulina <= 2; -- Para ignorar las dos primeras lecturas
                    if (Cual >= 3) then  -- El final del ciclo indica que para el nuevo debo usar una nueva variable de nuestro array para la media, sobreescribiremos la mas antigua
                        Cual <= 0;
                    else
                        Cual <= Cual +1;
                    end if;
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
                if ((leoGlucosaOInsulina = 7)) then -- En la ultima fase del ciclo es cuando inyectamos estas sustancias, debo dar tiempo a completar calculos
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

    -- ESTE BLOQUE COMENTADO SOLO SE HA DEJADO PORQUE ACLARA MUCHO LAS FASES DEL CIRCUITO
    --    process (leoGlucosaOInsulina, Cual) --DIGO CUAL ENTRADA LEER, SEGUN FASES
    --    begin
    --        case (leoGlucosaOInsulina) is
    --            when 0 => -- Estos dos primeros ciclos en realidad no se usan para leer datos del sensor, vamos a
    --            when 1 => -- asumir que las lecturas de los sensores del paciente hasta dos fases tras iniciarse la placa estan mal.
    --            when 2 => -- edaddr_in <= e16daddr_in; -- Leo insulina, para ello primero indico cual es el registro del XADC que tiene el valor de la insulina. Se movio a otro process para evitar latchees y warnings

    --            when 3 => lectInsulina(Cual) <= resultado_int(15 DOWNTO (16-tamComp)); -- y luego, en el ciclo siguiente para dar tiempo, tomo el valor de la lectura.
    --            when 4 => -- edaddr_in <= e1Edaddr_in; -- Leo glucosa, para ello primero indico cual es el registro del XADC que tiene el valor de la glucosa. Se movio a otro process para evitar latchees y warnings
    --            when 5 => lectGlucosa(Cual) <= resultado_int(15 DOWNTO (16-tamComp)); -- y luego, en el ciclo siguiente para dar tiempo, tomo el valor de la lectura.
    --            when 6 => -- Fase de calculo de estado del paciente, en la que este proceso no participa.
    --            when 7 => -- Fase de calculo de tiempos de inyecciones, en la que este proceso no participa.
    --            when others => errorFases <= '1'; -- Informar de error
    --        end case;
    --    end process;

    process (leoGlucosaOInsulina) --DIGO CUAL ENTRADA LEER, SEGUN FASES, 
        -- ya que el modulo XADC tiene una salida comun para todos sus registros, debemos primero indicar de cual registro leer
    begin
        if (leoGlucosaOInsulina < 4) then
            edaddr_in <= e16daddr_in; -- Indico al modulo XADC que leo del registro de insulina.
        else
            edaddr_in <= e1Edaddr_in; -- Indico al modulo XADC que leo del registro de glucosa.
        end if;
    end process;

    --    process (leoGlucosaOInsulina, Cual, resultado_int) --DIGO CUAL ENTRADA LEER, SEGUN FASES
    --    -- Una vez ya tenemos selccionado el registro (tomamos el ultimo ciclo antes de que el indicador del registro cambie, o nos movamos a la fase de analisis, para asegurarnos que funciona) tomamos el dato.
    --    begin
    --        if (leoGlucosaOInsulina = 3) then -- Si ya se ha elegido que se va a leer del registro de insulina 
    --            lectInsulina(Cual) <= resultado_int(15 DOWNTO (16-tamComp));
    --            -- Entonces guardamos el valor de dicho registro en nuestra variable de insulina correspondiente (segun el ciclo) para poder computar su media.
    --        else
    --            if(leoGlucosaOinsulina = 5) then -- Si ya se ha elegido que se va a leer del registro de glucosa
    --                lectGlucosa(Cual) <= resultado_int(15 DOWNTO (16-tamComp));
    --            -- Entonces guardamos el valor de dicho registro en nuestra variable de glucosa correspondiente (segun el ciclo) para poder computar su media.
    --            else
    --           end if;
    --        end if;
    --    end process;

    -- MEJORA (por hacer): Esto en teoria es un sistema de control, podriamos reducir aun mas el error en medidas siguientes mediante un FILTRO DE KALMANN si 
    -- lograsemos tener formulas experimentales en pacientes del progreso glucemico de la diabetes a nivel intersticial.
    -- Dicha mejora se encontraria entre las fases de lectura y la accion del ciclo siguiente.

    --    process (leoGlucosaOInsulina) -- PROCESO ENCARGADO DE LA FASE DE ANALISIS DEL PACIENTE
    --    begin
    --        if (leoGlucosaOInsulina = 6) then
    --            -- Esto seria a ajustar a la medida apropiada segun el sensor empleado.
    --            if (L = '1') then
    --                nivelGlucemico <= hipoglucemia; -- Si el nivel de glucosa es menor que el valor hipoglucemico dado, decimos que el paciente esta hipoglucemico
    --            else
    --                if (L2 = '1') then -- Si el nivel de glucosa es mayor que el valor hiperglucemico dado, decimos que el paciente esta hiperglucemico
    --                    nivelGlucemico <= hiperglucemia;
    --                else -- En otro caso, diremos que el paciente se encuentra en paramteros normales.
    --                    nivelGlucemico <= normal;
    --                end if;
    --            end if;
    --        else
    --            end if;
    --    end process;
    process (datAdicionales, variableConfigESP) -- PROCESO DE LA ESP32 - SE DEJA PARA EL SIGUIENTE SEMESTRE
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
