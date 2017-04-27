LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY tb_sevensegment IS
END tb_sevensegment;
 
ARCHITECTURE behavior OF tb_sevensegment IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	
    COMPONENT sevensegment
    PORT(
         CA : OUT  std_logic;
         CB : OUT  std_logic;
         CC : OUT  std_logic;
         CD : OUT  std_logic;
         CE : OUT  std_logic;
         CF : OUT  std_logic;
         CG : OUT  std_logic;
         DP : OUT  std_logic;
         dp_in : IN  std_logic;
         data : IN  std_logic_vector(3 downto 0)
        );
    END COMPONENT;   

   --Inputs
   signal dp_in : std_logic := '0';
   signal data : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal CA : std_logic;
   signal CB : std_logic;
   signal CC : std_logic;
   signal CD : std_logic;
   signal CE : std_logic;
   signal CF : std_logic;
   signal CG : std_logic;
   signal DP : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sevensegment PORT MAP (
          CA => CA,
          CB => CB,
          CC => CC,
          CD => CD,
          CE => CE,
          CF => CF,
          CG => CG,
          DP => DP,
          dp_in => dp_in,
          data => data
        );


   -- Stimulus process
   dp_i: process
   begin
        dp_in <= '0';
        wait for 100 ns;
        dp_in <= '1';
        wait for 100 ns;
        end process;
        
   stim_proc: process
      begin        
           wait for 100 ns;
           data <= "0000";
           wait for 50 ns;
           data <= "0001";
           wait for 50 ns;
           data <= "0010";
           wait for 50 ns;
           data <= "0011";
           wait for 50 ns;
           data <= "0100";
           wait for 50 ns;
           data <= "0101";
           wait for 50 ns;
           data <= "0110";
           wait for 50 ns;
           data <= "0111";
           wait for 50 ns;
           data <= "1000";
           wait for 50 ns;
           data <= "1001";
           wait for 50 ns;
           data <= "1010";
           wait for 50 ns;
      end process;

END;