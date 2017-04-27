library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_sync_signal_generator is
--  Port ( );
end tb_sync_signal_generator;

architecture Behavioral of tb_sync_signal_generator is

component sync_signals_generator
port(pixel_clk:in std_logic;
    reset: in std_logic;
    hor_sync: out std_logic;
    ver_sync: out std_logic;
    blank: out std_logic;
    scan_line_x: out std_logic_vector(10 downto 0);
    scan_line_y: out std_logic_vector(10 downto 0)
    );
end component;

signal pixel_clk: std_logic;
signal reset: std_logic;
signal hor_sync: std_logic;
signal ver_sync: std_logic;
signal blank: std_logic;
signal scan_line_x: std_logic_vector(10 downto 0);
signal scan_line_y: std_logic_vector(10 downto 0);

constant clk_period : time := 10 ns;
 
begin

    uut: sync_signals_generator port map(
        pixel_clk => pixel_clk,
        reset => reset,
        hor_sync => hor_sync,
        ver_sync => ver_sync,
        blank => blank,
        scan_line_x => scan_line_x,
        scan_line_y => scan_line_y
        );
        
        clk_process:process
        begin
        pixel_clk <= '0';
        wait for clk_period/2;
        pixel_clk <= '1';
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
