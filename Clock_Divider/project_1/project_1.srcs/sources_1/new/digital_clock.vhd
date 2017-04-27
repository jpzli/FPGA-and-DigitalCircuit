----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2016 01:51:38 PM
-- Design Name: 
-- Module Name: digital_clock - Behavioral
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

entity digital_clock is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out std_logic;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           AN1 : out STD_LOGIC;
           AN2 : out STD_LOGIC;
           AN3 : out STD_LOGIC;
           AN4 : out STD_LOGIC);
end digital_clock;

architecture Behavioral of digital_clock is

signal i_dp: STD_LOGIC;
signal i_an: std_logic_vector (3 downto 0);
signal i_kHz: STD_logic;
signal digit_to_display: STD_logic_vector(3 downto 0);
signal sec_dig_1, sec_dig_2, min_dig_1, min_dig_2: std_logic_vector(3 downto 0);
signal data: std_logic_vector(3 downto 0);

component sevensegment_selector is
    Port(clk: in STD_logic;
        switch: in STD_logic;
        output: out STD_logic_vector(3 downto 0);
        reset: in STD_logic
        );
end component;

component clock_divider is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
          enable: in STD_LOGIC;
			  kHz: out STD_LOGIC;
			  min_dig_2: out STD_LOGIC_VECTOR (3 downto 0); 
              min_dig_1: out STD_LOGIC_VECTOR (3 downto 0);
              sec_dig_2: out STD_LOGIC_VECTOR (3 downto 0);
              sec_dig_1: out STD_LOGIC_VECTOR (3 downto 0)
			  );
end component;

component sevensegment is
    Port ( CA : out  STD_LOGIC;
          CB : out  STD_LOGIC;
          CC : out  STD_LOGIC;
          CD : out  STD_LOGIC;
          CE : out  STD_LOGIC;
          CF : out  STD_LOGIC;
          CG : out  STD_LOGIC;
          DP : out  STD_LOGIC;
          dp_in: in STD_LOGIC;
          data : in  STD_LOGIC_VECTOR (3 downto 0)
			  );
end component;

begin

Selector: sevensegment_selector
port map(clk => clk,
        switch => i_kHz,
        output => i_an,
        reset => reset
        );
        
Divider: clock_divider
Port map(clk => clk,
        reset => reset,
        enable => enable,
        kHz => i_kHz,
        sec_dig_1 => sec_dig_1,
        sec_dig_2 => sec_dig_2,
        min_dig_1 => min_dig_1,
        min_dig_2 => min_dig_2
        );
        
Display: sevensegment
Port map(CA => CA,
        CB => CB,
        CC => CC,
        CD => CD,
        CE => CE,
        CF => CF,
        CG => CG,
        DP => DP,
        dp_in => i_dp,
        data => digit_to_display
        );

 digit_mux: process(i_an, min_dig_2, min_dig_1, sec_dig_2, sec_dig_1 )
 begin
    case(i_an)is
        when "0001" => digit_to_display <= sec_dig_1;
        when "0010" => digit_to_display <= sec_dig_2;
        when "0100" => digit_to_display <= min_dig_1;
        when "1000" => digit_to_display <= min_dig_2;
        when others => digit_to_display <= "0000";
    end case;
end process;

i_dp <= '0';

AN1 <= not i_an(0);
AN2 <= not i_an(1);
AN3 <= not i_an(2);
AN4 <= not i_an(3);



end Behavioral;
