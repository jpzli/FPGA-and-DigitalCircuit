library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_up_down_counter is
--  Port ( );
end tb_up_down_counter;

architecture Behavioral of tb_up_down_counter is
component up_down_counter is
    Port ( 
		up: in STD_LOGIC;
		down: in STD_LOGIC;
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
        val: out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
		);
end component;

	signal up: std_logic;
	signal reset: std_logic;
	signal down: std_logic;
	signal clk: std_logic;
	signal enable: std_logic;
	signal val: std_logic_vector (WIDTH-1 downto 0);

	begin
		uut: up_down_counter port map(
			up => up,
			reset => reset,
			down => down,
			clk => clk,
			enable => enable,
			val => val
		);
		
	enable_process:process
		begin
		enable <= '0';
		wait for clk_period * 10;
		enable <= '1';
		wait for clk_period * 10;
	end process;
	
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
		
		up <= '1';
		wait for 100 ns;
		up <= '0';
		wait for 100 ns;
		
		down <= '1';
		wait for 100 ns;
		down <= '0';
		wait for 100 ns;
		
	end process;

end Behavioral;

 

