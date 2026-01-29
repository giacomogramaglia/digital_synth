library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity LFO is
    Port (
        clk     : in  STD_LOGIC;                     -- 50 MHz clock
        freq    : in  STD_LOGIC_VECTOR(11 downto 0); -- Frequency control input
        LFO_out : out STD_LOGIC_VECTOR(11 downto 0)  -- 12-bit triangle wave output
    );
end LFO;

architecture Behavioral of LFO is
    signal tri_wave : STD_LOGIC_VECTOR(11 downto 0) := (others => '0'); -- Triangle wave signal
    signal index    : STD_LOGIC_VECTOR(23 downto 0) := (others => '0'); -- 24-bit index for finer frequency control
    signal step     : STD_LOGIC_VECTOR(23 downto 0);                    -- Step size for frequency control
    signal dir      : STD_LOGIC := '0';                                 -- Direction: 0 = increment, 1 = decrement
    signal clk_div  : INTEGER := 0;                                     -- Clock divider counter
    constant CLK_FREQ : INTEGER := 50000000;                            -- 50 MHz clock frequency
begin

    -- Calculate step size based on the desired frequency
    step <= std_logic_vector(to_unsigned((to_integer(unsigned(freq)) * 4096 + 1) / 32, 24));

    -- Clock process to update the index and generate the triangle wave
    process(clk)
    begin
        if rising_edge(clk) then
            -- Clock divider to reduce the 50 MHz clock to a lower frequency
            if clk_div < CLK_FREQ / 256 then -- Divide clock to 1 kHz
                clk_div <= clk_div + 1;
            else
                clk_div <= 0;

                -- Update index based on direction
                if dir = '0' then
                    index <= index + step; -- Increment index
                else
                    index <= index + step; -- Decrement index
                end if;

                -- Reverse direction at the boundaries
                if index >= x"FFFFF" then -- Upper boundary
                    dir <= '1';
                elsif index <= x"00000" then -- Lower boundary
                    dir <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Generate triangle wave based on the index value
    process(index, dir)
    begin
        if dir = '0' then
            -- Rising edge of triangle wave
            tri_wave <= index(23 downto 12);
        else
            -- Falling edge of triangle wave
            tri_wave <= x"FFF" - index(23 downto 12);
        end if;
    end process;

    -- Output the triangle wave
    LFO_out <= tri_wave;

end Behavioral;