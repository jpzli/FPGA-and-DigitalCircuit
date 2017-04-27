library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoded_keyboard is
	PORT (
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		ps2_clk: in STD_LOGIC;
		ps2_data: in STD_LOGIC;
		new_value_received: out STD_LOGIC;
		value: out STD_LOGIC_VECTOR(6 downto 0);
		shift: out STD_LOGIC;
		ctrl: out STD_LOGIC
	);
end decoded_keyboard;

architecture Behavioral of decoded_keyboard is
-- SIGNALS
signal ps2_code: STD_LOGIC_VECTOR(7 downto 0);
signal ps2_newcode: STD_LOGIC;
signal ps2_newcode_old: STD_LOGIC;

-- Decoder FSM:
TYPE SM is (ready, new_code, translate, output);
signal state: SM;
signal break: STD_LOGIC := '0';
signal multikey_code: STD_LOGIC := '0';
signal caps_lock: STD_LOGIC := '0';
signal ctrl_r: STD_LOGIC := '0';
signal ctrl_l: STD_LOGIC := '0';
signal shift_r: STD_LOGIC := '0';
signal shift_l: STD_LOGIC := '0';
signal decoded_value: STD_LOGIC_VECTOR(7 downto 0) := x"FF";

constant NEXT_IS_BREAK: STD_LOGIC_VECTOR(7 downto 0) := x"F0";
constant MULTIKEY: STD_LOGIC_VECTOR(7 downto 0) := x"E0";
constant CAPS_LOCK_CODE: STD_LOGIC_VECTOR(7 downto 0) := x"58";
constant CTRL_CODE: STD_LOGIC_VECTOR(7 downto 0) := x"14";
constant L_SHIFT_CODE: STD_LOGIC_VECTOR(7 downto 0) := x"12";
constant R_SHIFT_CODE: STD_LOGIC_VECTOR(7 downto 0) := x"59";

