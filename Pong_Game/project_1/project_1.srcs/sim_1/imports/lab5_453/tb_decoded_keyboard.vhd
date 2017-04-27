library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_decoded_keyboard is
--  Port ( );
end tb_decoded_keyboard;

architecture Behavioral of tb_decoded_keyboard is

component decoded_keyboard
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

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ps2_clk : std_logic := '0';
   signal ps2_data : std_logic := '0';

 	--Outputs
   signal key_pressed: std_logic_vector(6 downto 0);
   signal key_released: std_logic_vector(6 downto 0);
   signal key_make: std_logic;
   signal shift: std_logic;
   signal ctrl: std_logic;
   signal key_break: std_logic;
   signal caps_lock: std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant ps2_clk_period : time := 100 us;
	
	-- Signals for testing
	signal code_to_send, code : std_logic_vector(7 downto 0);
	signal send_code_wrong: std_logic :='0';
	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decoded_keyboard PORT MAP (
          clk => clk,
          reset => reset,
          ps2_clk => ps2_clk,
          ps2_data => ps2_data,
          shift => shift,
          ctrl => ctrl,
          key_pressed => key_pressed,
		  key_released => key_released,
		  key_make => key_make,
		  key_break => key_break,
		  caps_lock => caps_lock
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
        reset <= '1';
		wait for 100 ns;
		reset <= '0';
		
		-- Send value with a correct parity:
		code_to_send <= "00011100";
		key_break <= '1';
		wait for clk_period*2;
		key_break <= '0';
		wait for 1500 us; -- A good wait for one character.
		
		-- Send value with a correct parity:
		code_to_send <= "00011011";
		key_break <= '1';
		wait for clk_period*2;
		key_break <= '0';
		wait for 1500 us; -- A good wait for one character.
		
		-- Send value with a correct parity:
		code_to_send <= "00100011";
		key_break <= '1';
		wait for clk_period*2;
		key_break <= '0';
		wait for 1500 us; -- A good wait for one character.
		
		-- Send value with a correct parity:
		code_to_send <= "00101011";
		key_break <= '1';
		wait for clk_period*2;
		key_break <= '0';
		wait for 1500 us; -- A good wait for one character.
		
		-- Send value with a correct parity:
		code_to_send <= "00110010";
		key_break <= '1';
		wait for clk_period*2;
		key_break <= '0';
		wait for 1500 us; -- A good wait for one character.
		

      wait;
   end process;
  	
	send_code_ps2: process
	begin
		wait for clk_period;
		ps2_clk <= '1';
		code <= code_to_send;
		if (key_break = '0') then
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
			
		elsif(send_code_wrong = '1') then
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
			ps2_data <= not (not(code(0)) xor code(1) xor code(2) xor code(3) xor
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

END;