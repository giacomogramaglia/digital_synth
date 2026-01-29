library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Debounce is
    Port (
        clk         : in  STD_LOGIC;    -- Clock signal
        button_in   : in  STD_LOGIC;    -- Raw button input
        button_out  : out STD_LOGIC       -- Debounced button output
    );
end Debounce;

architecture Behavioral of Debounce is
     signal count       : INTEGER := 0;         -- Counter for debouncing
     signal stbl      : STD_LOGIC := '0';     -- Debounced output signal
     constant DEBOUNCE_LIMIT : INTEGER := 100000; -- Counter limit for debouncing

begin
    process(clk)
    begin    
        if rising_edge(clk) then
            if button_in = stbl then
                count <= 0;  -- Reset counter if stbl
            else
                count <= count + 1;  -- Increment counter if not stbl
                if count >= DEBOUNCE_LIMIT then
                    stbl <= button_in;  -- Update stbl signal
                end if;
            end if;
            button_out <= stbl;  -- Output the stbl signal
        end if;
    end process;
end Behavioral;