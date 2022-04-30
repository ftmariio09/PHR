-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
-- Date        : Thu Mar 31 21:31:05 2022
-- Host        : LAPTOP-9GJB53N6 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               C:/PracticasVHDL/PracticaEncenderLEDconSwitch/LedSimple/LedSimple.sim/sim_1/synth/func/xsim/tutorial_tb_func_synth.vhd
-- Design      : encendedorLed
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity encendedorLed is
  port (
    swt : in STD_LOGIC_VECTOR ( 0 to 0 );
    led : out STD_LOGIC_VECTOR ( 0 to 0 );
    clk : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of encendedorLed : entity is true;
end encendedorLed;

architecture STRUCTURE of encendedorLed is
  signal clk_IBUF : STD_LOGIC;
  signal clk_IBUF_BUFG : STD_LOGIC;
  signal \divisor[0]_i_2_n_0\ : STD_LOGIC;
  signal divisor_reg : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \divisor_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \divisor_reg[0]_i_1_n_1\ : STD_LOGIC;
  signal \divisor_reg[0]_i_1_n_2\ : STD_LOGIC;
  signal \divisor_reg[0]_i_1_n_3\ : STD_LOGIC;
  signal \divisor_reg[0]_i_1_n_4\ : STD_LOGIC;
  signal \divisor_reg[0]_i_1_n_5\ : STD_LOGIC;
  signal \divisor_reg[0]_i_1_n_6\ : STD_LOGIC;
  signal \divisor_reg[0]_i_1_n_7\ : STD_LOGIC;
  signal \divisor_reg[12]_i_1_n_0\ : STD_LOGIC;
  signal \divisor_reg[12]_i_1_n_1\ : STD_LOGIC;
  signal \divisor_reg[12]_i_1_n_2\ : STD_LOGIC;
  signal \divisor_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \divisor_reg[12]_i_1_n_4\ : STD_LOGIC;
  signal \divisor_reg[12]_i_1_n_5\ : STD_LOGIC;
  signal \divisor_reg[12]_i_1_n_6\ : STD_LOGIC;
  signal \divisor_reg[12]_i_1_n_7\ : STD_LOGIC;
  signal \divisor_reg[16]_i_1_n_0\ : STD_LOGIC;
  signal \divisor_reg[16]_i_1_n_1\ : STD_LOGIC;
  signal \divisor_reg[16]_i_1_n_2\ : STD_LOGIC;
  signal \divisor_reg[16]_i_1_n_3\ : STD_LOGIC;
  signal \divisor_reg[16]_i_1_n_4\ : STD_LOGIC;
  signal \divisor_reg[16]_i_1_n_5\ : STD_LOGIC;
  signal \divisor_reg[16]_i_1_n_6\ : STD_LOGIC;
  signal \divisor_reg[16]_i_1_n_7\ : STD_LOGIC;
  signal \divisor_reg[20]_i_1_n_0\ : STD_LOGIC;
  signal \divisor_reg[20]_i_1_n_1\ : STD_LOGIC;
  signal \divisor_reg[20]_i_1_n_2\ : STD_LOGIC;
  signal \divisor_reg[20]_i_1_n_3\ : STD_LOGIC;
  signal \divisor_reg[20]_i_1_n_4\ : STD_LOGIC;
  signal \divisor_reg[20]_i_1_n_5\ : STD_LOGIC;
  signal \divisor_reg[20]_i_1_n_6\ : STD_LOGIC;
  signal \divisor_reg[20]_i_1_n_7\ : STD_LOGIC;
  signal \divisor_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \divisor_reg[24]_i_1_n_1\ : STD_LOGIC;
  signal \divisor_reg[24]_i_1_n_2\ : STD_LOGIC;
  signal \divisor_reg[24]_i_1_n_3\ : STD_LOGIC;
  signal \divisor_reg[24]_i_1_n_4\ : STD_LOGIC;
  signal \divisor_reg[24]_i_1_n_5\ : STD_LOGIC;
  signal \divisor_reg[24]_i_1_n_6\ : STD_LOGIC;
  signal \divisor_reg[24]_i_1_n_7\ : STD_LOGIC;
  signal \divisor_reg[28]_i_1_n_1\ : STD_LOGIC;
  signal \divisor_reg[28]_i_1_n_2\ : STD_LOGIC;
  signal \divisor_reg[28]_i_1_n_3\ : STD_LOGIC;
  signal \divisor_reg[28]_i_1_n_4\ : STD_LOGIC;
  signal \divisor_reg[28]_i_1_n_5\ : STD_LOGIC;
  signal \divisor_reg[28]_i_1_n_6\ : STD_LOGIC;
  signal \divisor_reg[28]_i_1_n_7\ : STD_LOGIC;
  signal \divisor_reg[4]_i_1_n_0\ : STD_LOGIC;
  signal \divisor_reg[4]_i_1_n_1\ : STD_LOGIC;
  signal \divisor_reg[4]_i_1_n_2\ : STD_LOGIC;
  signal \divisor_reg[4]_i_1_n_3\ : STD_LOGIC;
  signal \divisor_reg[4]_i_1_n_4\ : STD_LOGIC;
  signal \divisor_reg[4]_i_1_n_5\ : STD_LOGIC;
  signal \divisor_reg[4]_i_1_n_6\ : STD_LOGIC;
  signal \divisor_reg[4]_i_1_n_7\ : STD_LOGIC;
  signal \divisor_reg[8]_i_1_n_0\ : STD_LOGIC;
  signal \divisor_reg[8]_i_1_n_1\ : STD_LOGIC;
  signal \divisor_reg[8]_i_1_n_2\ : STD_LOGIC;
  signal \divisor_reg[8]_i_1_n_3\ : STD_LOGIC;
  signal \divisor_reg[8]_i_1_n_4\ : STD_LOGIC;
  signal \divisor_reg[8]_i_1_n_5\ : STD_LOGIC;
  signal \divisor_reg[8]_i_1_n_6\ : STD_LOGIC;
  signal \divisor_reg[8]_i_1_n_7\ : STD_LOGIC;
  signal led_OBUF : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \led_int[0]_i_11_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_12_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_13_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_14_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_15_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_16_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_17_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_19_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_1_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_20_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_21_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_22_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_23_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_24_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_25_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_26_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_27_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_28_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_29_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_30_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_31_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_32_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_33_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_4_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_5_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_6_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_7_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_8_n_0\ : STD_LOGIC;
  signal \led_int[0]_i_9_n_0\ : STD_LOGIC;
  signal \led_int_reg[0]_i_10_n_0\ : STD_LOGIC;
  signal \led_int_reg[0]_i_10_n_1\ : STD_LOGIC;
  signal \led_int_reg[0]_i_10_n_2\ : STD_LOGIC;
  signal \led_int_reg[0]_i_10_n_3\ : STD_LOGIC;
  signal \led_int_reg[0]_i_18_n_0\ : STD_LOGIC;
  signal \led_int_reg[0]_i_18_n_1\ : STD_LOGIC;
  signal \led_int_reg[0]_i_18_n_2\ : STD_LOGIC;
  signal \led_int_reg[0]_i_18_n_3\ : STD_LOGIC;
  signal \led_int_reg[0]_i_2_n_0\ : STD_LOGIC;
  signal \led_int_reg[0]_i_2_n_1\ : STD_LOGIC;
  signal \led_int_reg[0]_i_2_n_2\ : STD_LOGIC;
  signal \led_int_reg[0]_i_2_n_3\ : STD_LOGIC;
  signal \led_int_reg[0]_i_3_n_0\ : STD_LOGIC;
  signal \led_int_reg[0]_i_3_n_1\ : STD_LOGIC;
  signal \led_int_reg[0]_i_3_n_2\ : STD_LOGIC;
  signal \led_int_reg[0]_i_3_n_3\ : STD_LOGIC;
  signal swt_IBUF : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \NLW_divisor_reg[28]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_led_int_reg[0]_i_10_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_led_int_reg[0]_i_18_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_led_int_reg[0]_i_2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_led_int_reg[0]_i_3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \divisor_reg[0]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \divisor_reg[12]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \divisor_reg[16]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \divisor_reg[20]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \divisor_reg[24]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \divisor_reg[28]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \divisor_reg[4]_i_1\ : label is 11;
  attribute ADDER_THRESHOLD of \divisor_reg[8]_i_1\ : label is 11;
  attribute COMPARATOR_THRESHOLD : integer;
  attribute COMPARATOR_THRESHOLD of \led_int_reg[0]_i_10\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \led_int_reg[0]_i_18\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \led_int_reg[0]_i_2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \led_int_reg[0]_i_3\ : label is 11;
begin
clk_IBUF_BUFG_inst: unisim.vcomponents.BUFG
     port map (
      I => clk_IBUF,
      O => clk_IBUF_BUFG
    );
clk_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => clk,
      O => clk_IBUF
    );
