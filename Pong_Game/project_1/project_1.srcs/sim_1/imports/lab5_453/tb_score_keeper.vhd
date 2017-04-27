library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_score_keeper is
--  Port ( );
end tb_score_keeper;

architecture Behavioral of tb_score_keeper is


component score_keeper
	PORT(
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		single_digit: out std_logic_vector(3 downto 0);
		tens_digit: out STD_LOGIC_VECTOR(3 downto 0)
	);
end component;

signal clk: std_logic;
signal reset: std_logic;
signal enable: std_logic := '1';
signal single_digit: std_logic_vector(3 downto 0);
signal tens_digit: std_logic_vector(3 downto 0);

constant clk_period: time:= 10 ns;

begin
	uut: score_keeper port map(
	   --box_start_loc_x => start_loc,
		clk => clk,
		reset => reset,
		enable => enable,
		single_digit => single_digit,
		tens_digit => tens_digit
	);
	
	clk_process:process
		begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
	stim_proc:process
        begin
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait;
	end process;

end Behavioral;
