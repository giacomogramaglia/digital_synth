
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity clock_divider is
    generic(
        ticks : integer := 10
    ); 
	 Port ( 
        i_clk : in STD_LOGIC;
        o_clk : out STD_LOGIC
    );
end clock_divider;

architecture Behavioral of clock_divider is
signal state : std_LOGIC;

begin
process(i_clk)
variable count: integer range 0 to ticks := 0;
begin
    if(rising_edge(i_clk)) then 
        
		  count := count + 1;
        
		  if(count < ticks/2) then 
				state <= '0';
        elsif(count >= ticks/2) then 
            state <= '1';
				if(count = ticks) then count := 0; end if;
        end if;
    end  if;
end process;

o_clk <= state;

end Behavioral;