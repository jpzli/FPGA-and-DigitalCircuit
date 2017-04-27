library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity clock_divider is
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
end clock_divider;

architecture Behavioral of clock_divider is
-- Signals:
signal 	i_enable: STD_LOGIC;
signal  tfmeghertz: STD_LOGIC;
signal 	kilohertz: STD_LOGIC;
signal 	hundredhertz: STD_LOGIC;
signal	tenhertz: STD_LOGIC;
signal	onehertz: STD_LOGIC;
signal  single_Seconds: STD_LOGIC;
signal	Ten_Seconds: STD_LOGIC;
signal	single_Minutes: STD_LOGIC;
signal	ten_Minutes: STD_LOGIC;
-- Add signals here

-- Components:
-- This is kind of like a function prototype in C/C++
component downcounter is
	Generic ( period: integer:= 4;
				WIDTH: integer:= 3);
		Port ( clk : in  STD_LOGIC;
				  reset : in  STD_LOGIC;
				  enable : in  STD_LOGIC;
				  zero : out  STD_LOGIC;
				  value: out STD_LOGIC_VECTOR(WIDTH-1 downto 0));
end component;

begin
tfmegHzClock: downcounter
generic map(
				period => (4 - 1),
				WIDTH => 4
)
port map(
		clk => clk,
		reset => reset,
		enable => '1',
		zero => tfmeghertz,
		value => open
);

kiloHzClock: downcounter
generic map(
				period => (100000-1), -- "1 1000 0110 1010 0000" in binary change back to 99999 later
				WIDTH => 17
			)
port map (
				clk => clk,
				reset => reset,
				enable => '1',
				zero => kilohertz,
				value => open			-- Leave open since we won't display this value
);

hundredHzClock: downcounter
generic map(
				period => (10-1),	-- Counts numbers between 0 and 9 -> that's 10 values!
				WIDTH => 4
			)
port map (
				clk => clk,
				reset => reset,
				enable => i_enable,
				zero => hundredhertz,
				value => open			-- Leave open since we won't display this value
);

tenHzClock: downcounter
generic map(
				period => (10-1),	-- Counts numbers between 0 and 9 -> that's 10 values!
				WIDTH => 4
			)
port map (
				clk => clk,
				reset => reset,
				enable => hundredhertz,
				zero => tenhertz,
				value => open			-- Leave open since we won't display this value
);

oneHzClock: downcounter
generic map(
				period => (10-1),
				WIDTH => 4
			)
port map (
			clk => clk,
			reset => reset,
			enable => tenhertz,
			zero => onehertz,
			value => open			-- Leave open since we won't display this value
);

single_SecondsClock: downcounter
generic map(
				period => (10-1),
				WIDTH => 4
			)
port map (
			clk => clk,
			reset => reset,
			enable => onehertz,
			zero => single_Seconds,
			value => sec_dig_1			-- Leave open since we won't display this value
);

ten_SecondsClock: downcounter
generic map(
				period => (6-1),
				WIDTH => 4
			)
port map (
			clk => clk,
			reset => reset,
			enable => single_Seconds,
			zero => ten_Seconds,
			value => sec_dig_2			-- Leave open since we won't display this value
);

single_MinutesClock: downcounter
generic map(
				period => (10-1),
				WIDTH => 4
			)
port map (
			clk => clk,
			reset => reset,
			enable => ten_Seconds,
			zero => single_Minutes,
			value => min_dig_1			-- Leave open since we won't display this value
);

ten_MinutesClock: downcounter
generic map(
				period => (6-1),
				WIDTH => 4
			)
port map (
			clk => clk,
			reset => reset,
			enable => single_Minutes,
			zero => open,
			value => min_dig_2			-- Leave open since we won't display this value
);


-- Connect internal signals to outputs
kHz <= kilohertz;
tfmegHz <= tfmeghertz;
hundredHz <= hundredhertz;
i_enable <= kilohertz and enable;

end Behavioral;