library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity iir_lowpass is
    Port (
        clk   : in  STD_LOGIC;                     -- Clock signal
        reset : in  STD_LOGIC;                     -- Reset signal (active low)
        x     : in  STD_LOGIC_VECTOR(11 downto 0); -- 12-bit input audio signal
        alpha : in  STD_LOGIC_VECTOR(11 downto 0); -- 12-bit filter coefficient (alpha)
        y     : out STD_LOGIC_VECTOR(11 downto 0)  -- 12-bit output filtered signal
    );
end iir_lowpass;

architecture Behavioral of iir_lowpass is
	 signal state : std_logic;
    signal y_val : STD_LOGIC_VECTOR(11 downto 0) := (others => '0'); -- Initialize output signal
    signal y_prev : integer := 0; -- Previous output value

begin

    process(state, reset)
        variable wave_int : integer;
        variable alph_int : integer;
        variable y_next   : integer;
        variable c1, c2   : integer;
    begin
        if reset = '0' then
            -- Reset logic (active low)
            y_prev <= 0;
            y_val <= (others => '0');
        elsif rising_edge(state) then
            -- Convert inputs to integers
            wave_int := to_integer(unsigned(x));
            
				if (alpha < x"100") then
					alph_int := 0;
				else
					alph_int := to_integer(unsigned(alpha));
				end if;
				
            -- Compute intermediate values
            c1 := wave_int * (1+alph_int);
            c2 := y_prev * (4095 - alph_int);

            -- Compute next output value
            y_next := (c1 + c2)/4096; -- Division by 4096 (equivalent to right shift by 12 bits)

            -- Update previous output value
            y_prev <= y_next;

            -- Assign the output
            y_val <= std_logic_vector(to_unsigned(y_next, 12));
        end if;
    end process;

	 
	 
	 process(clk)
	 constant ticks: integer := 763;
	 variable count: integer range 0 to ticks := 0;
	 begin
			 if(rising_edge(clk)) then 
				  
				  count := count + 1;
				  
				  if(count < ticks/2) then 
						state <= '0';
				  elsif(count >= ticks/2) then 
						state <= '1';
						if(count = ticks) then count := 0; end if;
				  end if;
			 end  if;
	 end process;
	 
	 
	 
    -- Assign the output signal
    y <= y_val;

end Behavioral;