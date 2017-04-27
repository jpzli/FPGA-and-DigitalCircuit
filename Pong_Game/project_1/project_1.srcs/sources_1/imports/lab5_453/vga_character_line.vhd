library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_character_line is
	PORT(
		clk: in std_logic;
		reset: in std_logic;
		accept_new_char: in std_logic;
		new_char_value: in std_logic_vector(6 downto 0);
		scan_line_x: in std_logic_vector(10 downto 0);
		scan_line_y: in std_logic_vector(10 downto 0);
		character_pixel: out std_logic
	);
end vga_character_line;

architecture Behavioral of vga_character_line is

component character_rom is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(10 downto 0);
      data: out std_logic_vector(7 downto 0)
   );
end component;

component character_storage is
	PORT(
		clk: in std_logic;
		reset: in std_logic;
		write_to_loc: in std_logic;
		write_value: in std_logic_vector(6 downto 0);
		read_loc: in std_logic_vector(5 downto 0);
		read_value: out std_logic_vector(10 downto 0)		
	);
end component;

signal rom_addr_offset: std_logic_vector(10 downto 0);
signal rom_start_addr: std_logic_vector(10 downto 0);
signal char_stor_index: std_logic_vector(5 downto 0);
signal char_rom_addr: std_logic_vector(10 downto 0);
signal p1_name_offset: std_logic_vector(10 downto 0);
signal p2_name_offset: std_logic_vector(10 downto 0);
signal wide_char: std_logic_vector(15 downto 0);
signal rom_data: std_logic_vector(7 downto 0);

begin
CHAR_ROM: character_rom
   port map(
      clk => clk,
      addr => char_rom_addr,
      data => rom_data
   );
CHAR_STORAGE: character_storage
	PORT map(
		clk => clk,
		reset => reset,
		write_to_loc => accept_new_char,
		write_value => new_char_value,
		read_loc => char_stor_index,
		read_value => rom_start_addr		
	);

rom_addr_offset <= scan_line_y - "00000001010";
char_rom_addr <= rom_addr_offset + rom_start_addr;
p1_name_offset <= scan_line_x - "00001010000";
-- Implement the logic for p2_name_offset here:
p2_name_offset <= scan_line_x - "00011110000";

					
wide_char <= 	'0' & rom_data(0) & rom_data(1) & rom_data(1) & rom_data(2) &
                    rom_data(2) & rom_data(3) & rom_data(3) & rom_data(4) & 
                    rom_data(4) & rom_data(5) & rom_data(5) & rom_data(6) &
                    rom_data(6) & rom_data(7) & '0';
                    
drawLetters: process(clk) begin
	if (rising_edge(clk)) then
		if (scan_line_y > "00000001001") and (scan_line_y < "00000011010") then
			if (scan_line_x < "00001010000") then -- first box (empty)
				character_pixel <= '0';
			elsif (scan_line_x < "00011110000") then -- player 1 name
				char_stor_index <= p1_name_offset(9 downto 4);
				character_pixel <= wide_char(to_integer(unsigned(p1_name_offset(3 downto 0))));
			elsif (scan_line_x < "00110010000") then -- empty
				character_pixel <= '0';
			elsif (scan_line_x < "01000110000") then -- player 2 name
				char_stor_index <= p2_name_offset(9 downto 4);
				character_pixel <= wide_char(to_integer(unsigned(p2_name_offset(3 downto 0))));
			else
				character_pixel <= '0';
			end if;
		else
			character_pixel <= '0';
		end if;
	end if;
end process drawLetters;

end Behavioral;

