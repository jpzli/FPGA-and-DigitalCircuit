library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controlled_box is
	GENERIC(
		box_width: STD_LOGIC_VECTOR(5 downto 0) := "001000";
		box_height: STD_LOGIC_VECTOR(5 downto 0) := "010000";
		box_color: STD_LOGIC_VECTOR(11 downto 0) := "101010101010";
--		box_start_loc_x: STD_LOGIC_VECTOR(9 downto 0) :="0010111001"
		box_start_loc_x: STD_LOGIC_VECTOR(9 downto 0) :="0011111000"
	);
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
end controlled_box;

architecture Behavioral of controlled_box is
	signal redraw: STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
	
	-- X-axis values:
	constant box_loc_x_min: std_logic_vector(9 downto 0) := "0000000000";
	signal box_loc_x_max: std_logic_vector(9 downto 0);
	
	-- Y-axis values:
	constant box_loc_y_min: std_logic_vector(9 downto 0) := "0000000000";
	signal box_loc_y_max: std_logic_vector(9 downto 0);
	
	-- Color of this box:
	signal pixel_color: std_logic_vector(11 downto 0);
	
	-- Location of the box:
	signal box_loc_x, box_loc_y: std_logic_vector(9 downto 0);

begin

MoveBox: process(clk, reset)
begin
    if (reset = '1') then
        box_loc_x <= box_start_loc_x; -- Starting location for X
        box_loc_y <= "0001100010"; -- Starting location for Y
        redraw <= (others=>'0');
	elsif (rising_edge(clk)) then
		if (kHz = '1') then
            redraw <= redraw + 1;
            if (redraw = "000100") then
                redraw <= (others => '0');
                if (move_left = '1') then
					if(box_loc_x > box_loc_x_min) then
						box_loc_x <= box_loc_x - 1;
					else
						box_loc_x <= box_loc_x; --Simply means the box has reached the extreme left and will stay at the same location regardless of input
					end if;
				end if;
				
				if (move_right = '1') then
					if(box_loc_x < box_loc_x_max) then
						box_loc_x <= box_loc_x + 1;
					else
						box_loc_x <= box_loc_x;
					end if;
				end if;
				
				if (move_up = '1') then
					if(box_loc_y > box_loc_y_min) then
						box_loc_y <= box_loc_y - 1;
					else
						box_loc_y <= box_loc_y;
					end if;
				end if;
				
				if (move_down = '1') then
					if(box_loc_y < box_loc_y_max) then
						box_loc_y <= box_loc_y + 1;
					else
						box_loc_y <= box_loc_y;
					end if;
				end if;
				
                -- (PART A)
                -- Write the controls needed to move the box left and right:
                -- Write the controls needed to move the box up and down:
                -- Details for this are given on Page 4 of the Pre-lab instructions.
                
            end if;
		end if;
	end if;
end process MoveBox;

-- (PART B)
-- Correct this as described on Page 4 of the Pre-lab Instructions:
pixel_color <= box_color when (	(scan_line_x >= box_loc_x) and
								(scan_line_y >= box_loc_y) and
								(scan_line_x < box_loc_x + box_width) and
								(scan_line_y < box_loc_y + box_height)) else
				  "111111111111";
				  
red 	<= pixel_color(11 downto 8);
green 	<= pixel_color(7 downto 4);
blue 	<= pixel_color(3 downto 0);

box_loc_x_max 	<= "1010000000" - box_width;
box_loc_y_max 	<= "0111100000" - box_height;
-- (PART C)
-- Write the code for box_loc_y_max here


-- We are copying the current X and Y locations here:
current_x <= box_loc_x;
current_y <= box_loc_y;

end Behavioral;

