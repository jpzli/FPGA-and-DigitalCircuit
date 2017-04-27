----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2016 02:45:06 PM
-- Design Name: 
-- Module Name: tb_vga_character_line - Behavioral
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

entity tb_vga_character_line is
--  Port ( );
end tb_vga_character_line;

architecture Behavioral of tb_vga_character_line is

component vga_character_line 
	PORT(
		clk: in std_logic;
		reset: in std_logic;
		accept_new_char: in std_logic;
		new_char_value: in std_logic_vector(6 downto 0);
		scan_line_x: in std_logic_vector(10 downto 0);
		scan_line_y: in std_logic_vector(10 downto 0);
		character_pixel: out std_logic
	);
end component;

signal		clk:  std_logic:='0';
signal		reset:  std_logic:='0';
signal		accept_new_char:  std_logic:='0';
signal		new_char_value:  std_logic_vector(6 downto 0):= (others => '0');
signal		scan_line_x:  std_logic_vector(10 downto 0):= (others => '0');
signal		scan_line_y:  std_logic_vector(10 downto 0):= (others => '0');
signal		character_pixel:  std_logic;

constant clk_period:time:=10ns;

begin
uut: vga_character_line port map(
		clk=>clk,
        reset=>reset,
        accept_new_char=>accept_new_char,
        new_char_value=>new_char_value,
        scan_line_x=>scan_line_x,
        scan_line_y=>scan_line_y,
        character_pixel=>character_pixel
);

clk_process:process
begin
clk<='0';
wait for clk_period/2;
clk<='1';
wait for clk_period/2;
end process;

stim_proc: process
begin
reset<='1';
wait for 100 ns;
reset<='0';
wait;
end process;

end Behavioral;
