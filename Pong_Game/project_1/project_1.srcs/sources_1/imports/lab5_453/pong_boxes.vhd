library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pong_boxes is
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
end pong_boxes;

architecture Behavioral of pong_boxes is

-- PART A: Add your controlled_box component declaration here.
component controlled_box is
    GENERIC(
            box_width: STD_LOGIC_VECTOR(5 downto 0) := "001000";
            box_height: STD_LOGIC_VECTOR(5 downto 0) := "010000";
            box_color: STD_LOGIC_VECTOR(11 downto 0) := "101010101010";
            box_start_loc_x: STD_LOGIC_VECTOR(9 downto 0) :="0010111001"
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
    end component;


-- Color and width constants
constant paddle_width: std_logic_vector(5 downto 0) := "001000";
constant paddle_height: std_logic_vector(5 downto 0) := "111100";
constant ball_width: std_logic_vector(5 downto 0) := "001000";
-- Feel free to change these!
constant p1_color: std_logic_vector(11 downto 0) := "111100001111"; -- PINK
constant p2_color: std_logic_vector(11 downto 0) := "000000000000"; -- BLACK
constant ball_color: std_logic_vector(11 downto 0) := "000011110000"; -- GREEN

signal redraw: STD_LOGIC_VECTOR(5 downto 0) := (others => '0');

-- X-axis values:
constant ball_loc_x_min: std_logic_vector(9 downto 0) := "0000000000";
signal ball_loc_x_max: std_logic_vector(9 downto 0) := "1010000000" - ball_width;

-- Y-axis values:
constant ball_loc_y_min: std_logic_vector(9 downto 0) := "0000000000";
signal ball_loc_y_max: std_logic_vector(9 downto 0) := "0111100000" - ball_width;

-- Location of the ball:
signal ball_loc_x, ball_loc_y: std_logic_vector(9 downto 0);
signal ball_dir_x, ball_dir_y: std_logic := '0';

-- Player paddle locations signals
signal p1_x, p1_y: std_logic_vector(9 downto 0); -- player 1 X and Y
signal p2_x, p2_y: std_logic_vector(9 downto 0); -- player 2 X and Y

signal drawball_leftedge, drawball_rightedge: std_logic;
signal draw_p1_rightedge, drawP2_leftedge: std_logic;
signal draw_ball, draw_p1, draw_p2: std_logic;
signal i_player1scored, i_player2scored: std_logic;
signal old_player1scored, old_player2scored: std_logic;

begin
-- PART B: Add component instances here for controlled_box (there will be 2)
player1_movement: controlled_box
generic map(
            box_width => paddle_width,
            box_height => paddle_height,
            box_color => p1_color,
            box_start_loc_x => "0000000000"
)

Port Map(
		clk => clk,
		reset => reset,
		kHz => kHz,
		scan_line_x => scan_line_x,
		scan_line_y => scan_line_y,
		red => open,
		blue => open,
		green => open,
		move_right => '0',
		move_left => '0',
		move_up => player1_up,
		move_down => player1_down,
		current_x => p1_x,
		current_y => p1_y	
);

player2_movement: controlled_box
generic map(
            box_width => paddle_width,
            box_height => paddle_height,
            box_color => p2_color,
            box_start_loc_x => "1010000000" - paddle_width
)

Port Map(
		clk => clk,
		reset => reset,
		kHz => kHz,
		scan_line_x => scan_line_x,
		scan_line_y => scan_line_y,
		red => open,
		blue => open,
		green => open,
		move_right => '0',
		move_left => '0',
		move_up => player2_up,
		move_down => player2_down,
		current_x => p2_x,
		current_y => p2_y	
);

-- Logic!:
Pong: process(clk,reset)
begin
    if (reset = '1') then
        ball_loc_x <= "0011110000"; -- Starting location for X
        ball_loc_y <= "0001100010"; -- Starting location for Y
        ball_dir_x <= '0'; -- Ball starts out moving left
        ball_dir_y <= '0'; -- Ball starts out moving up
        redraw <= (others=>'0');
	elsif (rising_edge(clk)) then 
        -- Use these signals to detect the rising edge of the score signal 
        old_player1scored <= i_player1scored;
        old_player2scored <= i_player2scored;
        
        if (kHz = '1') then
            redraw <= redraw + 1;
            if (redraw = "000100") then -- This controls the speed of the ball moving around
                redraw <= (others => '0');	
                
                if (ball_loc_x = paddle_width-1) then 			-- box at the left paddle's side
                    if ((ball_loc_y + ball_width) < (p1_y)) then 	-- Ball passed above paddle
                        ball_dir_x <= '0'; 			-- continue travel to the left, player 2 scored
                    elsif (ball_loc_y > (p1_y + paddle_height)) then 	-- Ball passed below paddle
                        ball_dir_x <= '0'; 			-- continue travel to the left, player 2 scored
                    else
                        ball_dir_x <= '1'; 			-- reflect from paddle and go right
                    end if;							
                elsif ((ball_loc_x + ball_width) = p2_x) then 		-- box at the right paddle's side
                -- PART C: Write logic to handle collisions with the player 2 paddle:
                    if ((ball_loc_y + ball_width) < (p2_y)) then 	-- Ball passed above paddle
                       ball_dir_x <= '1';             -- continue travel to the left, player 2 scored
                   elsif (ball_loc_y > (p2_y + paddle_height)) then     -- Ball passed below paddle
                       ball_dir_x <= '1';             -- continue travel to the left, player 2 scored
                   else
                       ball_dir_x <= '0';             -- reflect from paddle and go right
                   end if;                            
                end if;

                -- Control the Y-direction motion (does not depend on the players' actions)
                if (ball_dir_y = '0') then
                    if (i_player2scored = '1') then -- Reset ball if player scored
                        ball_loc_y <= ball_loc_y_max - ball_loc_y; 	-- "Random" location for respawn
                        ball_dir_y <= '1'; 
                    else
                        if (ball_loc_y < ball_loc_y_max) then
                            ball_loc_y <= ball_loc_y + 1;
                        else
                            ball_dir_y <= '1';
                        end if;
                    end if;
                else
                    if (i_player1scored = '1') then -- Reset ball if player scored
                        ball_loc_y <= ball_loc_y_max - ball_loc_y; 	-- "Random" location for respawn
                        ball_dir_y <= '0';
                    else
                        if (ball_loc_y > ball_loc_y_min) then
                            ball_loc_y <= ball_loc_y - 1;
                        else
                            ball_dir_y <= '0';
                        end if;
                    end if;
                end if;
                
                if (ball_dir_x = '0') then
                    if (i_player2scored = '1') then -- Reset ball if player scored
                        ball_loc_x <= "0101000000"; 	-- "Random" location for respawn
                    else
                        ball_loc_x <= ball_loc_x - 1;
                    end if;
                else
                    if (i_player1scored = '1') then -- Reset ball if player scored
                        ball_loc_x <= "0101000000"; 	-- "Random" location for respawn
                    else
                        ball_loc_x <= ball_loc_x + 1;
                    end if;
                end if;				
            end if;
        end if;
	end if;
end process Pong;

-- Figure out which component is being drawn currently:
draw_p1 	<= '1' when ((	(scan_line_x >= p1_x) and
						(scan_line_y >= p1_y) and
						(scan_line_x < p1_x + paddle_width) and
						(scan_line_y < p1_y + paddle_height))) 
			else '0';	
-- PART D: Write the logic for draw_p2 and draw_ball here:
draw_p2 	<= '1' when ((	(scan_line_x >= p2_x) and
						(scan_line_y >= p2_y) and
						(scan_line_x < p2_x + paddle_width) and
						(scan_line_y < p2_y + paddle_height))) 
			else '0';	
			
draw_ball 	<= '1' when ((	(scan_line_x >= ball_loc_x) and
                        (scan_line_y >= ball_loc_y) and
                        (scan_line_x < ball_loc_x + ball_width) and
                        (scan_line_y < ball_loc_y + ball_width))) 
            else '0';    

-- Output proper component's color, or background color (white)
process(clk) begin
	if (rising_edge(clk)) then
		if (draw_p1 = '1') then
			red <= p1_color(11 downto 8); green <= p1_color(7 downto 4); blue <= p1_color(3 downto 0); 
		elsif (draw_p2 = '1') then
			red <= p2_color(11 downto 8); green <= p2_color(7 downto 4); blue <= p2_color(3 downto 0); 
		elsif (draw_ball = '1') then
			red <= ball_color(11 downto 8); green <= ball_color(7 downto 4); blue <= ball_color(3 downto 0); 
		else
			red <= "1111"; green <= "1111"; blue <= "1111"; -- Background color
		end if;
	end if;
end process;			

-- Figure out if player scored:
i_player1scored <= 	'1' when ((ball_loc_x + ball_width) = "1001111111") else '0'; -- Right hand edge of the screen
i_player2scored <= 	'1' when (ball_loc_x = "0000000000") else '0'; -- Left hand edge of the screen (0)						

player1_scored <= '1' when ((old_player1scored = '0') and (i_player1scored = '1')) else '0'; -- (Internal signals used in design)
player2_scored <= '1' when ((old_player2scored = '0') and (i_player2scored = '1')) else '0'; -- (Internal signals used in design)

end Behavioral;