\divisor[0]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => divisor_reg(0),
      O => \divisor[0]_i_2_n_0\
    );
\divisor_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[0]_i_1_n_7\,
      Q => divisor_reg(0),
      R => '0'
    );
\divisor_reg[0]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \divisor_reg[0]_i_1_n_0\,
      CO(2) => \divisor_reg[0]_i_1_n_1\,
      CO(1) => \divisor_reg[0]_i_1_n_2\,
      CO(0) => \divisor_reg[0]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0001",
      O(3) => \divisor_reg[0]_i_1_n_4\,
      O(2) => \divisor_reg[0]_i_1_n_5\,
      O(1) => \divisor_reg[0]_i_1_n_6\,
      O(0) => \divisor_reg[0]_i_1_n_7\,
      S(3 downto 1) => divisor_reg(3 downto 1),
      S(0) => \divisor[0]_i_2_n_0\
    );
\divisor_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[8]_i_1_n_5\,
      Q => divisor_reg(10),
      R => '0'
    );
\divisor_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[8]_i_1_n_4\,
      Q => divisor_reg(11),
      R => '0'
    );
\divisor_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[12]_i_1_n_7\,
      Q => divisor_reg(12),
      R => '0'
    );
\divisor_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \divisor_reg[8]_i_1_n_0\,
      CO(3) => \divisor_reg[12]_i_1_n_0\,
      CO(2) => \divisor_reg[12]_i_1_n_1\,
      CO(1) => \divisor_reg[12]_i_1_n_2\,
      CO(0) => \divisor_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \divisor_reg[12]_i_1_n_4\,
      O(2) => \divisor_reg[12]_i_1_n_5\,
      O(1) => \divisor_reg[12]_i_1_n_6\,
      O(0) => \divisor_reg[12]_i_1_n_7\,
      S(3 downto 0) => divisor_reg(15 downto 12)
    );
