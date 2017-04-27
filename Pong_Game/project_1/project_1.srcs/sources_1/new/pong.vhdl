----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2016 08:22:47 PM
-- Design Name: 
-- Module Name: pong - Behavioral
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

entity pong is
    Port ( blue : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           red : out STD_LOGIC_VECTOR (3 downto 0);
           AN1 : out STD_LOGIC;
           AN2 : out STD_LOGIC;
           AN3 : out STD_LOGIC;
           AN4 : out STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           BTN0 : in STD_LOGIC;
           clk : in STD_LOGIC;
           ps2_clk : in STD_LOGIC;
           ps2_data : in STD_LOGIC);
end pong;

architecture Behavioral of pong is
component vga_character_line is
	PORT(
		clk: in std_logic;
		reset: in std_logic;
		accept_new_char: in std_logic;
		new_char_value: in std_logic_vector(6 downto 0);
		scan_line_x: in std_logic_vector(10 downto 0);
		scan_line_y: in std_logic_vector(10 downto 0);
		character_pixel: out std_logic
	);
end component;

component pong_boxes is
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

component clock_divider is
	Port ( clk : in  STD_LOGIC;
               reset : in  STD_LOGIC;
               enable: in STD_LOGIC;
                  kHz: out STD_LOGIC;
                  tfmegHz : out STD_LOGIC;
                  hundredHz: out STD_LOGIC;
                  min_dig_2: out STD_LOGIC_VECTOR (3 downto 0); 
                  min_dig_1: out STD_LOGIC_VECTOR (3 downto 0);
                  sec_dig_2: out STD_LOGIC_VECTOR (3 downto 0);
                  sec_dig_1: out STD_LOGIC_VECTOR (3 downto 0)
                  );
	end component;

component sync_signals_generator is
    Port ( pixel_clk : in  STD_LOGIC;
       reset : in  STD_LOGIC;
       hor_sync: out STD_LOGIC;
       ver_sync: out STD_LOGIC;
       blank: out STD_LOGIC;
       scan_line_x: out STD_LOGIC_VECTOR(10 downto 0);
       scan_line_y: out STD_LOGIC_VECTOR(10 downto 0)
      );
	end component;

component decoded_keyboard is
	PORT (
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		ps2_clk: in STD_LOGIC;
		ps2_data: in STD_LOGIC;
		key_make: out STD_LOGIC;
		key_pressed: out STD_LOGIC_VECTOR(6 downto 0);
		key_released: out STD_LOGIC_VECTOR(6 downto 0);
		shift: out STD_LOGIC;
		ctrl: out STD_LOGIC;
		key_break: out STD_LOGIC;
		caps_lock: out STD_LOGIC
	);
end component;	

component sevensegment_selector is
    Port ( clk : in  STD_LOGIC;
           switch : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (3 downto 0);
           reset : in  STD_LOGIC);
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

component score_keeper is
	PORT(
		clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		single_digit: out std_logic_vector(3 downto 0);
		tens_digit: out STD_LOGIC_VECTOR(3 downto 0)
	);
end component;

begin
line_display: vga_character_line
	PORT MAP(
    clk => clk,
    reset => reset,
    accept_new_char => accept_new_char,
    new_char_value => new_char,
    scan_line_x => i_scan_line_x,
    scan_line_y => i_scan_line_y,
    character_pixel => char_pixel
);

paddle_boxes: pong_boxes
	PORT MAP(
		clk => clk,
		reset => reset,
		player1_up => p1_up,
		player1_down => p1_down,
		player2_up => p2_up,
		player2_down => p2_down,
		player1_scored => p1_scored,
		player2_scored => p2_scored,
		red => box_red, 
		green => box_green,
		blue => box_blue,
		kHz => i_kHz,
		scan_line_x => i_scan_line_x,
		scan_line_y => i_scan_line_y
	);

CLOCK: clock_divider
	Port map(
			clk => clk,
			enable => '1',
			reset => reset,
			hundredHz => open,
			kHz => i_kHz,
			tfmegHz => i_25Mhz,
			min_dig_2 => open,
            min_dig_1 => open,
            sec_dig_2 => open,
            sec_dig_1 => open         
	);

VGA_SYNC: sync_signals_generator
	Port map( 	
			pixel_clk => i_25Mhz,
			reset => reset,
			hor_sync => HSYNC,
			ver_sync => VSYNC,
			blank => vga_blank,
			scan_line_x => i_scan_line_x,
			scan_line_y => i_scan_line_y
	);

component decoded_keyboard is
	PORT  MAP(
		clk  => clk,
		reset => reset,
		ps2_clk => ps2_clk,
		ps2_data => ps2_data,
		key_make: out STD_LOGIC;
		key_pressed: out STD_LOGIC_VECTOR(6 downto 0);
		key_released: out STD_LOGIC_VECTOR(6 downto 0);
		shift: out STD_LOGIC;
		ctrl: out STD_LOGIC;
		key_break: out STD_LOGIC;
		caps_lock: out STD_LOGIC
	);

end Behavioral;
