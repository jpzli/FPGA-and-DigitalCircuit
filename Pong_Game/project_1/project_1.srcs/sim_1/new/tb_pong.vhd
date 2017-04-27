----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2016 10:03:50 AM
-- Design Name: 
-- Module Name: tb_pong - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_pong is
--  Port ( );
end tb_pong;

architecture Behavioral of tb_pong is
component pong
    Port ( blue : out STD_LOGIC_VECTOR (3 downto 0);
       green : out STD_LOGIC_VECTOR (3 downto 0);
       red : out STD_LOGIC_VECTOR (3 downto 0);
       LEDs: out STD_LOGIC_VECTOR(7 downto 0);
       AN1 : out STD_LOGIC;
       AN2 : out STD_LOGIC;
       AN3 : out STD_LOGIC;
       AN4 : out STD_LOGIC;
       CA : out STD_LOGIC;
       CB : out STD_LOGIC;
       CC : out STD_LOGIC;
       CD : out STD_LOGIC;
       CE : out STD_LOGIC;
       CF : out STD_LOGIC;
       CG : out STD_LOGIC;
       DP : out STD_LOGIC;
       hsync : out STD_LOGIC;
       vsync : out STD_LOGIC;
       BTN0 : in STD_LOGIC;
       clk : in STD_LOGIC;
       ps2_clk : in STD_LOGIC;
       ps2_data : in STD_LOGIC);
end component;

signal blue: std_logic_vector(3 downto 0);
signal red: std_logic_vector(3 downto 0);
signal green: std_logic_vector(3 downto 0);
signal LEDs: STD_LOGIC_VECTOR(7 downto 0);
signal AN1 : STD_LOGIC;
signal AN2 : STD_LOGIC;
signal AN3 : STD_LOGIC;
signal AN4 : STD_LOGIC;
signal CA : STD_LOGIC;
signal CB : STD_LOGIC;
signal CC : STD_LOGIC;
signal CD : STD_LOGIC;
signal CE : STD_LOGIC;
signal CF : STD_LOGIC;
signal CG : STD_LOGIC;
signal DP : STD_LOGIC;
signal hsync : STD_LOGIC;
signal vsync : STD_LOGIC;
signal reset : STD_LOGIC;
signal clk : STD_LOGIC;
signal ps2_clk : STD_LOGIC;
signal ps2_data : STD_LOGIC;

signal code_to_send : std_logic_vector(7 downto 0);
signal send_code: std_logic;
signal code: std_logic_vector(7 downto 0);

constant clk_period: time:= 10 ns;
constant ps2_clk_period: time:= 100 us; 
    
begin
    uut: pong port map(
    clk => clk,
    BTN0 => reset,
    ps2_clk => ps2_clk,
    ps2_data => ps2_data,
    hsync => hsync,
    vsync => vsync,
    blue => blue,
    green => green,
    red => red,
    LEDs => LEDs,
    AN1 => AN1,
    AN2 => AN2,
    AN3 => AN3,
    AN4 => AN4,
    CA => CA,
    CB => CB,
    CC => CC,
    CD => CD,
    CE => CE,
    CF => CF,
    CG => CG,
    DP => DP
    );
    
clk_process: process
    begin
    clk <= '0';
    wait for clk_period /2;
    clk <= '1';
    wait for clk_period /2;
end process;

reset_process: process
    begin
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait;
end process;

stim_proc: process
    begin
    --Player 1 down command
    code_to_send <= "00011011";
    send_code <= '1';
    wait for clk_period * 2;
    send_code <= '0';
    wait for 1500 us;
    
    --Release Key
    code_to_send <= "11110000";
    send_code <= '1';
    wait for clk_period * 2;
    send_code <= '0';
    wait for 1500 us;
    
    code_to_send <= "00011011";
    send_code <= '1';
    wait for clk_period * 2;
    send_code <= '0';
    wait for 1500 us;
   
   --Player 1 up command
    code_to_send <= "00011101";
    send_code <= '1';
    wait for clk_period * 2;
    send_code <= '0';
    wait for 1500 us;
    
    --Release Key
    code_to_send <= "11110000";
    send_code <= '1';
    wait for clk_period * 2;
    send_code <= '0';
    wait for 1500 us;
    
    code_to_send <= "00011101";
    send_code <= '1';
    wait for clk_period * 2;
    send_code <= '0';
    wait for 1500 us;
    
    --Player 2 down command
        code_to_send <= "01000010";
        send_code <= '1';
        wait for clk_period * 2;
        send_code <= '0';
        wait for 1500 us;
        
        --Release Key
        code_to_send <= "11110000";
        send_code <= '1';
        wait for clk_period * 2;
        send_code <= '0';
        wait for 1500 us;
        
        code_to_send <= "01000010";
        send_code <= '1';
        wait for clk_period * 2;
        send_code <= '0';
        wait for 1500 us;
       
       --Player 2 up command
        code_to_send <= "01000011";
        send_code <= '1';
        wait for clk_period * 2;
        send_code <= '0';
        wait for 1500 us;
        
        --Release Key
        code_to_send <= "11110000";
        send_code <= '1';
        wait for clk_period * 2;
        send_code <= '0';
        wait for 1500 us;
        
        code_to_send <= "01000011";
        send_code <= '1';
        wait for clk_period * 2;
        send_code <= '0';
        wait for 1500 us;
        
        --Test caps lock:
        code_to_send <= "01011000";
        send_code <= '1';
        wait for clk_period *2;
        send_code <= '0';
        wait for 1500 us;
        code_to_send <= "11110000";
        send_code <= '1';
        wait for clk_period*2;
        send_code <= '0';
        wait for 1500 us;
        code_to_send <= "01011000";
        send_code <= '1';
        wait for clk_period*2;
        send_code <= '0';
        wait for 1500 us;
        
         code_to_send <= "00011101";
           send_code <= '1';
           wait for clk_period * 2;
           send_code <= '0';
           wait for 1500 us;
           
           --Release Key
           code_to_send <= "11110000";
           send_code <= '1';
           wait for clk_period * 2;
           send_code <= '0';
           wait for 1500 us;
           
           code_to_send <= "00011101";
           send_code <= '1';
           wait for clk_period * 2;
           send_code <= '0';
           wait for 1500 us;
        
        code_to_send <= "01011000";
        send_code <= '1';
        wait for clk_period * 2;
        send_code <= '0';
        wait for 1500 us;
end process;

send_code_ps2: process
begin
wait for clk_period;
ps2_clk <= '1';
code <= code_to_send;
if (send_code = '1') then
    ps2_data <= '0';                -- START BIT
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
     end if;
end process;

end Behavioral;