\divisor_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[12]_i_1_n_6\,
      Q => divisor_reg(13),
      R => '0'
    );
\divisor_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[12]_i_1_n_5\,
      Q => divisor_reg(14),
      R => '0'
    );
\divisor_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[12]_i_1_n_4\,
      Q => divisor_reg(15),
      R => '0'
    );
\divisor_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[16]_i_1_n_7\,
      Q => divisor_reg(16),
      R => '0'
    );
\divisor_reg[16]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \divisor_reg[12]_i_1_n_0\,
      CO(3) => \divisor_reg[16]_i_1_n_0\,
      CO(2) => \divisor_reg[16]_i_1_n_1\,
      CO(1) => \divisor_reg[16]_i_1_n_2\,
      CO(0) => \divisor_reg[16]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \divisor_reg[16]_i_1_n_4\,
      O(2) => \divisor_reg[16]_i_1_n_5\,
      O(1) => \divisor_reg[16]_i_1_n_6\,
      O(0) => \divisor_reg[16]_i_1_n_7\,
      S(3 downto 0) => divisor_reg(19 downto 16)
    );
\divisor_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[16]_i_1_n_6\,
      Q => divisor_reg(17),
      R => '0'
    );
\divisor_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[16]_i_1_n_5\,
      Q => divisor_reg(18),
      R => '0'
    );
\divisor_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[16]_i_1_n_4\,
      Q => divisor_reg(19),
      R => '0'
    );
\divisor_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[0]_i_1_n_6\,
      Q => divisor_reg(1),
      R => '0'
    );
\divisor_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[20]_i_1_n_7\,
      Q => divisor_reg(20),
      R => '0'
    );
\divisor_reg[20]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \divisor_reg[16]_i_1_n_0\,
      CO(3) => \divisor_reg[20]_i_1_n_0\,
      CO(2) => \divisor_reg[20]_i_1_n_1\,
      CO(1) => \divisor_reg[20]_i_1_n_2\,
      CO(0) => \divisor_reg[20]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \divisor_reg[20]_i_1_n_4\,
      O(2) => \divisor_reg[20]_i_1_n_5\,
      O(1) => \divisor_reg[20]_i_1_n_6\,
      O(0) => \divisor_reg[20]_i_1_n_7\,
      S(3 downto 0) => divisor_reg(23 downto 20)
    );
\divisor_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[20]_i_1_n_6\,
      Q => divisor_reg(21),
      R => '0'
    );
\divisor_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[20]_i_1_n_5\,
      Q => divisor_reg(22),
      R => '0'
    );
\divisor_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[20]_i_1_n_4\,
      Q => divisor_reg(23),
      R => '0'
    );
