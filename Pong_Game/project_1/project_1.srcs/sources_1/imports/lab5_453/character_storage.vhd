library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity character_storage is
	PORT(
		clk: in std_logic;
		reset: in std_logic;
		write_to_loc: in std_logic;
		write_value: in std_logic_vector(6 downto 0);
		read_loc: in std_logic_vector(5 downto 0);
		read_value: out std_logic_vector(10 downto 0)		
	);
end character_storage;

architecture Behavioral of character_storage is

	type mem_type is array (0 to 2**5-1) of std_logic_vector(11 downto 0);
	signal characters: mem_type;
	signal location_pointer: integer := 0;
	signal i_read_loc: integer := 0;
	signal i_read_value: std_logic_vector(11 downto 0);
begin

read_value <= i_read_value(10 downto 0);
i_read_value <= characters(i_read_loc);
i_read_loc <= to_integer(unsigned(read_loc));

process(clk, reset)
begin
    if (reset = '1') then
        -- Complete the reset state description
		location_pointer <= 0;
		characters(location_pointer) <= x"000";
       
	elsif (rising_edge(clk)) then
        if (write_to_loc = '1') then
            -- Complete logic for location_pointer here
            if(location_pointer = 31) then
                location_pointer <= 0;
            else
                location_pointer <= location_pointer + 1;
            end if; 
            
            case write_value is
                when "1100001" => characters(location_pointer) <= x"010"; -- A
                when "1100010" => characters(location_pointer) <= x"020"; -- B
                when "1100011" => characters(location_pointer) <= x"030"; -- C
                when "1100100" => characters(location_pointer) <= x"040"; -- D
                when "1100101" => characters(location_pointer) <= x"050"; -- E
                when "1100110" => characters(location_pointer) <= x"060"; -- F
                when "1100111" => characters(location_pointer) <= x"070"; -- G
                when "1101000" => characters(location_pointer) <= x"080"; -- H
                when "1101001" => characters(location_pointer) <= x"090"; -- I
                when "1101010" => characters(location_pointer) <= x"0A0"; -- J
                when "1101011" => characters(location_pointer) <= x"0B0"; -- K
                when "1101100" => characters(location_pointer) <= x"0C0"; -- L
                when "1101101" => characters(location_pointer) <= x"0D0"; -- M
                when "1101110" => characters(location_pointer) <= x"0E0"; -- N
                when "1101111" => characters(location_pointer) <= x"0F0"; -- O
                when "1110000" => characters(location_pointer) <= x"100"; -- P
                when "1110001" => characters(location_pointer) <= x"110"; -- Q
                when "1110010" => characters(location_pointer) <= x"120"; -- R
                when "1110011" => characters(location_pointer) <= x"130"; -- S
                when "1110100" => characters(location_pointer) <= x"140"; -- T
                when "1110101" => characters(location_pointer) <= x"150"; -- U
                when "1110110" => characters(location_pointer) <= x"160"; -- V
                when "1110111" => characters(location_pointer) <= x"170"; -- W
                when "1111000" => characters(location_pointer) <= x"180"; -- X
                when "1111001" => characters(location_pointer) <= x"190"; -- Y
                when "1111010" => characters(location_pointer) <= x"1A0"; -- Z
                when others => characters(location_pointer) <= x"000";
            end case;
        end if;
	end if;
end process;

end Behavioral;

