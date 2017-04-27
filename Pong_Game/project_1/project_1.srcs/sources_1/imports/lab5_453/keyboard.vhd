library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity keyboard is
	PORT (
		clk: in STD_LOGIC;
		reset: in STD_LOGIC;
		ps2_clk: in STD_LOGIC;
		ps2_data: in STD_LOGIC;
		ps2_newcode: OUT STD_LOGIC;
		ps2_code: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
end keyboard;

architecture Behavioral of keyboard is

-- PS/2 CLK Debounce circuit:
signal debounce_ps2_clk_count: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
signal debounce_ps2_clk_dffs: STD_LOGIC_VECTOR(1 downto 0);
signal debounce_ps2_clk_changing: STD_LOGIC;
signal stable_ps2_clk, stable_ps2_clk_old: STD_LOGIC;
signal stable_ps2_clk_dffs: STD_LOGIC_VECTOR(1 downto 0);

-- PS/2 DATA Debounce circuit:
signal debounce_ps2_data_count: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
signal debounce_ps2_data_dffs: STD_LOGIC_VECTOR(1 downto 0);
signal debounce_ps2_data_changing: STD_LOGIC;
signal stable_ps2_data: STD_LOGIC;

-- PS/2 DATA signals:
signal ps2_word: STD_LOGIC_VECTOR(10 downto 0);
signal ps2_error: STD_LOGIC;

-- PS/2 IDLE signals:
signal count_idle: integer range 0 to 5500;

begin

-- Debounce the input ps2_clk:
debounce_ps2_clk_changing <= 	debounce_ps2_clk_dffs(0) xor debounce_ps2_clk_dffs(1);
debounce_ps2_data_changing <= 	debounce_ps2_data_dffs(0) xor debounce_ps2_data_dffs(1);
											
debounce_ps2_clk: process (clk, reset)
    begin
        if (reset = '1') then
            debounce_ps2_clk_dffs <= "00";
        elsif (rising_edge(clk)) then
			debounce_ps2_clk_dffs(0) <= ps2_clk;
			debounce_ps2_clk_dffs(1) <= debounce_ps2_clk_dffs(0);
			if(debounce_ps2_clk_changing = '1') then
				debounce_ps2_clk_count <= (others => '0');
			elsif (debounce_ps2_clk_count(9) = '0') then
				debounce_ps2_clk_count <= debounce_ps2_clk_count + 1;			
			else
				stable_ps2_clk <= debounce_ps2_clk_dffs(1);
			end if;
		end if;
end process debounce_ps2_clk;

debounce_ps2_data: process(clk, reset)
	begin
		if(reset = '1') then
			debounce_ps2_data_dffs <= "00";
		elsif(falling_edge(clk)) then
			debounce_ps2_data_dffs(0) <= ps2_data;
			debounce_ps2_data_dffs(1) <= debounce_ps2_data_dffs(0);
			if(debounce_ps2_data_changing = '1') then
				debounce_ps2_data_count <= debounce_ps2_data_count + 1;
			elsif (debounce_ps2_data_count(9) = '0') then
				debounce_ps2_data_count <= debounce_ps2_data_count + 1;
			else
				stable_ps2_data <= debounce_ps2_data_dffs(1);
			end if;
		end if;
end process debounce_ps2_data;
-- Debounce the input ps2_data:
-- WRITE CODE HERE

-- Get PS/2 Data into a word (array)
get_ps2_data: process(clk, reset)
begin
    if (reset = '1') then
        stable_ps2_clk_dffs <= "00";
	elsif (rising_edge(clk)) then
		stable_ps2_clk_dffs(0) <= stable_ps2_clk;
		stable_ps2_clk_dffs(1) <= stable_ps2_clk_dffs(0);
		if ((stable_ps2_clk_dffs(0) = '0') and (stable_ps2_clk_dffs(1) = '1')) then
			ps2_word <= stable_ps2_data & ps2_word(10 downto 1);
		end if;
	end if;
end process get_ps2_data;

-- Verify parity
ps2_error <= ps2_word(9) xor not(ps2_word(1) xor ps2_word(2) xor ps2_word(3)
xor ps2_word(4) xor ps2_word(5) xor ps2_word(6) xor ps2_word(7) xor ps2_word(8));


-- Check if PS/2 idle and output result
process(clk, reset)
begin
    if (reset = '1') then 
        count_idle <= 0;
	elsif (rising_edge(clk)) then
		if (stable_ps2_clk = '0') then
			count_idle <= 0;
		elsif(count_idle /= 5500) then
			count_idle <= count_idle + 1;
		end if;
		
		if (count_idle = 5500 and ps2_error = '0') then
			ps2_newcode <= '1';
			ps2_code <= ps2_word(8 downto 1);
		else
			ps2_newcode <= '0';
		end if;		
	end if;
end process;

end Behavioral;

