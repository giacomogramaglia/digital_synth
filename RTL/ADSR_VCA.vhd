library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADSR_VCA is
    Port (
        clk       : in  std_logic;                      -- 50 MHz clock
        gate      : in  std_logic;                      -- Gate signal to trigger ADSR
        attack    : in  std_logic_vector(11 downto 0);  -- Attack time (0 to 2 seconds)
        decay     : in  std_logic_vector(11 downto 0);  -- Decay time (0 to 2 seconds)
        sustain   : in  std_logic_vector(11 downto 0);  -- Sustain level (0 to 4095)
        release   : in  std_logic_vector(11 downto 0);  -- Release time (0 to 2 seconds)
        audio_in  : in  std_logic_vector(11 downto 0);  -- Audio input (12-bit)
        audio_out : out std_logic_vector(11 downto 0);  -- Audio output (12-bit)
		  adsr_out  : out std_logic_vector(11 downto 0)
    );
end ADSR_VCA;

architecture Behavioral of ADSR_VCA is
    -- Constants
    constant CLK_FREQ   : integer := 50_000_000;  -- 50 MHz clock frequency
    constant MAX_TIME   : integer := 2 * CLK_FREQ; -- 2 seconds in clock cycles
    constant MAX_AMPL   : integer := 4095;        -- Maximum amplitude (12-bit)

    -- Internal signals
    signal adsr_clk		: std_logic := '0';
	 
	 signal envelope     : integer range -MAX_AMPL to 2*MAX_AMPL := 0;  -- Current envelope value
    signal phase        : integer range 0 to 3 := 0;         -- ADSR phase (0: Attack, 1: Decay, 2: Sustain, 3: Release)
    signal counter      : integer := 0;                      -- Counter for timing
    signal attack_inc   : integer := 0;                      -- Attack increment per clock cycle
    signal decay_dec    : integer := 0;                      -- Decay decrement per clock cycle
    signal release_dec  : integer := 0;                      -- Release decrement per clock cycle
	 signal product		: std_logic_vector(31 downto 0);

begin
    -- Process to calculate envelope
    process(adsr_clk)
    begin
        if rising_edge(adsr_clk) then
            -- Calculate increments/decrements based on input parameters
            attack_inc  <= 256 - to_integer(unsigned(attack(11 downto 4)));
            decay_dec   <= 256 - to_integer(unsigned(decay(11 downto 4)));
            release_dec <= 256 - to_integer(unsigned(release(11 downto 4)));

            -- ADSR state machine
            case phase is
                when 0 =>  -- Attack phase
                    if gate = '1' then
                        if envelope < MAX_AMPL - attack_inc then
                            envelope <= envelope + attack_inc;
                        else
                            envelope <= MAX_AMPL;
                            phase <= 1;  -- Move to Decay phase
                        end if;
                    else
                        phase <= 3;  -- Move to Release phase if gate is off
                    end if;

                when 1 =>  -- Decay phase
                    if gate = '1' then
                        if envelope > to_integer(unsigned(sustain)) then
                            envelope <= envelope - decay_dec;
                        else
                            envelope <= to_integer(unsigned(sustain));
                            phase <= 2;  -- Move to Sustain phase
                        end if;
                    else
                        phase <= 3;  -- Move to Release phase if gate is off
                    end if;

                when 2 =>  -- Sustain phase
                    if gate = '0' then
                        phase <= 3;  -- Move to Release phase if gate is off
                    end if;

                when 3 =>  -- Release phase
                    if envelope > release_dec  and gate = '0' then
                        envelope <= envelope - release_dec;
                    elsif envelope > 0  and gate = '1' then
                        phase <= 0;  -- Reset to Attack phase					
						  else
							   envelope <= 0;
                        phase <= 0;  -- Reset to Attack phase
                    end if;

                when others =>
                    phase <= 0;  -- Default to Attack phase
            end case;
        end if;
    end process; 
	 
	 process(clk)
		constant ticks: integer := 25000;
		variable count: integer range 0 to ticks := 0;
		begin
			 if(rising_edge(clk)) then 
				  
				  count := count + 1;
				  
				  if(count < ticks/2) then 
						adsr_clk <= '0';
				  elsif(count >= ticks/2) then 
						adsr_clk <= '1';
						if(count = ticks) then count := 0; end if;
				  end if;
			 end  if;
	 end process;
	 
	 process(audio_in, envelope)
		variable m: integer;
		variable result: integer;
		begin
			m := to_integer(unsigned(audio_in)) - 2048;
			result := m * envelope + 8386560;
			product <= std_logic_vector(to_unsigned(result, 32));
	 end process;

    -- Apply envelope to audio input
    audio_out <= product(23 downto 12);
	 adsr_out <= std_logic_vector(to_unsigned(envelope, 12));
end Behavioral;