\divisor_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[24]_i_1_n_7\,
      Q => divisor_reg(24),
      R => '0'
    );
\divisor_reg[24]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \divisor_reg[20]_i_1_n_0\,
      CO(3) => \divisor_reg[24]_i_1_n_0\,
      CO(2) => \divisor_reg[24]_i_1_n_1\,
      CO(1) => \divisor_reg[24]_i_1_n_2\,
      CO(0) => \divisor_reg[24]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \divisor_reg[24]_i_1_n_4\,
      O(2) => \divisor_reg[24]_i_1_n_5\,
      O(1) => \divisor_reg[24]_i_1_n_6\,
      O(0) => \divisor_reg[24]_i_1_n_7\,
      S(3 downto 0) => divisor_reg(27 downto 24)
    );
\divisor_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[24]_i_1_n_6\,
      Q => divisor_reg(25),
      R => '0'
    );
\divisor_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[24]_i_1_n_5\,
      Q => divisor_reg(26),
      R => '0'
    );
\divisor_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[24]_i_1_n_4\,
      Q => divisor_reg(27),
      R => '0'
    );
\divisor_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[28]_i_1_n_7\,
      Q => divisor_reg(28),
      R => '0'
    );
\divisor_reg[28]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \divisor_reg[24]_i_1_n_0\,
      CO(3) => \NLW_divisor_reg[28]_i_1_CO_UNCONNECTED\(3),
      CO(2) => \divisor_reg[28]_i_1_n_1\,
      CO(1) => \divisor_reg[28]_i_1_n_2\,
      CO(0) => \divisor_reg[28]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \divisor_reg[28]_i_1_n_4\,
      O(2) => \divisor_reg[28]_i_1_n_5\,
      O(1) => \divisor_reg[28]_i_1_n_6\,
      O(0) => \divisor_reg[28]_i_1_n_7\,
      S(3 downto 0) => divisor_reg(31 downto 28)
    );
\divisor_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[28]_i_1_n_6\,
      Q => divisor_reg(29),
      R => '0'
    );
\divisor_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[0]_i_1_n_5\,
      Q => divisor_reg(2),
      R => '0'
    );
\divisor_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[28]_i_1_n_5\,
      Q => divisor_reg(30),
      R => '0'
    );
\divisor_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[28]_i_1_n_4\,
      Q => divisor_reg(31),
      R => '0'
    );
\divisor_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[0]_i_1_n_4\,
      Q => divisor_reg(3),
      R => '0'
    );
\divisor_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[4]_i_1_n_7\,
      Q => divisor_reg(4),
      R => '0'
    );
\divisor_reg[4]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \divisor_reg[0]_i_1_n_0\,
      CO(3) => \divisor_reg[4]_i_1_n_0\,
      CO(2) => \divisor_reg[4]_i_1_n_1\,
      CO(1) => \divisor_reg[4]_i_1_n_2\,
      CO(0) => \divisor_reg[4]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \divisor_reg[4]_i_1_n_4\,
      O(2) => \divisor_reg[4]_i_1_n_5\,
      O(1) => \divisor_reg[4]_i_1_n_6\,
      O(0) => \divisor_reg[4]_i_1_n_7\,
      S(3 downto 0) => divisor_reg(7 downto 4)
    );
\divisor_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[4]_i_1_n_6\,
      Q => divisor_reg(5),
      R => '0'
    );
\divisor_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[4]_i_1_n_5\,
      Q => divisor_reg(6),
      R => '0'
    );
\divisor_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[4]_i_1_n_4\,
      Q => divisor_reg(7),
      R => '0'
    );
\divisor_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[8]_i_1_n_7\,
      Q => divisor_reg(8),
      R => '0'
    );
\divisor_reg[8]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \divisor_reg[4]_i_1_n_0\,
      CO(3) => \divisor_reg[8]_i_1_n_0\,
      CO(2) => \divisor_reg[8]_i_1_n_1\,
      CO(1) => \divisor_reg[8]_i_1_n_2\,
      CO(0) => \divisor_reg[8]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \divisor_reg[8]_i_1_n_4\,
      O(2) => \divisor_reg[8]_i_1_n_5\,
      O(1) => \divisor_reg[8]_i_1_n_6\,
      O(0) => \divisor_reg[8]_i_1_n_7\,
      S(3 downto 0) => divisor_reg(11 downto 8)
    );
\divisor_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \divisor_reg[8]_i_1_n_6\,
      Q => divisor_reg(9),
      R => '0'
    );
