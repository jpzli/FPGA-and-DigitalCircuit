LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_selector IS
END tb_selector;
 
ARCHITECTURE behavior OF tb_selector IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sevensegment_selector
    PORT(
         clk : IN  std_logic;
         switch : IN  std_logic;
         output : OUT  std_logic_vector(3 downto 0);
         reset : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal switch : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal output : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sevensegment_selector PORT MAP (
          clk => clk,
          switch => switch,
          output => output,
          reset => reset
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	switch_process: process
	begin
		switch <= '0';
		wait for clk_period * 10;
		switch <= '1';
		wait for clk_period;
		-- Write the contents of this process
		-- switch needs to pulse, but slower than clk
	end process;
     
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '0';
      wait for 100 ns;	
		reset <= '1';
      wait for clk_period*10;
		reset <= '0';
      -- insert stimulus here 

      wait for clk_period*100;
   end process;

END;