-- COMPONENTS
component keyboard is
	PORT (
		clk: in STD_LOGIC;
		reset: in STD_LOGIC;
		ps2_clk: in STD_LOGIC;
		ps2_data: in STD_LOGIC;
		ps2_newcode: OUT STD_LOGIC;
		ps2_code: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
end component;

begin

PS2_KEYBOARD: keyboard
	PORT MAP(
		clk => clk,
		reset => reset,
		ps2_clk => ps2_clk,
		ps2_data => ps2_data,
		ps2_newcode => ps2_newcode,
		ps2_code => ps2_code
	);


PS2_DECODE: process(clk, reset)
begin
    if (reset = '1') then
        state <= ready;
    elsif (rising_edge(clk)) then
		ps2_newcode_old <= ps2_newcode;					
		case state is
			when ready =>		
				new_value_received <= '0'; --According to the diagram new_value_received always resets back to 0 when in this state
				if (ps2_newcode_old = '0' and ps2_newcode = '1') then
                    state <= new_code;
				else
                    state <= ready;
				end if;
			
			when new_code => 
				if (ps2_code = NEXT_IS_BREAK) then
					break <= '1';
					state <= ready;
				elsif (ps2_code = MULTIKEY) then
					multikey_code <= '1';
					state <= ready; --Changed in accordance to the pre-lab diagram
				else
					decoded_value(7) <= '1';
					state <= translate;
				end if;
				
			when translate => 
				break <= '0';
				multikey_code <= '0';
				
				case ps2_code is
					when CAPS_LOCK_CODE => 
						if (break = '0') then
							caps_lock <= not caps_lock;
						end if;
					when CTRL_CODE =>
						if (multikey_code = '1') then
							ctrl_r <= not break;
						else 	
							ctrl_l <= not break;
						end if;
					when L_SHIFT_CODE =>
						shift_l <= not break;
					when R_SHIFT_CODE =>
						shift_r <= not break;	  
					when others => null;
				end case;
			
				IF(ctrl_l = '1' OR ctrl_r = '1') THEN
					-- Not decoding these values, just output 0
					decoded_value <= x"00";            
				ELSE 
				  CASE ps2_code IS
					WHEN x"29" => decoded_value <= x"20"; --space
					WHEN x"66" => decoded_value <= x"08"; --backspace (BS control code)
					WHEN x"0D" => decoded_value <= x"09"; --tab (HT control code)
					WHEN x"5A" => decoded_value <= x"0D"; --enter (CR control code)
					WHEN x"76" => decoded_value <= x"1B"; --escape (ESC control code)
					WHEN x"71" => 
					  IF(multikey_code = '1') THEN      --ps2 code for delete is a multi-key code
						decoded_value <= x"7F";             --delete
					  END IF;
					WHEN OTHERS => NULL;
				  END CASE;
			  
			  --translate letters
              IF((shift_r = '0' AND shift_l = '0' AND caps_lock = '0') OR
                ((shift_r = '1' OR shift_l = '1') AND caps_lock = '1')) THEN
                CASE ps2_code IS              
				  -- LOWER CASE LETTERS:
                  WHEN x"1C" => decoded_value <= x"61"; --a
                  WHEN x"32" => decoded_value <= x"62"; --b
                  WHEN x"21" => decoded_value <= x"63"; --c
                  WHEN x"23" => decoded_value <= x"64"; --d
                  WHEN x"24" => decoded_value <= x"65"; --e
                  WHEN x"2B" => decoded_value <= x"66"; --f
                  WHEN x"34" => decoded_value <= x"67"; --g
                  WHEN x"33" => decoded_value <= x"68"; --h
                  WHEN x"43" => decoded_value <= x"69"; --i
                  WHEN x"3B" => decoded_value <= x"6A"; --j
                  WHEN x"42" => decoded_value <= x"6B"; --k
                  WHEN x"4B" => decoded_value <= x"6C"; --l
                  WHEN x"3A" => decoded_value <= x"6D"; --m
                  WHEN x"31" => decoded_value <= x"6E"; --n
                  WHEN x"44" => decoded_value <= x"6F"; --o
                  WHEN x"4D" => decoded_value <= x"70"; --p
                  WHEN x"15" => decoded_value <= x"71"; --q
                  WHEN x"2D" => decoded_value <= x"72"; --r
                  WHEN x"1B" => decoded_value <= x"73"; --s
                  WHEN x"2C" => decoded_value <= x"74"; --t
                  WHEN x"3C" => decoded_value <= x"75"; --u
                  WHEN x"2A" => decoded_value <= x"76"; --v
                  WHEN x"1D" => decoded_value <= x"77"; --w
                  WHEN x"22" => decoded_value <= x"78"; --x
                  WHEN x"35" => decoded_value <= x"79"; --y
                  WHEN x"1A" => decoded_value <= x"7A"; --z
                  WHEN OTHERS => NULL;
                END CASE;
              ELSE                                     
                CASE ps2_code IS   
				  -- UPPER CASE LETTERS:
                  WHEN x"1C" => decoded_value <= x"41"; --A
                  WHEN x"32" => decoded_value <= x"42"; --B
                  WHEN x"21" => decoded_value <= x"43"; --C
                  WHEN x"23" => decoded_value <= x"44"; --D
                  WHEN x"24" => decoded_value <= x"45"; --E
                  WHEN x"2B" => decoded_value <= x"46"; --F
                  WHEN x"34" => decoded_value <= x"47"; --G
                  WHEN x"33" => decoded_value <= x"48"; --H
                  WHEN x"43" => decoded_value <= x"49"; --I
                  WHEN x"3B" => decoded_value <= x"4A"; --J
                  WHEN x"42" => decoded_value <= x"4B"; --K
                  WHEN x"4B" => decoded_value <= x"4C"; --L
                  WHEN x"3A" => decoded_value <= x"4D"; --M
                  WHEN x"31" => decoded_value <= x"4E"; --N
                  WHEN x"44" => decoded_value <= x"4F"; --O
                  WHEN x"4D" => decoded_value <= x"50"; --P
                  WHEN x"15" => decoded_value <= x"51"; --Q
                  WHEN x"2D" => decoded_value <= x"52"; --R
                  WHEN x"1B" => decoded_value <= x"53"; --S
                  WHEN x"2C" => decoded_value <= x"54"; --T
                  WHEN x"3C" => decoded_value <= x"55"; --U
                  WHEN x"2A" => decoded_value <= x"56"; --V
                  WHEN x"1D" => decoded_value <= x"57"; --W
                  WHEN x"22" => decoded_value <= x"58"; --X
                  WHEN x"35" => decoded_value <= x"59"; --Y
                  WHEN x"1A" => decoded_value <= x"5A"; --Z
                  WHEN OTHERS => NULL;
                END CASE;
              END IF;
              
              IF(shift_l = '1' OR shift_r = '1') THEN 
					-- We are not decoding the shifted values (no &, ^, etc)
					decoded_value <= x"00";
              ELSE                                     
			  CASE ps2_code IS 
					-- Decode the numbers
                  WHEN x"45" => decoded_value <= x"30"; --0
                  WHEN x"16" => decoded_value <= x"31"; --1
                  WHEN x"1E" => decoded_value <= x"32"; --2
                  WHEN x"26" => decoded_value <= x"33"; --3
                  WHEN x"25" => decoded_value <= x"34"; --4
                  WHEN x"2E" => decoded_value <= x"35"; --5
                  WHEN x"36" => decoded_value <= x"36"; --6
                  WHEN x"3D" => decoded_value <= x"37"; --7
                  WHEN x"3E" => decoded_value <= x"38"; --8
                  WHEN x"46" => decoded_value <= x"39"; --9
                  WHEN OTHERS => NULL;
                END CASE;
              END IF;              
            END IF;
          
          IF(break = '1') THEN  --the code is a make
			value <= "0000000"; -- Changed here in accordance to the pre-lab diagram
            state <= ready;      --proceed to next state
          ELSE                  --code is a break
            state <= output;       --return to a state to await next PS2 code
          END IF;
			
			-- Output the received value	
        WHEN output =>
			 -- If output has been assigned     
            new_value_received <= '1';
            value <= decoded_value(6 DOWNTO 0);   
			state <= ready; --The new state according to the pre-lab diagram should be ready                   
		end case;		
	end if;
end process PS2_DECODE;

-- Output shift and ctrl values
shift <= shift_l or shift_r;
ctrl <= ctrl_l or ctrl_r;

end Behavioral;

