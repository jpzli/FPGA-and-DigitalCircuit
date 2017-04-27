library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity score_keeper is
	PORT(
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		single_digit: out std_logic_vector(3 downto 0);
		tens_digit: out STD_LOGIC_VECTOR(3 downto 0)
	);
end score_keeper;

architecture Behavioral of score_keeper is

component downcounter is
	Generic ( 	period: integer:= 4;				
					WIDTH: integer:= 3);
		Port ( clk : in  STD_LOGIC;
				  reset : in  STD_LOGIC;
				  enable : in  STD_LOGIC;
				  zero : out  STD_LOGIC;
				  value: out STD_LOGIC_VECTOR(WIDTH-1 downto 0));
end component;

signal i_single_digit, i_tens_digit: STD_LOGIC_VECTOR(3 downto 0);
signal enable_tens_digit: std_logic;

begin

-- PART A: add downcounter instances here
ONES: downcounter
Generic Map( period => (10-1),
			 WIDTH => 4
			 )
Port Map(
		CLK => clk,
		reset => reset,
		enable => enable,
		zero => enable_tens_digit,
		value => i_single_digit
);

TENS: downcounter
Generic Map( period => (10-1),
			 WIDTH => 4
			 )
Port Map(
		CLK => clk,
		reset => reset,
		enable => enable_tens_digit,
		zero => open,
		value => i_tens_digit
);
-- one for the single digit
-- one for the tens digit

-- PART B: Add the logic to compute the single_digit and tens_digit
single_digit <= "1001" - (i_single_digit);
tens_digit <= "1001" - (i_tens_digit);


end Behavioral;

