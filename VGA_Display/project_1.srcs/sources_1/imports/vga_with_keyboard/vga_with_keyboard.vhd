library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity vga_with_keyboard is
    Port ( BTN0 : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           ps2_clk : in  STD_LOGIC;
           ps2_data : in  STD_LOGIC;
           blue : out  STD_LOGIC_VECTOR (3 downto 0);
           green : out  STD_LOGIC_VECTOR (3 downto 0);
           red : out  STD_LOGIC_VECTOR (3 downto 0);
           LEDs : out  STD_LOGIC_VECTOR (7 downto 0);
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC);
end vga_with_keyboard;

architecture Behavioral of vga_with_keyboard is

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
	
component controlled_box is

    PORT (
        clk: in STD_LOGIC;
        reset: in STD_LOGIC;
        scan_line_x: in STD_LOGIC_VECTOR(10 downto 0);
        scan_line_y: in STD_LOGIC_VECTOR(10 downto 0);
        kHz: in STD_LOGIC;
        red: out STD_LOGIC_VECTOR(3 downto 0);
        blue: out STD_LOGIC_VECTOR(3 downto 0);
        green: out STD_LOGIC_VECTOR(3 downto 0);
        move_right: in STD_LOGIC;
        move_left: in STD_LOGIC;
        move_up: in STD_LOGIC;
        move_down: in STD_LOGIC;
        current_x: out std_logic_vector(9 downto 0);
        current_y: out std_logic_vector(9 downto 0)
    );
end component;

component decoded_keyboard is
	PORT (
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    ps2_clk: in STD_LOGIC;
    ps2_data: in STD_LOGIC;
    new_value_received: out STD_LOGIC;
    value: out STD_LOGIC_VECTOR(6 downto 0);
    shift: out STD_LOGIC;
    ctrl: out STD_LOGIC
    );
end component;

-- Signals
signal reset: std_logic;

-- sync_signals_generator signals
signal vga_blank : std_logic;
signal i_scan_line_x, i_scan_line_y: STD_LOGIC_VECTOR(10 downto 0);

--clock_divider signals
signal i_kHz: std_logic;
signal i_25Mhz: std_logic;

--controlled_box signals
signal i_currentX, i_currentY: std_logic_vector(9 downto 0);

signal move_box_right, move_box_left, move_box_up, move_box_down: std_logic;
signal box_red: std_logic_vector(3 downto 0);
signal box_green: std_logic_vector(3 downto 0);
signal box_blue: std_logic_vector(3 downto 0);

-- decoded_keyboard signals
signal i_new_value, i_shift, i_ctrl: std_logic;
signal i_value: std_logic_vector(6 downto 0);

	begin
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

	CONSTANT_BOX_SIZE: controlled_box
	Port map(	clk => clk,
			reset => reset,
			scan_line_x => i_scan_line_x,
			scan_line_y => i_scan_line_y,
			kHz => i_kHz,
			red => box_red,
			blue => box_blue,
			green => box_green,
			move_right => move_box_right,
			move_left => move_box_left,
			move_up => move_box_up,
			move_down => move_box_down,
			current_x => open,	-- not used in lab 4
			current_y =>  i_currentY	-- not used in lab 4
	);
	
	KEYBOARD_PS2: decoded_keyboard
	Port map(	clk => clk,	
			ps2_clk => ps2_clk,
			ps2_data => ps2_data,
			reset => reset,
			new_value_received => open,
			value => i_value,
			shift => i_shift,
			ctrl => i_ctrl
	);
	

-- Assignment of reset to a button:
reset <= BTN0;

-- BLANKING:
red <= "0000" when(vga_blank = '1') 
    else box_red;
green <= "0000" when (vga_blank = '1') 
    else box_green;
blue <= "0000" when (vga_blank = '1') 
    else box_blue;

-- Assignments of Moving Signals: 
-- Keyboard Code Decode Logic:
--move_up LUT value:0x1D;	--ASCII code:0x77
move_box_up <= '1' when (i_value = "1110111")	
	else '0';
--move_left LUT value:0x1C; --ASCII code:0x61
move_box_left <= '1' when (i_value = "1100001")
	else '0';
--move_down LUT value:0x1B; --ASCII code:0x73
move_box_down <= '1' when (i_value = "1110011")
	else '0';  
--move_right LUT value:0x23; --ASCII code:0x64
move_box_right <= '1' when (i_value = "1100100")
    else '0';

-- LED assignment:
LEDs(6 downto 0) <= i_value;
LEDs(7) <= i_shift or i_ctrl;

end Behavioral;

