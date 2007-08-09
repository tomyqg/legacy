-- Generated by PERL program wishbone.pl. Do not edit this file.
--
-- For defines see intercon.defines
--
-- Generated Wed Jul 25 20:27:04 2007
--
-- Wishbone masters:
--   lm32i
--   lm32d
--
-- Wishbone slaves:
--   bram0
--     baseadr 0x00000000 - size 0x00001000
--   farbborg0
--     baseadr 0x80010000 - size 0x00010000
--   timer0
--     baseadr 0x80000000 - size 0x00001000
--   uart0
--     baseadr 0x80001000 - size 0x00001000
--   gpio0
--     baseadr 0x80002000 - size 0x00001000
--   sram0
--     baseadr 0xB0000000 - size 0x00040000
-----------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

package intercon_package is


function "and" (
  l : std_logic_vector;
  r : std_logic)
return std_logic_vector;
end intercon_package;
package body intercon_package is

function "and" (
  l : std_logic_vector;
  r : std_logic)
return std_logic_vector is
  variable result : std_logic_vector(l'range);
begin  -- "and"
  for i in l'range loop
  result(i) := l(i) and r;
end loop;  -- i
return result;
end "and";
end intercon_package;
library IEEE;
use IEEE.std_logic_1164.all;

entity trafic_supervision is

  generic (
    priority     : integer := 1;
    tot_priority : integer := 2);

  port (
    bg           : in  std_logic;       -- bus grant
    ce           : in  std_logic;       -- clock enable
    trafic_limit : out std_logic;
    clk          : in  std_logic;
    reset        : in  std_logic);

end trafic_supervision;

architecture rtl of trafic_supervision is

  signal shreg : std_logic_vector(tot_priority-1 downto 0);
  signal cntr : integer range 0 to tot_priority;

begin  -- rtl

  -- purpose: holds information of usage of latest cycles
  -- type   : sequential
  -- inputs : clk, reset, ce, bg
  -- outputs: shreg('left)
  sh_reg: process (clk,reset)
  begin  -- process shreg
    if reset = '1' then                 -- asynchronous reset (active hi)
      shreg <= (others=>'0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if ce='1' then
        shreg <= shreg(tot_priority-2 downto 0) & bg;
      end if;
    end if;
  end process sh_reg;

  -- purpose: keeps track of used cycles
  -- type   : sequential
  -- inputs : clk, reset, shreg('left), bg, ce
  -- outputs: trafic_limit
  counter: process (clk, reset)
  begin  -- process counter
    if reset = '1' then                 -- asynchronous reset (active hi)
      cntr <= 0;
      trafic_limit <= '0';
    elsif clk'event and clk = '1' then  -- rising clock edge
      if ce='1' then
        if bg='1' and shreg(tot_priority-1)='0' then
          cntr <= cntr + 1;
          if cntr=priority-1 then
            trafic_limit <= '1';
          end if;
        elsif bg='0' and shreg(tot_priority-1)='1' then
          cntr <= cntr - 1;
          if cntr=priority then
            trafic_limit <= '0';
          end if;
        end if;
      end if;
    end if;
  end process counter;

end rtl;

library IEEE;
use IEEE.std_logic_1164.all;
use work.intercon_package.all;

entity intercon is
  port (
  -- wishbone master port(s)
  -- lm32i
  lm32i_dat_i : out std_logic_vector(31 downto 0);
  lm32i_ack_i : out std_logic;
  lm32i_err_i : out std_logic;
  lm32i_rty_i : out std_logic;
  lm32i_dat_o : in  std_logic_vector(31 downto 0);
  lm32i_we_o  : in  std_logic;
  lm32i_sel_o : in  std_logic_vector(3 downto 0);
  lm32i_adr_o : in  std_logic_vector(31 downto 0);
  lm32i_cyc_o : in  std_logic;
  lm32i_stb_o : in  std_logic;
  -- lm32d
  lm32d_dat_i : out std_logic_vector(31 downto 0);
  lm32d_ack_i : out std_logic;
  lm32d_err_i : out std_logic;
  lm32d_rty_i : out std_logic;
  lm32d_dat_o : in  std_logic_vector(31 downto 0);
  lm32d_we_o  : in  std_logic;
  lm32d_sel_o : in  std_logic_vector(3 downto 0);
  lm32d_adr_o : in  std_logic_vector(31 downto 0);
  lm32d_cyc_o : in  std_logic;
  lm32d_stb_o : in  std_logic;
  -- wishbone slave port(s)
  -- bram0
  bram0_dat_o : in  std_logic_vector(31 downto 0);
  bram0_ack_o : in  std_logic;
  bram0_dat_i : out std_logic_vector(31 downto 0);
  bram0_we_i  : out std_logic;
  bram0_sel_i : out std_logic_vector(3 downto 0);
  bram0_adr_i : out std_logic_vector(31 downto 0);
  bram0_cyc_i : out std_logic;
  bram0_stb_i : out std_logic;
  -- farbborg0
  farbborg0_dat_o : in  std_logic_vector(31 downto 0);
  farbborg0_ack_o : in  std_logic;
  farbborg0_dat_i : out std_logic_vector(31 downto 0);
  farbborg0_we_i  : out std_logic;
  farbborg0_sel_i : out std_logic_vector(3 downto 0);
  farbborg0_adr_i : out std_logic_vector(31 downto 0);
  farbborg0_cyc_i : out std_logic;
  farbborg0_stb_i : out std_logic;
  -- timer0
  timer0_dat_o : in  std_logic_vector(31 downto 0);
  timer0_ack_o : in  std_logic;
  timer0_dat_i : out std_logic_vector(31 downto 0);
  timer0_we_i  : out std_logic;
  timer0_sel_i : out std_logic_vector(3 downto 0);
  timer0_adr_i : out std_logic_vector(31 downto 0);
  timer0_cyc_i : out std_logic;
  timer0_stb_i : out std_logic;
  -- uart0
  uart0_dat_o : in  std_logic_vector(31 downto 0);
  uart0_ack_o : in  std_logic;
  uart0_dat_i : out std_logic_vector(31 downto 0);
  uart0_we_i  : out std_logic;
  uart0_sel_i : out std_logic_vector(3 downto 0);
  uart0_adr_i : out std_logic_vector(31 downto 0);
  uart0_cyc_i : out std_logic;
  uart0_stb_i : out std_logic;
  -- gpio0
  gpio0_dat_o : in  std_logic_vector(31 downto 0);
  gpio0_ack_o : in  std_logic;
  gpio0_dat_i : out std_logic_vector(31 downto 0);
  gpio0_we_i  : out std_logic;
  gpio0_sel_i : out std_logic_vector(3 downto 0);
  gpio0_adr_i : out std_logic_vector(31 downto 0);
  gpio0_cyc_i : out std_logic;
  gpio0_stb_i : out std_logic;
  -- sram0
  sram0_dat_o : in  std_logic_vector(31 downto 0);
  sram0_ack_o : in  std_logic;
  sram0_err_o : in  std_logic;
  sram0_rty_o : in  std_logic;
  sram0_dat_i : out std_logic_vector(31 downto 0);
  sram0_we_i  : out std_logic;
  sram0_sel_i : out std_logic_vector(3 downto 0);
  sram0_adr_i : out std_logic_vector(31 downto 0);
  sram0_cyc_i : out std_logic;
  sram0_stb_i : out std_logic;
  -- clock and reset
  clk   : in std_logic;
  reset : in std_logic);
end intercon;
architecture rtl of intercon is
  signal lm32i_bram0_ss : std_logic; -- slave select
  signal lm32i_bram0_bg : std_logic; -- bus grant
  signal lm32i_farbborg0_ss : std_logic; -- slave select
  signal lm32i_farbborg0_bg : std_logic; -- bus grant
  signal lm32i_timer0_ss : std_logic; -- slave select
  signal lm32i_timer0_bg : std_logic; -- bus grant
  signal lm32i_uart0_ss : std_logic; -- slave select
  signal lm32i_uart0_bg : std_logic; -- bus grant
  signal lm32i_gpio0_ss : std_logic; -- slave select
  signal lm32i_gpio0_bg : std_logic; -- bus grant
  signal lm32i_sram0_ss : std_logic; -- slave select
  signal lm32i_sram0_bg : std_logic; -- bus grant
  signal lm32d_bram0_ss : std_logic; -- slave select
  signal lm32d_bram0_bg : std_logic; -- bus grant
  signal lm32d_farbborg0_ss : std_logic; -- slave select
  signal lm32d_farbborg0_bg : std_logic; -- bus grant
  signal lm32d_timer0_ss : std_logic; -- slave select
  signal lm32d_timer0_bg : std_logic; -- bus grant
  signal lm32d_uart0_ss : std_logic; -- slave select
  signal lm32d_uart0_bg : std_logic; -- bus grant
  signal lm32d_gpio0_ss : std_logic; -- slave select
  signal lm32d_gpio0_bg : std_logic; -- bus grant
  signal lm32d_sram0_ss : std_logic; -- slave select
  signal lm32d_sram0_bg : std_logic; -- bus grant
begin  -- rtl
arbiter_bram0 : block
  signal lm32i_bg, lm32i_bg_1, lm32i_bg_2, lm32i_bg_q : std_logic;
  signal lm32i_trafic_limit : std_logic;
  signal lm32d_bg, lm32d_bg_1, lm32d_bg_2, lm32d_bg_q : std_logic;
  signal lm32d_trafic_limit : std_logic;
  signal ce, idle, ack : std_logic;
begin
ack <= bram0_ack_o;

trafic_supervision_1 : entity work.trafic_supervision
generic map(
  priority => 1,
  tot_priority => 2)
port map(
  bg => lm32i_bram0_bg,
  ce => ce,
  trafic_limit => lm32i_trafic_limit,
  clk => clk,
  reset => reset);

trafic_supervision_2 : entity work.trafic_supervision
generic map(
  priority => 1,
  tot_priority => 2)
port map(
  bg => lm32d_bram0_bg,
  ce => ce,
  trafic_limit => lm32d_trafic_limit,
  clk => clk,
  reset => reset);

process(clk,reset)
begin
if reset='1' then
  lm32i_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32i_bg_q='0' then
  lm32i_bg_q <= lm32i_bg;
elsif ack='1' then
  lm32i_bg_q <= '0';
end if;
end if;
end process;

process(clk,reset)
begin
if reset='1' then
  lm32d_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32d_bg_q='0' then
  lm32d_bg_q <= lm32d_bg;
elsif ack='1' then
  lm32d_bg_q <= '0';
end if;
end if;
end process;

idle <= '1' when lm32i_bg_q='0' and lm32d_bg_q='0' else '0';
lm32i_bg_1 <= '1' when idle='1' and lm32i_cyc_o='1' and lm32i_bram0_ss='1' and lm32i_trafic_limit='0' else '0';
lm32d_bg_1 <= '1' when idle='1' and (lm32i_bg_1='0') and lm32d_cyc_o='1' and lm32d_bram0_ss='1' and lm32d_trafic_limit='0' else '0';
lm32i_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0') and lm32i_cyc_o='1' and lm32i_bram0_ss='1' else '0';
lm32d_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0' and lm32i_bg_2='0') and lm32d_cyc_o='1' and lm32d_bram0_ss='1' else '0';
lm32i_bg <= lm32i_bg_q or lm32i_bg_1 or lm32i_bg_2;
lm32d_bg <= lm32d_bg_q or lm32d_bg_1 or lm32d_bg_2;
ce <= (lm32i_cyc_o and lm32i_bram0_ss) or (lm32d_cyc_o and lm32d_bram0_ss) when idle='1' else '0';
lm32i_bram0_bg <= lm32i_bg;
lm32d_bram0_bg <= lm32d_bg;
end block arbiter_bram0;
arbiter_farbborg0 : block
  signal lm32i_bg, lm32i_bg_1, lm32i_bg_2, lm32i_bg_q : std_logic;
  signal lm32i_trafic_limit : std_logic;
  signal lm32d_bg, lm32d_bg_1, lm32d_bg_2, lm32d_bg_q : std_logic;
  signal lm32d_trafic_limit : std_logic;
  signal ce, idle, ack : std_logic;
begin
ack <= farbborg0_ack_o;

trafic_supervision_1 : entity work.trafic_supervision
generic map(
  priority => 0,
  tot_priority => 0)
port map(
  bg => lm32i_farbborg0_bg,
  ce => ce,
  trafic_limit => lm32i_trafic_limit,
  clk => clk,
  reset => reset);

trafic_supervision_2 : entity work.trafic_supervision
generic map(
  priority => 0,
  tot_priority => 0)
port map(
  bg => lm32d_farbborg0_bg,
  ce => ce,
  trafic_limit => lm32d_trafic_limit,
  clk => clk,
  reset => reset);

process(clk,reset)
begin
if reset='1' then
  lm32i_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32i_bg_q='0' then
  lm32i_bg_q <= lm32i_bg;
elsif ack='1' then
  lm32i_bg_q <= '0';
end if;
end if;
end process;

process(clk,reset)
begin
if reset='1' then
  lm32d_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32d_bg_q='0' then
  lm32d_bg_q <= lm32d_bg;
elsif ack='1' then
  lm32d_bg_q <= '0';
end if;
end if;
end process;

idle <= '1' when lm32i_bg_q='0' and lm32d_bg_q='0' else '0';
lm32i_bg_1 <= '1' when idle='1' and lm32i_cyc_o='1' and lm32i_farbborg0_ss='1' and lm32i_trafic_limit='0' else '0';
lm32d_bg_1 <= '1' when idle='1' and (lm32i_bg_1='0') and lm32d_cyc_o='1' and lm32d_farbborg0_ss='1' and lm32d_trafic_limit='0' else '0';
lm32i_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0') and lm32i_cyc_o='1' and lm32i_farbborg0_ss='1' else '0';
lm32d_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0' and lm32i_bg_2='0') and lm32d_cyc_o='1' and lm32d_farbborg0_ss='1' else '0';
lm32i_bg <= lm32i_bg_q or lm32i_bg_1 or lm32i_bg_2;
lm32d_bg <= lm32d_bg_q or lm32d_bg_1 or lm32d_bg_2;
ce <= (lm32i_cyc_o and lm32i_farbborg0_ss) or (lm32d_cyc_o and lm32d_farbborg0_ss) when idle='1' else '0';
lm32i_farbborg0_bg <= lm32i_bg;
lm32d_farbborg0_bg <= lm32d_bg;
end block arbiter_farbborg0;
arbiter_timer0 : block
  signal lm32i_bg, lm32i_bg_1, lm32i_bg_2, lm32i_bg_q : std_logic;
  signal lm32i_trafic_limit : std_logic;
  signal lm32d_bg, lm32d_bg_1, lm32d_bg_2, lm32d_bg_q : std_logic;
  signal lm32d_trafic_limit : std_logic;
  signal ce, idle, ack : std_logic;
begin
ack <= timer0_ack_o;

trafic_supervision_1 : entity work.trafic_supervision
generic map(
  priority => 1,
  tot_priority => 2)
port map(
  bg => lm32i_timer0_bg,
  ce => ce,
  trafic_limit => lm32i_trafic_limit,
  clk => clk,
  reset => reset);

trafic_supervision_2 : entity work.trafic_supervision
generic map(
  priority => 1,
  tot_priority => 2)
port map(
  bg => lm32d_timer0_bg,
  ce => ce,
  trafic_limit => lm32d_trafic_limit,
  clk => clk,
  reset => reset);

process(clk,reset)
begin
if reset='1' then
  lm32i_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32i_bg_q='0' then
  lm32i_bg_q <= lm32i_bg;
elsif ack='1' then
  lm32i_bg_q <= '0';
end if;
end if;
end process;

process(clk,reset)
begin
if reset='1' then
  lm32d_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32d_bg_q='0' then
  lm32d_bg_q <= lm32d_bg;
elsif ack='1' then
  lm32d_bg_q <= '0';
end if;
end if;
end process;

idle <= '1' when lm32i_bg_q='0' and lm32d_bg_q='0' else '0';
lm32i_bg_1 <= '1' when idle='1' and lm32i_cyc_o='1' and lm32i_timer0_ss='1' and lm32i_trafic_limit='0' else '0';
lm32d_bg_1 <= '1' when idle='1' and (lm32i_bg_1='0') and lm32d_cyc_o='1' and lm32d_timer0_ss='1' and lm32d_trafic_limit='0' else '0';
lm32i_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0') and lm32i_cyc_o='1' and lm32i_timer0_ss='1' else '0';
lm32d_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0' and lm32i_bg_2='0') and lm32d_cyc_o='1' and lm32d_timer0_ss='1' else '0';
lm32i_bg <= lm32i_bg_q or lm32i_bg_1 or lm32i_bg_2;
lm32d_bg <= lm32d_bg_q or lm32d_bg_1 or lm32d_bg_2;
ce <= (lm32i_cyc_o and lm32i_timer0_ss) or (lm32d_cyc_o and lm32d_timer0_ss) when idle='1' else '0';
lm32i_timer0_bg <= lm32i_bg;
lm32d_timer0_bg <= lm32d_bg;
end block arbiter_timer0;
arbiter_uart0 : block
  signal lm32i_bg, lm32i_bg_1, lm32i_bg_2, lm32i_bg_q : std_logic;
  signal lm32i_trafic_limit : std_logic;
  signal lm32d_bg, lm32d_bg_1, lm32d_bg_2, lm32d_bg_q : std_logic;
  signal lm32d_trafic_limit : std_logic;
  signal ce, idle, ack : std_logic;
begin
ack <= uart0_ack_o;

trafic_supervision_1 : entity work.trafic_supervision
generic map(
  priority => 1,
  tot_priority => 2)
port map(
  bg => lm32i_uart0_bg,
  ce => ce,
  trafic_limit => lm32i_trafic_limit,
  clk => clk,
  reset => reset);

trafic_supervision_2 : entity work.trafic_supervision
generic map(
  priority => 1,
  tot_priority => 2)
port map(
  bg => lm32d_uart0_bg,
  ce => ce,
  trafic_limit => lm32d_trafic_limit,
  clk => clk,
  reset => reset);

process(clk,reset)
begin
if reset='1' then
  lm32i_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32i_bg_q='0' then
  lm32i_bg_q <= lm32i_bg;
elsif ack='1' then
  lm32i_bg_q <= '0';
end if;
end if;
end process;

process(clk,reset)
begin
if reset='1' then
  lm32d_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32d_bg_q='0' then
  lm32d_bg_q <= lm32d_bg;
elsif ack='1' then
  lm32d_bg_q <= '0';
end if;
end if;
end process;

idle <= '1' when lm32i_bg_q='0' and lm32d_bg_q='0' else '0';
lm32i_bg_1 <= '1' when idle='1' and lm32i_cyc_o='1' and lm32i_uart0_ss='1' and lm32i_trafic_limit='0' else '0';
lm32d_bg_1 <= '1' when idle='1' and (lm32i_bg_1='0') and lm32d_cyc_o='1' and lm32d_uart0_ss='1' and lm32d_trafic_limit='0' else '0';
lm32i_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0') and lm32i_cyc_o='1' and lm32i_uart0_ss='1' else '0';
lm32d_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0' and lm32i_bg_2='0') and lm32d_cyc_o='1' and lm32d_uart0_ss='1' else '0';
lm32i_bg <= lm32i_bg_q or lm32i_bg_1 or lm32i_bg_2;
lm32d_bg <= lm32d_bg_q or lm32d_bg_1 or lm32d_bg_2;
ce <= (lm32i_cyc_o and lm32i_uart0_ss) or (lm32d_cyc_o and lm32d_uart0_ss) when idle='1' else '0';
lm32i_uart0_bg <= lm32i_bg;
lm32d_uart0_bg <= lm32d_bg;
end block arbiter_uart0;
arbiter_gpio0 : block
  signal lm32i_bg, lm32i_bg_1, lm32i_bg_2, lm32i_bg_q : std_logic;
  signal lm32i_trafic_limit : std_logic;
  signal lm32d_bg, lm32d_bg_1, lm32d_bg_2, lm32d_bg_q : std_logic;
  signal lm32d_trafic_limit : std_logic;
  signal ce, idle, ack : std_logic;
begin
ack <= gpio0_ack_o;

trafic_supervision_1 : entity work.trafic_supervision
generic map(
  priority => 1,
  tot_priority => 2)
port map(
  bg => lm32i_gpio0_bg,
  ce => ce,
  trafic_limit => lm32i_trafic_limit,
  clk => clk,
  reset => reset);

trafic_supervision_2 : entity work.trafic_supervision
generic map(
  priority => 1,
  tot_priority => 2)
port map(
  bg => lm32d_gpio0_bg,
  ce => ce,
  trafic_limit => lm32d_trafic_limit,
  clk => clk,
  reset => reset);

process(clk,reset)
begin
if reset='1' then
  lm32i_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32i_bg_q='0' then
  lm32i_bg_q <= lm32i_bg;
elsif ack='1' then
  lm32i_bg_q <= '0';
end if;
end if;
end process;

process(clk,reset)
begin
if reset='1' then
  lm32d_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32d_bg_q='0' then
  lm32d_bg_q <= lm32d_bg;
elsif ack='1' then
  lm32d_bg_q <= '0';
end if;
end if;
end process;

idle <= '1' when lm32i_bg_q='0' and lm32d_bg_q='0' else '0';
lm32i_bg_1 <= '1' when idle='1' and lm32i_cyc_o='1' and lm32i_gpio0_ss='1' and lm32i_trafic_limit='0' else '0';
lm32d_bg_1 <= '1' when idle='1' and (lm32i_bg_1='0') and lm32d_cyc_o='1' and lm32d_gpio0_ss='1' and lm32d_trafic_limit='0' else '0';
lm32i_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0') and lm32i_cyc_o='1' and lm32i_gpio0_ss='1' else '0';
lm32d_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0' and lm32i_bg_2='0') and lm32d_cyc_o='1' and lm32d_gpio0_ss='1' else '0';
lm32i_bg <= lm32i_bg_q or lm32i_bg_1 or lm32i_bg_2;
lm32d_bg <= lm32d_bg_q or lm32d_bg_1 or lm32d_bg_2;
ce <= (lm32i_cyc_o and lm32i_gpio0_ss) or (lm32d_cyc_o and lm32d_gpio0_ss) when idle='1' else '0';
lm32i_gpio0_bg <= lm32i_bg;
lm32d_gpio0_bg <= lm32d_bg;
end block arbiter_gpio0;
arbiter_sram0 : block
  signal lm32i_bg, lm32i_bg_1, lm32i_bg_2, lm32i_bg_q : std_logic;
  signal lm32i_trafic_limit : std_logic;
  signal lm32d_bg, lm32d_bg_1, lm32d_bg_2, lm32d_bg_q : std_logic;
  signal lm32d_trafic_limit : std_logic;
  signal ce, idle, ack : std_logic;
begin
ack <= sram0_ack_o;

trafic_supervision_1 : entity work.trafic_supervision
generic map(
  priority => 1,
  tot_priority => 2)
port map(
  bg => lm32i_sram0_bg,
  ce => ce,
  trafic_limit => lm32i_trafic_limit,
  clk => clk,
  reset => reset);

trafic_supervision_2 : entity work.trafic_supervision
generic map(
  priority => 1,
  tot_priority => 2)
port map(
  bg => lm32d_sram0_bg,
  ce => ce,
  trafic_limit => lm32d_trafic_limit,
  clk => clk,
  reset => reset);

process(clk,reset)
begin
if reset='1' then
  lm32i_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32i_bg_q='0' then
  lm32i_bg_q <= lm32i_bg;
elsif ack='1' then
  lm32i_bg_q <= '0';
end if;
end if;
end process;

process(clk,reset)
begin
if reset='1' then
  lm32d_bg_q <= '0';
elsif clk'event and clk='1' then
if lm32d_bg_q='0' then
  lm32d_bg_q <= lm32d_bg;
elsif ack='1' then
  lm32d_bg_q <= '0';
end if;
end if;
end process;

idle <= '1' when lm32i_bg_q='0' and lm32d_bg_q='0' else '0';
lm32i_bg_1 <= '1' when idle='1' and lm32i_cyc_o='1' and lm32i_sram0_ss='1' and lm32i_trafic_limit='0' else '0';
lm32d_bg_1 <= '1' when idle='1' and (lm32i_bg_1='0') and lm32d_cyc_o='1' and lm32d_sram0_ss='1' and lm32d_trafic_limit='0' else '0';
lm32i_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0') and lm32i_cyc_o='1' and lm32i_sram0_ss='1' else '0';
lm32d_bg_2 <= '1' when idle='1' and (lm32i_bg_1='0' and lm32d_bg_1='0' and lm32i_bg_2='0') and lm32d_cyc_o='1' and lm32d_sram0_ss='1' else '0';
lm32i_bg <= lm32i_bg_q or lm32i_bg_1 or lm32i_bg_2;
lm32d_bg <= lm32d_bg_q or lm32d_bg_1 or lm32d_bg_2;
ce <= (lm32i_cyc_o and lm32i_sram0_ss) or (lm32d_cyc_o and lm32d_sram0_ss) when idle='1' else '0';
lm32i_sram0_bg <= lm32i_bg;
lm32d_sram0_bg <= lm32d_bg;
end block arbiter_sram0;
decoder:block
begin
lm32i_bram0_ss <= '1' when lm32i_adr_o(31 downto 12)="00000000000000000000" else 
'0';
lm32i_farbborg0_ss <= '1' when lm32i_adr_o(31 downto 16)="1000000000000001" else 
'0';
lm32i_timer0_ss <= '1' when lm32i_adr_o(31 downto 12)="10000000000000000000" else 
'0';
lm32i_uart0_ss <= '1' when lm32i_adr_o(31 downto 12)="10000000000000000001" else 
'0';
lm32i_gpio0_ss <= '1' when lm32i_adr_o(31 downto 12)="10000000000000000010" else 
'0';
lm32i_sram0_ss <= '1' when lm32i_adr_o(31 downto 18)="10110000000000" else 
'0';
lm32d_bram0_ss <= '1' when lm32d_adr_o(31 downto 12)="00000000000000000000" else 
'0';
lm32d_farbborg0_ss <= '1' when lm32d_adr_o(31 downto 16)="1000000000000001" else 
'0';
lm32d_timer0_ss <= '1' when lm32d_adr_o(31 downto 12)="10000000000000000000" else 
'0';
lm32d_uart0_ss <= '1' when lm32d_adr_o(31 downto 12)="10000000000000000001" else 
'0';
lm32d_gpio0_ss <= '1' when lm32d_adr_o(31 downto 12)="10000000000000000010" else 
'0';
lm32d_sram0_ss <= '1' when lm32d_adr_o(31 downto 18)="10110000000000" else 
'0';
bram0_adr_i <= (lm32i_adr_o(31 downto 0) and lm32i_bram0_bg) or (lm32d_adr_o(31 downto 0) and lm32d_bram0_bg);
farbborg0_adr_i <= (lm32i_adr_o(31 downto 0) and lm32i_farbborg0_bg) or (lm32d_adr_o(31 downto 0) and lm32d_farbborg0_bg);
timer0_adr_i <= (lm32i_adr_o(31 downto 0) and lm32i_timer0_bg) or (lm32d_adr_o(31 downto 0) and lm32d_timer0_bg);
uart0_adr_i <= (lm32i_adr_o(31 downto 0) and lm32i_uart0_bg) or (lm32d_adr_o(31 downto 0) and lm32d_uart0_bg);
gpio0_adr_i <= (lm32i_adr_o(31 downto 0) and lm32i_gpio0_bg) or (lm32d_adr_o(31 downto 0) and lm32d_gpio0_bg);
sram0_adr_i <= (lm32i_adr_o(31 downto 0) and lm32i_sram0_bg) or (lm32d_adr_o(31 downto 0) and lm32d_sram0_bg);
end block decoder;

-- cyc_i(s)
bram0_cyc_i <= (lm32i_cyc_o and lm32i_bram0_bg) or (lm32d_cyc_o and lm32d_bram0_bg);
farbborg0_cyc_i <= (lm32i_cyc_o and lm32i_farbborg0_bg) or (lm32d_cyc_o and lm32d_farbborg0_bg);
timer0_cyc_i <= (lm32i_cyc_o and lm32i_timer0_bg) or (lm32d_cyc_o and lm32d_timer0_bg);
uart0_cyc_i <= (lm32i_cyc_o and lm32i_uart0_bg) or (lm32d_cyc_o and lm32d_uart0_bg);
gpio0_cyc_i <= (lm32i_cyc_o and lm32i_gpio0_bg) or (lm32d_cyc_o and lm32d_gpio0_bg);
sram0_cyc_i <= (lm32i_cyc_o and lm32i_sram0_bg) or (lm32d_cyc_o and lm32d_sram0_bg);
-- stb_i(s)
bram0_stb_i <= (lm32i_stb_o and lm32i_bram0_bg) or (lm32d_stb_o and lm32d_bram0_bg);
farbborg0_stb_i <= (lm32i_stb_o and lm32i_farbborg0_bg) or (lm32d_stb_o and lm32d_farbborg0_bg);
timer0_stb_i <= (lm32i_stb_o and lm32i_timer0_bg) or (lm32d_stb_o and lm32d_timer0_bg);
uart0_stb_i <= (lm32i_stb_o and lm32i_uart0_bg) or (lm32d_stb_o and lm32d_uart0_bg);
gpio0_stb_i <= (lm32i_stb_o and lm32i_gpio0_bg) or (lm32d_stb_o and lm32d_gpio0_bg);
sram0_stb_i <= (lm32i_stb_o and lm32i_sram0_bg) or (lm32d_stb_o and lm32d_sram0_bg);
-- we_i(s)
bram0_we_i <= (lm32i_we_o and lm32i_bram0_bg) or (lm32d_we_o and lm32d_bram0_bg);
farbborg0_we_i <= (lm32i_we_o and lm32i_farbborg0_bg) or (lm32d_we_o and lm32d_farbborg0_bg);
timer0_we_i <= (lm32i_we_o and lm32i_timer0_bg) or (lm32d_we_o and lm32d_timer0_bg);
uart0_we_i <= (lm32i_we_o and lm32i_uart0_bg) or (lm32d_we_o and lm32d_uart0_bg);
gpio0_we_i <= (lm32i_we_o and lm32i_gpio0_bg) or (lm32d_we_o and lm32d_gpio0_bg);
sram0_we_i <= (lm32i_we_o and lm32i_sram0_bg) or (lm32d_we_o and lm32d_sram0_bg);
-- ack_i(s)
lm32i_ack_i <= (bram0_ack_o and lm32i_bram0_bg) or (farbborg0_ack_o and lm32i_farbborg0_bg) or (timer0_ack_o and lm32i_timer0_bg) or (uart0_ack_o and lm32i_uart0_bg) or (gpio0_ack_o and lm32i_gpio0_bg) or (sram0_ack_o and lm32i_sram0_bg);
lm32d_ack_i <= (bram0_ack_o and lm32d_bram0_bg) or (farbborg0_ack_o and lm32d_farbborg0_bg) or (timer0_ack_o and lm32d_timer0_bg) or (uart0_ack_o and lm32d_uart0_bg) or (gpio0_ack_o and lm32d_gpio0_bg) or (sram0_ack_o and lm32d_sram0_bg);
-- rty_i(s)
lm32i_rty_i <= '0';
lm32d_rty_i <= '0';
-- err_i(s)
lm32i_err_i <= '0';
lm32d_err_i <= '0';
-- sel_i(s)
bram0_sel_i <= (lm32i_sel_o and lm32i_bram0_bg) or (lm32d_sel_o and lm32d_bram0_bg);
farbborg0_sel_i <= (lm32i_sel_o and lm32i_farbborg0_bg) or (lm32d_sel_o and lm32d_farbborg0_bg);
timer0_sel_i <= (lm32i_sel_o and lm32i_timer0_bg) or (lm32d_sel_o and lm32d_timer0_bg);
uart0_sel_i <= (lm32i_sel_o and lm32i_uart0_bg) or (lm32d_sel_o and lm32d_uart0_bg);
gpio0_sel_i <= (lm32i_sel_o and lm32i_gpio0_bg) or (lm32d_sel_o and lm32d_gpio0_bg);
sram0_sel_i <= (lm32i_sel_o and lm32i_sram0_bg) or (lm32d_sel_o and lm32d_sram0_bg);
-- slave dat_i(s)
bram0_dat_i <= (lm32i_dat_o and lm32i_bram0_bg) or (lm32d_dat_o and lm32d_bram0_bg);
farbborg0_dat_i <= (lm32i_dat_o and lm32i_farbborg0_bg) or (lm32d_dat_o and lm32d_farbborg0_bg);
timer0_dat_i <= (lm32i_dat_o and lm32i_timer0_bg) or (lm32d_dat_o and lm32d_timer0_bg);
uart0_dat_i <= (lm32i_dat_o and lm32i_uart0_bg) or (lm32d_dat_o and lm32d_uart0_bg);
gpio0_dat_i <= (lm32i_dat_o and lm32i_gpio0_bg) or (lm32d_dat_o and lm32d_gpio0_bg);
sram0_dat_i <= (lm32i_dat_o and lm32i_sram0_bg) or (lm32d_dat_o and lm32d_sram0_bg);
-- master dat_i(s)
lm32i_dat_i <= (bram0_dat_o and lm32i_bram0_bg) or (farbborg0_dat_o and lm32i_farbborg0_bg) or (timer0_dat_o and lm32i_timer0_bg) or (uart0_dat_o and lm32i_uart0_bg) or (gpio0_dat_o and lm32i_gpio0_bg) or (sram0_dat_o and lm32i_sram0_bg);
lm32d_dat_i <= (bram0_dat_o and lm32d_bram0_bg) or (farbborg0_dat_o and lm32d_farbborg0_bg) or (timer0_dat_o and lm32d_timer0_bg) or (uart0_dat_o and lm32d_uart0_bg) or (gpio0_dat_o and lm32d_gpio0_bg) or (sram0_dat_o and lm32d_sram0_bg);
-- tgc_i
-- tga_i
end rtl;