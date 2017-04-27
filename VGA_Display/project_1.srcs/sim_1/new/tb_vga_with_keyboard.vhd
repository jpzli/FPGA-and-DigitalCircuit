----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2016 07:34:47 PM
-- Design Name: 
-- Module Name: tb_vga_with_keyboard - Behavioral
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

entity tb_vga_with_keyboard is
--  Port ( );
end tb_vga_with_keyboard;

architecture Behavioral of tb_vga_with_keyboard is
component vga_with_keyboard
    port(
        BTN0: in STD_LOGIC;
        clk: in STD_LOGIC;
        ps2_clk: in STD_LOGIC;
        ps2_data: in STD_LOGIC;
        blue: out STD_LOGIC_VECTOR(3 downto 0);
        green: out STD_LOGIC_VECTOR(3 downto 0);
        red: out STD_LOGIC_VECTOR(3 downto 0);
        LEDs: out STD_LOGIC_VECTOR(7 downto 0);
        hsync: out STD_LOGIC;
        vsync: out STD_LOGIC
        );
end component;

signal reset: std_logic;
signal clk: std_logic := '0';
signal ps2_clk: std_logic := '0';
signal ps2_data: std_logic := '0';
signal blue: std_logic_vector (3 downto 0);
signal green: std_logic_vector (3 downto 0);
signal red: std_logic_vector (3 downto 0);
signal LEDs: std_logic_vector(7 downto 0);
signal hsync: std_logic;
signal vsync: std_logic;

signal code_to_send, code : std_logic_vector(7 downto 0);
signal send_code: std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant ps2_clk_period : time := 100 us;

begin
uut: vga_with_keyboard PORT MAP(
    BTN0 => reset,
    clk => clk,
    ps2_clk => ps2_clk,
    ps2_data => ps2_data,
    blue => blue,
    green => green,
    red => red,
    LEDs => LEDs,
    hsync => hsync,
    vsync => vsync
    );
    
clk_process: process    
begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
end process;

stim_proc: process
begin
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    wait;
end process;

keyboard_test: process
begin
       -- Send value with a correct parity:
      --Test move_left
		code_to_send <= "00011100";
		send_code <= '1';
		wait for clk_period*2;
		send_code <= '0';
		wait for 1500 us; -- A good wait for one character.
		
	-- Send value with a correct parity:
      --Test move_up
        code_to_send <= "00011101";
        send_code <= '1';
        wait for clk_period*2;
        send_code <= '0';
        wait for 1500 us; -- A good wait for one character.
		
		-- Send value with a correct parity:
        --Test move_right
        code_to_send <= "00100011";
        send_code <= '1';
        wait for clk_period*2;
        send_code <= '0';
        wait for 1500 us; -- A good wait for one character.
        
      -- Send value with a correct parity:
       --Test move_down
        code_to_send <= "00011011";
        send_code <= '1';
        wait for clk_period*2;
        send_code <= '0';
        wait for 1500 us; -- A good wait for one character.
        
        -- Send value with a correct parity:
         --Test a random key 1(k)
                code_to_send <= "01000010";
                send_code <= '1';
                wait for clk_period*2;
                send_code <= '0';
                wait for 1500 us; -- A good wait for one character.
                
         -- Send value with a correct parity:
         --Test a random key 1(shift key)
                code_to_send <= "00110010";
                send_code <= '1';
                wait for clk_period*2;
                send_code <= '0';
                wait for 1500 us; -- A good wait for one character.
end process;

	send_code_ps2: process
	begin
		wait for clk_period;
		ps2_clk <= '1';
		code <= code_to_send;
		if (send_code = '1') then
			ps2_data <= '0';				-- START BIT
			wait for ps2_clk_period/2;
			ps2_clk <= '0';
			wait for ps2_clk_period/2;
			ps2_clk <= '1';
			ps2_data <= code(0); -- BIT(0)
			wait for ps2_clk_period/2;
			ps2_clk <= '0';
			wait for ps2_clk_period/2;
			ps2_clk <= '1';
			ps2_data <= code(1); -- BIT(1)
			wait for ps2_clk_period/2;
			ps2_clk <= '0';
			wait for ps2_clk_period/2;
			ps2_clk <= '1';
			ps2_data <= code(2); -- BIT(2)
			wait for ps2_clk_period/2;
			ps2_clk <= '0';
			wait for ps2_clk_period/2;
			ps2_clk <= '1';
			ps2_data <= code(3); -- BIT(3)
			wait for ps2_clk_period/2;
			ps2_clk <= '0';
			wait for ps2_clk_period/2;
			ps2_clk <= '1';
			ps2_data <= code(4); -- BIT(4)
			wait for ps2_clk_period/2;
			ps2_clk <= '0';
			wait for ps2_clk_period/2;
			ps2_clk <= '1';
			ps2_data <= code(5); -- BIT(5)
			wait for ps2_clk_period/2;
			ps2_clk <= '0';
			wait for ps2_clk_period/2;
			ps2_clk <= '1';
			ps2_data <= code(6); -- BIT(6)
			wait for ps2_clk_period/2;
			ps2_clk <= '0';
			wait for ps2_clk_period/2;
			ps2_clk <= '1';
			ps2_data <= code(7); -- BIT(7)
			wait for ps2_clk_period/2;
			ps2_clk <= '0';
			wait for ps2_clk_period/2;
			ps2_clk <= '1';
			-- PARITY BIT:
			ps2_data <= not (code(0) xor code(1) xor code(2) xor code(3) xor
                             code(4) xor code(5) xor code(6) xor code(7));
			wait for ps2_clk_period/2;
			ps2_clk <= '0';
			wait for ps2_clk_period/2;
			ps2_clk <= '1';
			ps2_data <= '1'; -- STOP BIT
			wait for ps2_clk_period/2;
			ps2_clk <= '0';
			wait for ps2_clk_period/2;
			ps2_clk <= '1';	
		end if;
	end process;
end Behavioral;
