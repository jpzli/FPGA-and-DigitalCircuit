----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2016 04:48:12 PM
-- Design Name: 
-- Module Name: tb_vga_module - Behavioral
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

entity tb_vga_module is
--  Port ( );
end tb_vga_module;

architecture Behavioral of tb_vga_module is

COMPONENT vga_module
PORT(
        clk : in  STD_LOGIC;
        buttons: in STD_LOGIC_VECTOR(2 downto 0);
        switches: in STD_LOGIC_VECTOR(13 downto 0);
        red: out STD_LOGIC_VECTOR(3 downto 0);
        green: out STD_LOGIC_VECTOR(3 downto 0);
        blue: out STD_LOGIC_VECTOR(3 downto 0);
        hsync: out STD_LOGIC;
        vsync: out STD_LOGIC
    );
 END COMPONENT;
 
signal clk : std_logic := '0';
 signal buttons: std_logic_vector(2 downto 0);
 signal switches: std_logic_vector(13 downto 0);
 
 signal red: std_logic_vector (3 downto 0);
 signal green: std_logic_vector (3 downto 0);
 signal blue: std_logic_vector (3 downto 0);
 signal hsync: std_logic;
 signal vsync: std_logic;

constant clk_period: time:=10 ns;

Begin
uut: vga_module PORT MAP(
    clk => clk,
    buttons => buttons,
    switches => switches,
    red => red,
    green =>green,
    blue => blue,
    hsync => hsync,
    vsync => vsync
    );
    
clk_process: process
begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
 end process;

stim_proc:process
begin
    buttons <= "000";
    switches <= "00000000000000";
    wait for clk_period * 2;
    
--Test reset button
    buttons(0) <= '1';
    wait for clk_period * 20;
    buttons(0) <= '0';
    wait for 100 ns;
    
--Test the box_color switches    
       switches <="00000000001111";
       wait for 100 ns;
       switches <="00000011110000";
       wait for 100 ns;
       
--Test the box_size buttons
        buttons(2 downto 1) <= "01";
        wait for 1000 ns;
        buttons(2 downto 1) <= "01";
        wait for 1000 ns;
        buttons(2 downto 1) <= "01";
        wait for 1000 ns;
        buttons(2 downto 1) <= "10";
        wait for 1000 ns;
        buttons(2 downto 1) <= "10";
        wait for 1000 ns;
        buttons(2 downto 1) <= "10";
        wait for 1000 ns;
        
--Test the vga select
        switches(13) <= '0';
        wait for 1 ms;
        switches(13) <= '1';
        wait for 1 ms;        
 end process;

--vga_mode: process
--begin
--    wait for 1 ms;
--    switches(12) <= '0';
--    wait for 1 ms; 
--    switches(12) <=  '1';
--       wait for 1 ms;
--end process;

--test_switches: process
--begin
--        wait for 10 ms;    
--       switches <="00000000001111";
--       wait for 20 ns;
--       switches <="00000011110000";
--       wait;
--    switches <="00000000000001";
--    wait for 20 ns;
--    switches <="00000000000010";
--    wait for clk_period;
--    switches <="00000000000100";
--    wait for clk_period;
--    switches <="00000000001000";
--    wait for clk_period;
--    switches <="00000000010000";
--    wait for clk_period;
--    switches <="00000000100000";
--    wait for clk_period;
--    switches <="00000001000000";
--    wait for clk_period;
--    switches <="00000010000000";
--    wait for clk_period;
--    switches <="00000100000000";
--    wait for clk_period;
--    switches <="00001000000000";
--    wait for clk_period;
--    switches <="00010000000000";
--    wait for clk_period;
--    switches <="00100000000000";
--      wait;
--    end process;
end Behavioral;

	
