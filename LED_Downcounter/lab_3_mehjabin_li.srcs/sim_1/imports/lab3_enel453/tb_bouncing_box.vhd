library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_bouncing_box is
--  Port ( );
end tb_bouncing_box;

architecture Behavioral of tb_bouncing_box is

component bouncing_box
port(
		clk : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		scan_line_x: in STD_LOGIC_VECTOR(10 downto 0);
		scan_line_y: in STD_LOGIC_VECTOR(10 downto 0);
		box_color: in STD_LOGIC_VECTOR(11 downto 0);
		box_width: in STD_LOGIC_VECTOR(8 downto 0);
		kHz: in STD_LOGIC;
		red: out STD_LOGIC_VECTOR(3 downto 0);
		blue: out STD_LOGIC_VECTOR(3 downto 0);
		green: out std_logic_vector(3 downto 0)
);
end component;

signal clk: std_logic;
signal reset: std_logic;
signal scan_line_x:STD_LOGIC_VECTOR(10 downto 0);
signal scan_line_y: STD_LOGIC_VECTOR(10 downto 0);
signal box_color: STD_LOGIC_VECTOR(11 downto 0);
signal box_width:  STD_LOGIC_VECTOR(8 downto 0);
signal kHz: std_logic;
signal red: STD_LOGIC_VECTOR(3 downto 0);
signal blue: STD_LOGIC_VECTOR(3 downto 0);
signal green: STD_LOGIC_VECTOR(3 downto 0);

constant clk_period: time:= 10 ns;

begin
	uut: bouncing_box port map(
		clk => clk,
		reset => reset,
		scan_line_x => scan_line_x,
		scan_line_y => scan_line_y,
		box_color => box_color,
		box_width => box_width,
		kHz => kHz,
		red => red,
		blue => blue,
		green => green
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
	
	box_width_process: process
		begin
		box_width <= "000000001";
		wait for clk_period*100;
		box_width <= "000000010";
		wait for clk_period*100;
		box_width <= "000000100";
		wait for clk_period*100;
		box_width <= "000001000";
		wait for clk_period*100;
	end process;
	
	stim_proc:process
        begin
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait;
	end process;

end Behavioral;
