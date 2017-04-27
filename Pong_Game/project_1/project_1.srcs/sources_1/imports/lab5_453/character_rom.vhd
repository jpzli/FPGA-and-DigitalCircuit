library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity character_rom is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(10 downto 0);
      data: out std_logic_vector(7 downto 0)
   );
end character_rom;

architecture Behavioural of character_rom is
   constant ADDR_WIDTH: integer:=11;
   constant DATA_WIDTH: integer:=8;
   signal addr_reg: std_logic_vector(ADDR_WIDTH-1 downto 0);
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant ROM: rom_type:=(  
   -- addr x000 
   "00000000", -- 0 -- Show an underscore
   "00000000", -- 1
   "00000000", -- 2
   "00000000", -- 3
   "00000000", -- 4
   "00000000", -- 5
   "00000000", -- 6
   "00000000", -- 7
   "00000000", -- 8
   "00000000", -- 9
   "00000000", -- a
   "00000000", -- b
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "11111111", -- f
   -- addr x010
   "00000000", -- 0
   "00000000", -- 1
   "00010000", -- 2    *
   "00111000", -- 3   ***
   "01101100", -- 4  ** **
   "11000110", -- 5 **   **
   "11000110", -- 6 **   **
   "11111110", -- 7 *******
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "11000110", -- b **   **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x020
   "00000000", -- 0
   "00000000", -- 1
   "11111100", -- 2 ******
   "01100110", -- 3  **  **
   "01100110", -- 4  **  **
   "01100110", -- 5  **  **
   "01111100", -- 6  *****
   "01100110", -- 7  **  **
   "01100110", -- 8  **  **
   "01100110", -- 9  **  **
   "01100110", -- a  **  **
   "11111100", -- b ******
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x030
   "00000000", -- 0
   "00000000", -- 1
   "00111100", -- 2   ****
   "01100110", -- 3  **  **
   "11000010", -- 4 **    *
   "11000000", -- 5 **
   "11000000", -- 6 **
   "11000000", -- 7 **
   "11000000", -- 8 **
   "11000010", -- 9 **    *
   "01100110", -- a  **  **
   "00111100", -- b   ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x040
   "00000000", -- 0
   "00000000", -- 1
   "11111000", -- 2 *****
   "01101100", -- 3  ** **
   "01100110", -- 4  **  **
   "01100110", -- 5  **  **
   "01100110", -- 6  **  **
   "01100110", -- 7  **  **
   "01100110", -- 8  **  **
   "01100110", -- 9  **  **
   "01101100", -- a  ** **
   "11111000", -- b *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x050
   "00000000", -- 0
   "00000000", -- 1
   "11111110", -- 2 *******
   "01100110", -- 3  **  **
   "01100010", -- 4  **   *
   "01101000", -- 5  ** *
   "01111000", -- 6  ****
   "01101000", -- 7  ** *
   "01100000", -- 8  **
   "01100010", -- 9  **   *
   "01100110", -- a  **  **
   "11111110", -- b *******
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x060
   "00000000", -- 0
   "00000000", -- 1
   "11111110", -- 2 *******
   "01100110", -- 3  **  **
   "01100010", -- 4  **   *
   "01101000", -- 5  ** *
   "01111000", -- 6  ****
   "01101000", -- 7  ** *
   "01100000", -- 8  **
   "01100000", -- 9  **
   "01100000", -- a  **
   "11110000", -- b ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x070
   "00000000", -- 0
   "00000000", -- 1
   "00111100", -- 2   ****
   "01100110", -- 3  **  **
   "11000010", -- 4 **    *
   "11000000", -- 5 **
   "11000000", -- 6 **
   "11011110", -- 7 ** ****
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "01100110", -- a  **  **
   "00111010", -- b   *** *
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x080
   "00000000", -- 0
   "00000000", -- 1
   "11000110", -- 2 **   **
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "11000110", -- 5 **   **
   "11111110", -- 6 *******
   "11000110", -- 7 **   **
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "11000110", -- b **   **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x090
   "00000000", -- 0
   "00000000", -- 1
   "00111100", -- 2   ****
   "00011000", -- 3    **
   "00011000", -- 4    **
   "00011000", -- 5    **
   "00011000", -- 6    **
   "00011000", -- 7    **
   "00011000", -- 8    **
   "00011000", -- 9    **
   "00011000", -- a    **
   "00111100", -- b   ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x0a0
   "00000000", -- 0
   "00000000", -- 1
   "00011110", -- 2    ****
   "00001100", -- 3     **
   "00001100", -- 4     **
   "00001100", -- 5     **
   "00001100", -- 6     **
   "00001100", -- 7     **
   "11001100", -- 8 **  **
   "11001100", -- 9 **  **
   "11001100", -- a **  **
   "01111000", -- b  ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x0b0
   "00000000", -- 0
   "00000000", -- 1
   "11100110", -- 2 ***  **
   "01100110", -- 3  **  **
   "01100110", -- 4  **  **
   "01101100", -- 5  ** **
   "01111000", -- 6  ****
   "01111000", -- 7  ****
   "01101100", -- 8  ** **
   "01100110", -- 9  **  **
   "01100110", -- a  **  **
   "11100110", -- b ***  **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x0c0
   "00000000", -- 0
   "00000000", -- 1
   "11110000", -- 2 ****
   "01100000", -- 3  **
   "01100000", -- 4  **
   "01100000", -- 5  **
   "01100000", -- 6  **
   "01100000", -- 7  **
   "01100000", -- 8  **
   "01100010", -- 9  **   *
   "01100110", -- a  **  **
   "11111110", -- b *******
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x0d0
   "00000000", -- 0
   "00000000", -- 1
   "11000011", -- 2 **    **
   "11100111", -- 3 ***  ***
   "11111111", -- 4 ********
   "11111111", -- 5 ********
   "11011011", -- 6 ** ** **
   "11000011", -- 7 **    **
   "11000011", -- 8 **    **
   "11000011", -- 9 **    **
   "11000011", -- a **    **
   "11000011", -- b **    **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x0e0
   "00000000", -- 0
   "00000000", -- 1
   "11000110", -- 2 **   **
   "11100110", -- 3 ***  **
   "11110110", -- 4 **** **
   "11111110", -- 5 *******
   "11011110", -- 6 ** ****
   "11001110", -- 7 **  ***
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "11000110", -- b **   **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x0f0
   "00000000", -- 0
   "00000000", -- 1
   "01111100", -- 2  *****
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "11000110", -- 5 **   **
   "11000110", -- 6 **   **
   "11000110", -- 7 **   **
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x100
   "00000000", -- 0
   "00000000", -- 1
   "11111100", -- 2 ******
   "01100110", -- 3  **  **
   "01100110", -- 4  **  **
   "01100110", -- 5  **  **
   "01111100", -- 6  *****
   "01100000", -- 7  **
   "01100000", -- 8  **
   "01100000", -- 9  **
   "01100000", -- a  **
   "11110000", -- b ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x110
   "00000000", -- 0
   "00000000", -- 1
   "01111100", -- 2  *****
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "11000110", -- 5 **   **
   "11000110", -- 6 **   **
   "11000110", -- 7 **   **
   "11000110", -- 8 **   **
   "11010110", -- 9 ** * **
   "11011110", -- a ** ****
   "01111100", -- b  *****
   "00001100", -- c     **
   "00001110", -- d     ***
   "00000000", -- e
   "00000000", -- f
   -- addr x120
   "00000000", -- 0
   "00000000", -- 1
   "11111100", -- 2 ******
   "01100110", -- 3  **  **
   "01100110", -- 4  **  **
   "01100110", -- 5  **  **
   "01111100", -- 6  *****
   "01101100", -- 7  ** **
   "01100110", -- 8  **  **
   "01100110", -- 9  **  **
   "01100110", -- a  **  **
   "11100110", -- b ***  **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x130
   "00000000", -- 0
   "00000000", -- 1
   "01111100", -- 2  *****
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "01100000", -- 5  **
   "00111000", -- 6   ***
   "00001100", -- 7     **
   "00000110", -- 8      **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x140
   "00000000", -- 0
   "00000000", -- 1
   "11111111", -- 2 ********
   "11011011", -- 3 ** ** **
   "10011001", -- 4 *  **  *
   "00011000", -- 5    **
   "00011000", -- 6    **
   "00011000", -- 7    **
   "00011000", -- 8    **
   "00011000", -- 9    **
   "00011000", -- a    **
   "00111100", -- b   ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x150
   "00000000", -- 0
   "00000000", -- 1
   "11000110", -- 2 **   **
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "11000110", -- 5 **   **
   "11000110", -- 6 **   **
   "11000110", -- 7 **   **
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x160
   "00000000", -- 0
   "00000000", -- 1
   "11000011", -- 2 **    **
   "11000011", -- 3 **    **
   "11000011", -- 4 **    **
   "11000011", -- 5 **    **
   "11000011", -- 6 **    **
   "11000011", -- 7 **    **
   "11000011", -- 8 **    **
   "01100110", -- 9  **  **
   "00111100", -- a   ****
   "00011000", -- b    **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x170
   "00000000", -- 0
   "00000000", -- 1
   "11000011", -- 2 **    **
   "11000011", -- 3 **    **
   "11000011", -- 4 **    **
   "11000011", -- 5 **    **
   "11000011", -- 6 **    **
   "11011011", -- 7 ** ** **
   "11011011", -- 8 ** ** **
   "11111111", -- 9 ********
   "01100110", -- a  **  **
   "01100110", -- b  **  **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f

   -- addr x180
   "00000000", -- 0
   "00000000", -- 1
   "11000011", -- 2 **    **
   "11000011", -- 3 **    **
   "01100110", -- 4  **  **
   "00111100", -- 5   ****
   "00011000", -- 6    **
   "00011000", -- 7    **
   "00111100", -- 8   ****
   "01100110", -- 9  **  **
   "11000011", -- a **    **
   "11000011", -- b **    **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x190
   "00000000", -- 0
   "00000000", -- 1
   "11000011", -- 2 **    **
   "11000011", -- 3 **    **
   "11000011", -- 4 **    **
   "01100110", -- 5  **  **
   "00111100", -- 6   ****
   "00011000", -- 7    **
   "00011000", -- 8    **
   "00011000", -- 9    **
   "00011000", -- a    **
   "00111100", -- b   ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- addr x1a0
   "00000000", -- 0
   "00000000", -- 1
   "11111111", -- 2 ********
   "11000011", -- 3 **    **
   "10000110", -- 4 *    **
   "00001100", -- 5     **
   "00011000", -- 6    **
   "00110000", -- 7   **
   "01100000", -- 8  **
   "11000001", -- 9 **     *
   "11000011", -- a **    **
   "11111111", -- b ********
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
	others => "00000000"
   );
begin
   -- addr register to infer block RAM
   process (clk)
   begin
      if (rising_edge(clk)) then
        addr_reg <= addr;
      end if;
   end process;
   data <= ROM(to_integer(unsigned(addr_reg)));
end Behavioural;
