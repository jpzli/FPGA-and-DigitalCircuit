LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_keyboard IS
END tb_keyboard;
 
ARCHITECTURE behavior OF tb_keyboard IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT keyboard
    PORT(
         clk : IN  std_logic;
         reset : IN std_logic;
         ps2_clk : IN  std_logic;
         ps2_data : IN  std_logic;
         ps2_newcode : OUT  std_logic;
         ps2_code : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ps2_clk : std_logic := '0';
   signal ps2_data : std_logic := '0';

 	--Outputs
   signal ps2_newcode : std_logic;
   signal ps2_code : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 40 ns;
   constant ps2_clk_period : time := 100 us;
	
	-- Signals for testing
	signal code_to_send, code : std_logic_vector(7 downto 0);
	signal send_code: std_logic;
	signal send_code_wrong: std_logic;
	
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: keyboard PORT MAP (
          clk => clk,
          reset => reset,
          ps2_clk => ps2_clk,
          ps2_data => ps2_data,
          ps2_newcode => ps2_newcode,
          ps2_code => ps2_code
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
		code_to_send <= "10010110";
		send_code <= '1';
		wait for clk_period*2;
		send_code <= '0';
		wait for 1500 us; -- A good wait for one character.

		--Send value with an incorrect parity:
		code_to_send <= "11101110";
		send_code_wrong <= '1';
		wait for clk_period*2;
		send_code_wrong <= '0';
		wait for 1500 us;
		
		-- Send value with a correct parity:
		code_to_send <= "11110000";
		send_code <= '1';
		wait for clk_period*2;
		send_code <= '0';
		wait for 1500 us; -- A good wait for one character.
		
		--Send value with an incorrect parity:
		code_to_send <= "11000010";
		send_code_wrong <= '1';
		wait for clk_period*2;
		send_code_wrong <= '0';
		wait for 1500 us;
		

      wait;
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