\led_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => led_OBUF(0),
      O => led(0)
    );
\led_int[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => swt_IBUF(0),
      I1 => \led_int_reg[0]_i_2_n_0\,
      I2 => led_OBUF(0),
      O => \led_int[0]_i_1_n_0\
    );
\led_int[0]_i_11\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => divisor_reg(22),
      I1 => divisor_reg(23),
      O => \led_int[0]_i_11_n_0\
    );
\led_int[0]_i_12\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => divisor_reg(18),
      I1 => divisor_reg(19),
      O => \led_int[0]_i_12_n_0\
    );
\led_int[0]_i_13\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => divisor_reg(16),
      I1 => divisor_reg(17),
      O => \led_int[0]_i_13_n_0\
    );
\led_int[0]_i_14\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => divisor_reg(23),
      I1 => divisor_reg(22),
      O => \led_int[0]_i_14_n_0\
    );
\led_int[0]_i_15\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => divisor_reg(20),
      I1 => divisor_reg(21),
      O => \led_int[0]_i_15_n_0\
    );
\led_int[0]_i_16\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => divisor_reg(19),
      I1 => divisor_reg(18),
      O => \led_int[0]_i_16_n_0\
    );
\led_int[0]_i_17\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => divisor_reg(17),
      I1 => divisor_reg(16),
      O => \led_int[0]_i_17_n_0\
    );
\led_int[0]_i_19\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => divisor_reg(12),
      I1 => divisor_reg(13),
      O => \led_int[0]_i_19_n_0\
    );
\led_int[0]_i_20\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => divisor_reg(10),
      I1 => divisor_reg(11),
      O => \led_int[0]_i_20_n_0\
    );
\led_int[0]_i_21\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => divisor_reg(8),
      I1 => divisor_reg(9),
      O => \led_int[0]_i_21_n_0\
    );
\led_int[0]_i_22\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => divisor_reg(14),
      I1 => divisor_reg(15),
      O => \led_int[0]_i_22_n_0\
    );
\led_int[0]_i_23\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => divisor_reg(12),
      I1 => divisor_reg(13),
      O => \led_int[0]_i_23_n_0\
    );
\led_int[0]_i_24\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => divisor_reg(11),
      I1 => divisor_reg(10),
      O => \led_int[0]_i_24_n_0\
    );
\led_int[0]_i_25\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => divisor_reg(9),
      I1 => divisor_reg(8),
      O => \led_int[0]_i_25_n_0\
    );
\led_int[0]_i_26\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => divisor_reg(6),
      I1 => divisor_reg(7),
      O => \led_int[0]_i_26_n_0\
    );
\led_int[0]_i_27\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => divisor_reg(4),
      I1 => divisor_reg(5),
      O => \led_int[0]_i_27_n_0\
    );
\led_int[0]_i_28\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => divisor_reg(2),
      I1 => divisor_reg(3),
      O => \led_int[0]_i_28_n_0\
    );
\led_int[0]_i_29\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => divisor_reg(0),
      I1 => divisor_reg(1),
      O => \led_int[0]_i_29_n_0\
    );
\led_int[0]_i_30\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => divisor_reg(6),
      I1 => divisor_reg(7),
      O => \led_int[0]_i_30_n_0\
    );
\led_int[0]_i_31\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => divisor_reg(4),
      I1 => divisor_reg(5),
      O => \led_int[0]_i_31_n_0\
    );
\led_int[0]_i_32\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => divisor_reg(2),
      I1 => divisor_reg(3),
      O => \led_int[0]_i_32_n_0\
    );
\led_int[0]_i_33\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => divisor_reg(0),
      I1 => divisor_reg(1),
      O => \led_int[0]_i_33_n_0\
    );
\led_int[0]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => divisor_reg(30),
      I1 => divisor_reg(31),
      O => \led_int[0]_i_4_n_0\
    );
\led_int[0]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => divisor_reg(26),
      I1 => divisor_reg(27),
      O => \led_int[0]_i_5_n_0\
    );
\led_int[0]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => divisor_reg(30),
      I1 => divisor_reg(31),
      O => \led_int[0]_i_6_n_0\
    );
\led_int[0]_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => divisor_reg(28),
      I1 => divisor_reg(29),
      O => \led_int[0]_i_7_n_0\
    );
\led_int[0]_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => divisor_reg(27),
      I1 => divisor_reg(26),
      O => \led_int[0]_i_8_n_0\
    );
