library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_vga_stripes_dff is
--  Port ( );
end tb_vga_stripes_dff;

architecture Behavioral of tb_vga_stripes_dff is
component vga_stripes_dff is
    Port ( pixel_clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
            mode: in STD_LOGIC;
           next_pixel : in  STD_LOGIC;  
           B : out  STD_LOGIC_VECTOR (3 downto 0);
           G : out  STD_LOGIC_VECTOR (3 downto 0);
           R : out  STD_LOGIC_VECTOR (3 downto 0)
		   );
end component;

	signal pixel_clk: std_logic;
	signal reset: std_logic;
	signal next_pixel: std_logic;
	signal mode: std_logic;
	signal B: std_logic_vector (3 downto 0);
	signal G: std_logic_vector (3 downto 0);
	signal R: std_logic_vector (3 downto 0);
	
	   constant clk_period : time := 10 ns;

	begin
		uut: vga_stripes_dff port map(
			pixel_clk => pixel_clk,
			reset => reset,
			mode => mode,
			next_pixel => next_pixel,
			B => B,
			G => G,
			R => R
		);
	
	clk_process:process
	begin
	pixel_clk <= '0';
	wait for clk_period/2;
	pixel_clk <= '1';
	wait for clk_period/2;
	end process;
	
	pixel: process
	begin
	next_pixel <= '1';	
    mode <= '1';
    wait for 1000 ns;
    mode <= '0';
    wait for 1000 ns;
	next_pixel <= '0';
	wait for 1000 ns;
	end process;
		
		
	stim_proc: process
	begin
	reset <= '1';
	wait for 100 ns;	
	reset <= '0';
	wait;
	end process;

end Behavioral;

 

