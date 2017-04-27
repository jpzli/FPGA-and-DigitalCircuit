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
USE ieee.numeric_std.ALL;

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
           LEDs: out STD_LOGIC_VECTOR(7 downto 0);
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

--Common signal for all
signal disp_red: std_logic_vector(3 downto 0);
signal disp_green: std_logic_vector(3 downto 0);
signal disp_blue: std_logic_vector(3 downto 0);

--Clock Divider Signals
signal i_kHz: std_logic;
signal i_25Mhz: std_logic;

--Sync Generator Signals
signal vga_blank: std_logic;
signal i_scan_line_x, i_scan_line_y: std_logic_vector(10 downto 0);

--Decoded Keyboard Signals
signal i_key_make: std_logic;
signal i_key_pressed: STD_LOGIC_VECTOR(6 downto 0);
signal i_key_released: STD_LOGIC_VECTOR(6 downto 0);
signal i_key_break: STD_LOGIC;
signal i_caps_lock: STD_LOGIC;

--vga_character_line signals
signal char_pixel: std_logic;

--pong boxes signals
signal p1_up: std_logic;
signal p1_down: std_logic;
signal p2_up: std_logic;
signal p2_down: std_logic;
signal p1_scored: std_logic;
signal p2_scored: std_logic;
signal box_red: std_logic_vector(3 downto 0);
signal box_green: std_logic_vector(3 downto 0);
signal box_blue: std_logic_vector(3 downto 0);

--sevensegment_selector signal
signal i_an: std_logic_vector(3 downto 0);

--sevensegment signal
signal i_data: std_logic_vector(3 downto 0);

--score keeper signals
signal i1_single_digit: std_logic_vector(3 downto 0);
signal i1_tens_digit: std_logic_vector(3 downto 0);
signal i2_single_digit: std_logic_vector(3 downto 0);
signal i2_tens_digit: std_logic_vector(3 downto 0);

begin
line_display: vga_character_line
	PORT MAP(
    clk => clk,
    reset => BTN0,
    accept_new_char => i_caps_lock and i_key_make,
    new_char_value => i_key_pressed,
    scan_line_x => i_scan_line_x,
    scan_line_y => i_scan_line_y,
    character_pixel => char_pixel
);

paddle_boxes: pong_boxes
	PORT MAP(
		clk => clk,
		reset => BTN0,
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
			reset => BTN0,
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
			reset => BTN0,
			hor_sync => hsync,
			ver_sync => vsync,
			blank => vga_blank,
			scan_line_x => i_scan_line_x,
			scan_line_y => i_scan_line_y
	);

decode_keyboard: decoded_keyboard
	PORT  MAP(
		clk  => clk,
		reset => BTN0,
		ps2_clk => ps2_clk,
		ps2_data => ps2_data,
		key_make => i_key_make,
		key_pressed => i_key_pressed,
		key_released => i_key_released,
		shift => open,
		ctrl => open,
		key_break => i_key_break,
		caps_lock => i_caps_lock
	);

sev_selector: sevensegment_selector
    Port MAP( clk => clk,
           switch => i_kHz,
           output => i_an,
           reset => BTN0
	);	
	
sev_segment: sevensegment
    Port MAP( CA => CA,
           CB => CB,
           CC => CC,
           CD => CD,
           CE => CE,
           CF => CF,
           CG => CG,
           DP => DP,
		   dp_in => i_an(2),
           data => i_data
	);
	
p1_score_keep: score_keeper
	PORT MAP(
		clk => clk,
		reset => BTN0,
		enable => (p1_scored and (not i_caps_lock)),
		single_digit => i1_single_digit,
		tens_digit => i1_tens_digit
	);
	
p2_score_keep: score_keeper
	PORT MAP(
		clk => clk,
		reset => BTN0,
		enable => (p2_scored and (not i_caps_lock)),
		single_digit => i2_single_digit,
		tens_digit => i2_tens_digit
	);	

--Score display mux
score_display_mux: process(i_an, i2_single_digit, i2_tens_digit, i1_single_digit, i1_tens_digit )
begin
    case(i_an)is
        when "0001" => i_data <= i1_single_digit;
        when "0010" => i_data <= i1_tens_digit;
        when "0100" => i_data <= i2_single_digit;
        when "1000" => i_data <= i2_tens_digit;
        when others => i_data <= "0000";
    end case;
end process;	
	
--Connecting the LEDs
LEDs(6 downto 0) <= i_key_pressed;
LEDs(7) <= i_caps_lock;

--Seven_segment output to Anodes
AN1 <= not i_an(0);
AN2 <= not i_an(1);
AN3 <= not i_an(2);
AN4 <= not i_an(3);

--pixel select
pixel_select_mux: process(char_pixel, box_blue, box_green, box_red)
	begin
		case(char_pixel) is
			when '0' => disp_red <= box_red; disp_green <= box_green; disp_blue <= box_blue;
			when '1' => disp_red <= "0000"; disp_green <= "1111"; disp_blue <= "1111";
			when others => disp_red <= "0000"; disp_green <= "0000"; disp_blue <= "0000";
		end case;
end process;

-- BLANKING:
red <= "0000" when(vga_blank = '1') 
    else disp_red;
green <= "0000" when (vga_blank = '1') 
    else disp_green;
blue <= "0000" when (vga_blank = '1') 
    else disp_blue;
			
--Keyboard keys assignment
process(clk, BTN0)	begin
	if(BTN0 = '1')then
		p1_down <= '0';
		p1_up <= '0';
		p2_down <= '0';
		p2_up <= '0';
		
	elsif(rising_edge(clk))then
		--player 1 move_down LUT value:0x1B; --ASCII code:0x73
		if((i_key_pressed = "1110011") and (i_key_make = '1') and (i_caps_lock = '0'))then
			p1_down <= '1';
		elsif((i_key_released = "1110011") and (i_key_break = '1'))then
			p1_down <= '0';
		else
			--Doing nothing represented by self-assignment
			p1_down <= p1_down;
		end if;

		--player 1 move_up LUT value:0x1D;	--ASCII code:0x77
		if((i_key_pressed = "1110111") and (i_key_make = '1') and (i_caps_lock = '0'))then
			p1_up <= '1';
		elsif((i_key_released = "1110111") and (i_key_break = '1'))then
			p1_up <= '0';
		else
			--Doing nothing represented by self-assignment
			p1_up <= p1_up;
		end if;
		
		--player 2 move down LUT value: 0x42; --ASCII code: 0x6B
		if((i_key_pressed = "1101011") and (i_key_make = '1') and (i_caps_lock = '0'))then
			p2_down <= '1';
		elsif((i_key_released = "1101011") and (i_key_break = '1'))then
			p2_down <= '0';
		else
			--Doing nothing represented by self-assignment
			p2_down <= p2_down;
		end if;
			
		--player 2 move up LUT value: 0x43; --ASCII code: 0x69
		if((i_key_pressed = "1101001") and (i_key_make = '1') and (i_caps_lock = '0'))then
			p2_up <= '1';
		elsif((i_key_released = "1101001") and (i_key_break = '1'))then
			p2_up <= '0';
		else
			--Doing nothing represented by self-assignment
			p2_up <= p2_up;
		end if;
	end if;
end process;

end Behavioral;
