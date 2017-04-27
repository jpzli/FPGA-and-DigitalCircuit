----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2016 12:52:50 PM
-- Design Name: 
-- Module Name: tb_character_rom - Behavioral
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

entity tb_character_rom is
--  Port ( );
end tb_character_rom;

architecture Behavioral of tb_character_rom is

    component character_rom 
    port(
        clk: in std_logic;
        addr: in std_logic_vector(10 downto 0);
        data: out std_logic_vector(7 downto 0)
        );
     end component;
     
     --inputs
     signal clk : std_logic := '0';
     signal addr : std_logic_vector(10 downto 0) := (others => '0');
     
     --outputs
     signal data : std_logic_vector(7 downto 0);
    
     
     constant clk_period : time := 10 ns;

begin
    
      uut: character_rom port map(
            clk => clk,
            addr => addr,
            data => data
           );
           
     --clock deff
     clk_process :process
     begin 
           clk <= '0';
           wait for clk_period/2;
           clk <= '1' ;
           wait for clk_period/2;
     end process;
     
     stim_proc: process
     begin
        addr <= "00000000000";
        wait for clk_period;
        addr <= "00000000000";
        wait for clk_period;
        addr <= "00000011110"; 
        wait for clk_period;  
        addr <= "00000001100";  
        wait for clk_period;
        addr <= "00000001100"; 
        wait for clk_period;
        addr <= "00011001100"; 
        wait for clk_period;
        addr <= "00011001100"; 
        wait for clk_period;
        addr <= "00011001100"; 
        wait for clk_period;
        addr <= "00001111000"; 
        wait for clk_period;
        addr <= "00000000000";
        wait for clk_period;
        addr <= "00000000000";
        wait for clk_period;
        addr <= "00000000000";
        wait for clk_period;
        addr <= "00000000000";
        wait for clk_period;
        
     wait;
     
    end process;     
                  

end Behavioral;