\led_int[0]_i_9\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => divisor_reg(24),
      I1 => divisor_reg(25),
      O => \led_int[0]_i_9_n_0\
    );
\led_int_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => '1',
      D => \led_int[0]_i_1_n_0\,
      Q => led_OBUF(0),
      R => '0'
    );
\led_int_reg[0]_i_10\: unisim.vcomponents.CARRY4
     port map (
      CI => \led_int_reg[0]_i_18_n_0\,
      CO(3) => \led_int_reg[0]_i_10_n_0\,
      CO(2) => \led_int_reg[0]_i_10_n_1\,
      CO(1) => \led_int_reg[0]_i_10_n_2\,
      CO(0) => \led_int_reg[0]_i_10_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2) => \led_int[0]_i_19_n_0\,
      DI(1) => \led_int[0]_i_20_n_0\,
      DI(0) => \led_int[0]_i_21_n_0\,
      O(3 downto 0) => \NLW_led_int_reg[0]_i_10_O_UNCONNECTED\(3 downto 0),
      S(3) => \led_int[0]_i_22_n_0\,
      S(2) => \led_int[0]_i_23_n_0\,
      S(1) => \led_int[0]_i_24_n_0\,
      S(0) => \led_int[0]_i_25_n_0\
    );
\led_int_reg[0]_i_18\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \led_int_reg[0]_i_18_n_0\,
      CO(2) => \led_int_reg[0]_i_18_n_1\,
      CO(1) => \led_int_reg[0]_i_18_n_2\,
      CO(0) => \led_int_reg[0]_i_18_n_3\,
      CYINIT => '1',
      DI(3) => \led_int[0]_i_26_n_0\,
      DI(2) => \led_int[0]_i_27_n_0\,
      DI(1) => \led_int[0]_i_28_n_0\,
      DI(0) => \led_int[0]_i_29_n_0\,
      O(3 downto 0) => \NLW_led_int_reg[0]_i_18_O_UNCONNECTED\(3 downto 0),
      S(3) => \led_int[0]_i_30_n_0\,
      S(2) => \led_int[0]_i_31_n_0\,
      S(1) => \led_int[0]_i_32_n_0\,
      S(0) => \led_int[0]_i_33_n_0\
    );
\led_int_reg[0]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \led_int_reg[0]_i_3_n_0\,
      CO(3) => \led_int_reg[0]_i_2_n_0\,
      CO(2) => \led_int_reg[0]_i_2_n_1\,
      CO(1) => \led_int_reg[0]_i_2_n_2\,
      CO(0) => \led_int_reg[0]_i_2_n_3\,
      CYINIT => '0',
      DI(3) => \led_int[0]_i_4_n_0\,
      DI(2) => '0',
      DI(1) => \led_int[0]_i_5_n_0\,
      DI(0) => '0',
      O(3 downto 0) => \NLW_led_int_reg[0]_i_2_O_UNCONNECTED\(3 downto 0),
      S(3) => \led_int[0]_i_6_n_0\,
      S(2) => \led_int[0]_i_7_n_0\,
      S(1) => \led_int[0]_i_8_n_0\,
      S(0) => \led_int[0]_i_9_n_0\
    );
\led_int_reg[0]_i_3\: unisim.vcomponents.CARRY4
     port map (
      CI => \led_int_reg[0]_i_10_n_0\,
      CO(3) => \led_int_reg[0]_i_3_n_0\,
      CO(2) => \led_int_reg[0]_i_3_n_1\,
      CO(1) => \led_int_reg[0]_i_3_n_2\,
      CO(0) => \led_int_reg[0]_i_3_n_3\,
      CYINIT => '0',
      DI(3) => \led_int[0]_i_11_n_0\,
      DI(2) => divisor_reg(21),
      DI(1) => \led_int[0]_i_12_n_0\,
      DI(0) => \led_int[0]_i_13_n_0\,
      O(3 downto 0) => \NLW_led_int_reg[0]_i_3_O_UNCONNECTED\(3 downto 0),
      S(3) => \led_int[0]_i_14_n_0\,
      S(2) => \led_int[0]_i_15_n_0\,
      S(1) => \led_int[0]_i_16_n_0\,
      S(0) => \led_int[0]_i_17_n_0\
    );
\swt_IBUF[0]_inst\: unisim.vcomponents.IBUF
     port map (
      I => swt(0),
      O => swt_IBUF(0)
    );
end STRUCTURE;
