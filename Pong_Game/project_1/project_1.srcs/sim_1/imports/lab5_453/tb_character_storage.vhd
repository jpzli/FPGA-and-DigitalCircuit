----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2016 02:04:10 PM
-- Design Name: 
-- Module Name: tb_character_storage - Behavioral
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

entity tb_character_storage is

end tb_character_storage;

architecture Behavioral of tb_character_storage is

    component character_storage 
    PORT(
            clk: in std_logic;
            reset: in std_logic;
            write_to_loc: in std_logic;
            write_value: in std_logic_vector(6 downto 0);
            read_loc: in std_logic_vector(5 downto 0);
            read_value: out std_logic_vector(10 downto 0)  
           ); 
    end component;         

--inputs
     signal clk:  std_logic:='0';
     signal reset:  std_logic:='0';
     signal write_to_loc:  std_logic:='0';
     signal write_value:  std_logic_vector(6 downto 0):= (others => '0') ;
     signal read_loc:  std_logic_vector(5 downto 0):= (others => '0');
--outputs
     signal read_value:  std_logic_vector(10 downto 0);
     
      
     constant clk_period : time := 10 ns;


begin

 uut: character_storage PORT MAP (
          clk => clk,
          reset => reset,
          write_to_loc => write_to_loc,
          write_value => write_value,
          read_loc => read_loc,
          read_value => read_value
          );

   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
   
   stim_proc: process
      begin        
         -- hold reset state for 100 ns.
          wait for 105 ns;    
          reset <= '1';
          wait for clk_period*10;
          reset <= '0';
         -- insert stimulus here 
           write_value <= "1001000";    --H-0x48
           write_to_loc <= '1';
           wait for clk_period;
           write_to_loc <= '0';
           wait for clk_period;
           
           write_value <= "1000101";    --E-0x45
           write_to_loc <= '1';
           wait for clk_period;
           write_to_loc <= '0';
           wait for clk_period;
   
           write_value <= "1100001";    --A-0x61
           write_to_loc <= '1';
           wait for clk_period;
           write_to_loc <= '0';
           wait for clk_period;
   
           write_value <= "1010000";    --P-0x50
           write_to_loc <= '1';
           wait for clk_period;
           write_to_loc <= '0';
           wait for clk_period;
           
           read_loc <= "000011";
           wait for clk_period;
           read_loc <= "000010";
           wait for clk_period;
           read_loc <= "000001";
           wait for clk_period;
           read_loc <= "000000";
           wait for clk_period;
          
       wait;
      end process; 
       
           

end Behavioral;
