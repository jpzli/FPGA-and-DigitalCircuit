library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevensegment_selector is
    Port ( clk : in  STD_LOGIC;
           switch : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (3 downto 0);
           reset : in  STD_LOGIC);
end sevensegment_selector;

architecture Behavioral of sevensegment_selector is
	signal d, q: STD_LOGIC_VECTOR(3 downto 0);
begin

dffs: process(reset, clk)
begin
	if (reset = '1') then
		-- Fill in the reset state values for q
		q(0) <= '0';
                q(1) <= '0';
                q(2) <= '0';
                q(3) <= '1';
	elsif (rising_edge(clk)) then
		if (switch = '1') then
			-- Propagate signals through the DFF
			-- From input to output
			            q(0) <= d(0);
                        q(1) <= d(1);
                        q(2) <= d(2);
                        q(3) <= d(3);
		else 
		end if;
	end if;
end process;

-- Connect the DFFs into a chain/loop
-- This means output of one needs to connect to input of the next one
                d(1) <= q(0);
				d(2) <= q(1);
				d(3) <= q(2);
				d(0) <= q(3);

-- Copying q to the output of the block
output(0) <= q(0);
output(1) <= q(1);
output(2) <= q(2);
output(3) <= q(3);

end Behavioral;