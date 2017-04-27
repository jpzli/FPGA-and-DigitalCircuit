----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2016 04:03:11 PM
-- Design Name: 
-- Module Name: tb_clock_divider - Behavioral
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
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_clock_divider is
--  Port ( );
end tb_clock_divider;

ARCHITECTURE behavior OF tb_clock_divider IS
 
    -- Component Declaration for the Unit Under Test (UUT)
 
Component clock_divider 
        Port ( clk : in  STD_LOGIC;
               reset : in  STD_LOGIC;
               enable: in STD_LOGIC;
                  kHz: out STD_LOGIC;
                  min_dig_2: out STD_LOGIC_VECTOR (3 downto 0); 
                  min_dig_1: out STD_LOGIC_VECTOR (3 downto 0);
                  sec_dig_2: out STD_LOGIC_VECTOR (3 downto 0);
                  sec_dig_1: out STD_LOGIC_VECTOR (3 downto 0)
               -- Add output buses (STD_LOGIC_VECTOR(x downto y))
               -- here to hold values of single seconds, tens of seconds,
               -- minutes, and tens of minutes. Consult Lab 1 intructions
               -- if you are not sure of syntax.      
                  );
    end Component;
    
    -- Signals:
    signal clk : std_logic := '0';
    signal reset: std_logic := '0';
    signal enable: STD_LOGIC := '0';
    signal khz: std_logic;
    signal min_dig_2: STD_LOGIC_VECTOR (3 downto 0); 
    signal min_dig_1: STD_LOGIC_VECTOR (3 downto 0);
  signal sec_dig_2: STD_LOGIC_VECTOR (3 downto 0);
  signal sec_dig_1: STD_LOGIC_VECTOR (3 downto 0);

 
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
   uut: clock_divider PORT MAP (
          clk => clk,
          reset => reset,
          enable => enable,
          kHz => kHz,
          min_dig_2 => min_dig_2,
          min_dig_1 => min_dig_1,
          sec_dig_2 => sec_dig_2,
          sec_dig_1 => sec_dig_1
        );
   -- Clock process definitions
   clk_process :process
   begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin  
      -- hold reset state for 100 ns.
	  reset <= '0';
      wait for 100 ns; 
        reset <= '1';
      wait for clk_period*10;
        reset <= '0';
        enable <= '1';
  
      wait;
   end process;
END;
