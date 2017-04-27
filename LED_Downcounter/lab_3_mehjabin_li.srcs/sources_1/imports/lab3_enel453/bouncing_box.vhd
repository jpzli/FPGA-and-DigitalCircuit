library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bouncing_box is
    Port ( 	clk : in  STD_LOGIC;
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
end bouncing_box;

architecture Behavioral of bouncing_box is

signal redraw: std_logic_vector(5 downto 0):=(others=>'0');
constant box_loc_x_min: std_logic_vector(9 downto 0) := "0000000000";
constant box_loc_y_min: std_logic_vector(9 downto 0) := "0000000000";
signal box_loc_x_max: std_logic_vector(9 downto 0); -- Not constants because these dependant on box_width 
signal box_loc_y_max: std_logic_vector(9 downto 0);
signal pixel_color: std_logic_vector(11 downto 0);
signal box_loc_x, box_loc_y: std_logic_vector(9 downto 0);
signal box_move_dir_x, box_move_dir_y: std_logic;

begin

MoveBox: process(clk, reset)
begin	
    if (reset ='1') then
        box_loc_x <= "0111000101";
        box_loc_y <= "0001100010";
        box_move_dir_x <= '0';
        box_move_dir_y <= '0';
        redraw <= (others=>'0');
	elsif (rising_edge(clk)) then
        if (kHz = '1') then
            redraw <= redraw + 1;
            if (redraw = "10000") then 		-- Determines the box's speed
                redraw <= (others => '0');
                if box_move_dir_x <= '0' then   -- Box moving right
                    if (box_loc_x < box_loc_x_max) then -- Has not hit right wall
                        box_loc_x <= box_loc_x + 1;
                    else 
                        box_move_dir_x <= '1';	-- Box is now moving left
                    end if;
                else
                    if (box_loc_x > box_loc_x_min) then
                        box_loc_x <= box_loc_x - 1; -- Has not hit left wall
                    else 
                        box_move_dir_x <= '0';	-- Box is now moving right
                    end if;
                end if;
			
			if box_move_dir_y <= '0' then   -- Box moving right
				if (box_loc_y < box_loc_y_max) then -- Has not hit right wall
					box_loc_y <= box_loc_y + 1;
				else 
					box_move_dir_y <= '1';	-- Box is now moving left
				end if;
			else
				if (box_loc_y > box_loc_y_min) then
					box_loc_y <= box_loc_y - 1; -- Has not hit left wall
				else 
					box_move_dir_y <= '0';	-- Box is now moving right
				end if;
			end if;
			end if;
                
                -- Complete the Y-axis motion description here
                -- It is very similar to X-axis motion
        end if;
	end if;
end process MoveBox;

pixel_color <= box_color when     ((scan_line_x >= box_loc_x) and 
								(scan_line_y >= box_loc_y) and 
								(scan_line_x < box_loc_x+box_width) and 
								(scan_line_y < box_loc_y+box_width)) 
					   else
				                "111111111111"; -- represents WHITE
								
red   <= pixel_color(11 downto 8);
green <= pixel_color(7 downto 4);
blue  <= pixel_color(3 downto 0);

box_loc_x_max <= "1010000000" - box_width - 1;
box_loc_y_max <= "0111100000" - box_width - 1;
-- Describe the value for box_loc_y_max here:
-- Hint: In binary, 640 is 1010000000 and 480 is 0111100000


end Behavioral;

