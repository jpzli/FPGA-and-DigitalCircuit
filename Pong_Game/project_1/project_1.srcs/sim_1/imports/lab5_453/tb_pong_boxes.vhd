library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_pong_boxes is
--  Port ( );
end tb_pong_boxes;

architecture Behavioral of tb_pong_boxes is


component pong_boxes
	PORT(
		clk: in std_logic;
		reset: in std_logic;
		player1_up: in std_logic;
		player1_down: in std_logic;
		player2_up: in std_logic;
		player2_down: in std_logic;
		player1_scored: out std_logic;
		player2_scored: out std_logic;
		red: out std_logic_vector(3 downto 0);
		green: out std_logic_vector(3 downto 0);
		blue: out std_logic_vector(3 downto 0);
		kHz: in std_logic;
		scan_line_x: in std_logic_vector(10 downto 0);
		scan_line_y: in std_logic_vector(10 downto 0)
	);
end component;

signal clk: std_logic;
signal reset: std_logic;
signal player1_up: std_logic;
signal player1_down: std_logic;
signal player2_up: std_logic;
signal player2_down: std_logic;
signal player1_scored: std_logic;
signal player2_scored: std_logic;
signal red: STD_LOGIC_VECTOR(3 downto 0);
signal blue: STD_LOGIC_VECTOR(3 downto 0);
signal green: STD_LOGIC_VECTOR(3 downto 0);
signal kHz: std_logic;
signal scan_line_x: STD_LOGIC_VECTOR(10 downto 0) ;
signal scan_line_y: STD_LOGIC_VECTOR(10 downto 0) ;


constant clk_period: time:= 10 ns;

begin
	uut: pong_boxes port map(
	   --box_start_loc_x => start_loc,
		clk => clk,
		reset => reset,
		player1_up => player1_up,
		player1_down => player1_down,
		player2_up => player2_up,
		player2_down => player2_down,
		player1_scored => player1_scored,
		player2_scored => player2_scored,
		red => red,
		blue => blue,
		green => green,
		kHz => kHz,
		scan_line_x => scan_line_x,
		scan_line_y => scan_line_y
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
		kHz <= '1';
		wait for clk_period*10;
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
