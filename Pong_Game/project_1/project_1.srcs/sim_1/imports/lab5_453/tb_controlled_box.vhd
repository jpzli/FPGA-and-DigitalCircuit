library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_controlled_box is
--  Port ( );
end tb_controlled_box;

architecture Behavioral of tb_controlled_box is


component controlled_box
port(
		clk : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		scan_line_x: in STD_LOGIC_VECTOR(10 downto 0);
		scan_line_y: in STD_LOGIC_VECTOR(10 downto 0);
		kHz: in STD_LOGIC;
		red: out STD_LOGIC_VECTOR(3 downto 0);
		blue: out STD_LOGIC_VECTOR(3 downto 0);
		green: out STD_LOGIC_VECTOR(3 downto 0);
		move_left: in STD_LOGIC;
		move_right: in STD_LOGIC;
		move_up: in STD_LOGIC;
		move_down: in STD_LOGIC;
		current_x: out STD_LOGIC_VECTOR(9 downto 0);
		current_y: out STD_LOGIC_VECTOR(9 downto 0)
);
end component;

signal clk: std_logic;
signal reset: std_logic;
signal scan_line_x:STD_LOGIC_VECTOR(10 downto 0);
signal scan_line_y: STD_LOGIC_VECTOR(10 downto 0);
signal kHz: std_logic;
signal red: STD_LOGIC_VECTOR(3 downto 0);
signal blue: STD_LOGIC_VECTOR(3 downto 0);
signal green: STD_LOGIC_VECTOR(3 downto 0);
signal move_left: STD_LOGIC;
signal move_right: STD_LOGIC;
signal move_up: STD_LOGIC;
signal move_down: STD_LOGIC;
signal current_x: STD_LOGIC_VECTOR(9 downto 0);
signal current_y: STD_LOGIC_VECTOR(9 downto 0);

constant clk_period: time:= 10 ns;

begin
	uut: controlled_box port map(
	   --box_start_loc_x => start_loc,
		clk => clk,
		reset => reset,
		scan_line_x => scan_line_x,
		scan_line_y => scan_line_y,
		kHz => kHz,
		red => red,
		blue => blue,
		green => green,
		move_left => move_left,
		move_right => move_right,
		move_up => move_up,
		move_down => move_down,
		current_x => current_x,
		current_y => current_y
	);
	
	clk_process:process
		begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
	kHz_process: process
		begin
		kHz <= '0';
		wait for clk_period*10;
		kHz <= '1';
		wait for clk_period*10;
	end process;
	
	user_input_process: process
		begin
		move_left <= '0';
		move_right <= '0';
		move_up <= '1';
		move_down <= '0';
		wait for 100 us;
		move_up <= '0';
		wait for 1 us;
		move_down <= '1';
		wait for 100 us;
		move_down <= '0';
		wait for 1 us;
		wait;
	end process;
	
	stim_proc:process
        begin
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait;
	end process;

end Behavioral;
