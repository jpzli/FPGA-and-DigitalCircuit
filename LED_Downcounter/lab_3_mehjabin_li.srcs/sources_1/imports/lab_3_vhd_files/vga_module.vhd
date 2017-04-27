library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_module is
    Port (  clk : in  STD_LOGIC;
            buttons: in STD_LOGIC_VECTOR(2 downto 0);
            switches: in STD_LOGIC_VECTOR(13 downto 0);
            red: out STD_LOGIC_VECTOR(3 downto 0);
            green: out STD_LOGIC_VECTOR(3 downto 0);
            blue: out STD_LOGIC_VECTOR(3 downto 0);
            hsync: out STD_LOGIC;
            vsync: out STD_LOGIC
	 );
end vga_module;

architecture Behavioral of vga_module is
-- Components:
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
Component clock_divider 
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
               -- Add output buses (STD_LOGIC_VECTOR(x downto y))
               -- here to hold values of single seconds, tens of seconds,
               -- minutes, and tens of minutes. Consult Lab 1 intructions
               -- if you are not sure of syntax.      
                  );
    end Component;


component up_down_counter is
	Generic ( WIDTH: integer:= 6);
	Port (
		up: in STD_LOGIC;
		down: in STD_LOGIC;
        clk: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
        val: out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
	);
end component;
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
component vga_stripes_dff is
    Port ( pixel_clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           next_pixel : in  STD_LOGIC;
		   mode: in STD_LOGIC;
           B : out  STD_LOGIC_VECTOR (3 downto 0);
           G : out  STD_LOGIC_VECTOR (3 downto 0);
           R : out  STD_LOGIC_VECTOR (3 downto 0)
		   );
end component;




-- Signals:
signal reset: std_logic;
signal vga_select: std_logic;

signal disp_blue: std_logic_vector(3 downto 0);
signal disp_red: std_logic_vector(3 downto 0);
signal disp_green: std_logic_vector(3 downto 0);

-- Stripe block signals:
signal show_stripe: std_logic;

signal stripe_blue:std_logic_vector(3 downto 0);
signal stripe_red:std_logic_vector(3 downto 0);
signal stripe_green:std_logic_vector(3 downto 0);


signal i_kHz, i_hHz, i_pixel_clk: std_logic;


-- Sync module signals:
signal vga_blank : std_logic;
signal scan_line_x, scan_line_y: STD_LOGIC_VECTOR(10 downto 0);

-- Box size signals:
signal inc_box, dec_box: std_logic;
signal box_size: std_logic_vector(8 downto 0);

-- Bouncing box signals:
signal box_color: std_logic_vector(11 downto 0);
signal box_red: std_logic_vector(3 downto 0);
signal box_green: std_logic_vector(3 downto 0);
signal box_blue: std_logic_vector(3 downto 0);


begin


VGA_SYNC: sync_signals_generator
    Port map( 	pixel_clk   => i_pixel_clk,
                reset       => reset,
                hor_sync    => hsync,
                ver_sync    => vsync,
                blank       => vga_blank,
                scan_line_x => scan_line_x,
                scan_line_y => scan_line_y
			  );

CHANGE_BOX_SIZE: up_down_counter
	Generic map( 	WIDTH => 9)
	Port map(
					up 	   => inc_box,
					down   => dec_box,
					clk	   => clk,
					reset  => reset,
					enable => i_kHz,
                    val    => box_size
	);
	
Divider: clock_divider
port map(
                clk =>clk,
               reset =>reset,
               enable => '1',
                  kHz=> i_kHz,
				  tfmegHz => i_pixel_clk,
				  hundredHz => i_hHz,
                  min_dig_2 => open, 
                  min_dig_1 => open,
                  sec_dig_2 => open,
                  sec_dig_1 => open
            );
            
Stripes: vga_stripes_dff
port map(
        pixel_clk => i_pixel_clk,
           reset => reset,
           next_pixel => not vga_blank,
		   mode => switches(12), 
           B => stripe_blue,
           G => stripe_green,
           R => stripe_red
           );
           
bounce:  bouncing_box  
port map(
     clk =>clk,
		reset =>reset,
		scan_line_X => scan_line_x,
        scan_line_Y => scan_line_y,
        kHz => i_kHz,
        red => box_red,
        blue => box_blue,
        green => box_green,
        box_color => box_color, --Can be wired to switches directly
        box_width => box_size
         );
show_stripe <= not vga_blank;

-- BLANKING:
-- Follow this syntax to assign other colors when they are not being blanked
red <= "0000" when (vga_blank = '1') else disp_red;
blue <= "0000" when (vga_blank = '1') else disp_blue;
green <= "0000" when (vga_blank = '1') else disp_green;




-- Connect input buttons and switches:
reset <= buttons(0);
box_color <= switches(11 downto 0);
vga_select <= switches(13);
inc_box <=buttons(1);
dec_box <=buttons(2) ;


-----------------------------------------------------------------------------
-- OUTPUT SELECTOR:
-- Select which component to display - stripes or bouncing box
selectOutput: process(vga_select, box_red, box_blue, box_green, stripe_blue, stripe_red, stripe_green)
begin
	case (vga_select) is
		-- Select which input gets written to disp_red, disp_blue and disp_green
		when '1' => disp_red <= box_red; disp_blue <= box_blue; disp_green <= box_green;
        when '0' => disp_red <= stripe_red; disp_blue <= stripe_blue; disp_green <= stripe_green;
		when others => disp_red <= "0000"; disp_blue <= "0000"; disp_green <= "0000";
	end case;
end process selectOutput;
-----------------------------------------------------------------------------
end Behavioral;

