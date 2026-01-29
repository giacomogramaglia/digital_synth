library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MIDI_interface is
    Port (
        clk         : in std_logic;
        reset       : in std_logic;       -- Reset button to clear received data and restart UART
        midi_rx     : in std_logic;
        frequency   : out integer range 0 to 16383;    -- Integer output frequency in Hertz
		  gate        : out std_logic);
end MIDI_interface;

architecture Behavioral of MIDI_interface is

    -- Constants
    constant MIDI_BAUD_RATE : integer := 31250;           -- Standard MIDI baud rate
    constant CLOCK_FREQ     : integer := 50000000;        -- System clock frequency (50 MHz)
    constant BIT_PERIOD     : integer := CLOCK_FREQ / MIDI_BAUD_RATE;  -- Clock cycles per MIDI bit

    -- State definitions
    type state_type is (IDLE, START, STATUS, IDLE1, START1, DATA1);
    signal state         : state_type := IDLE;

    -- Internal registers
    signal bit_count     : integer range 0 to 7 := 0;
    signal bit_timer     : integer range 0 to BIT_PERIOD - 1 := 0;
    signal shift_reg     : std_logic_vector(7 downto 0) := (others => '0');
    signal midi_note     : std_logic_vector(6 downto 0) := (others => '0');
    signal midi_note_1   : std_logic_vector(6 downto 0) := (others => '0');
	 signal gate_reg      : std_logic := '0';
	 signal timeout 		 : std_logic := '0';
	 signal start_flag	 : std_logic := '0';
	
begin
    -- Assign outputs
    gate <= gate_reg;

    -- Combined MIDI reception and processing with reset
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '0' or timeout = '1' then
                -- Clear all internal registers and set to initial values on reset
                state <= IDLE;
                bit_count <= 7;
                bit_timer <= 0;
                shift_reg <= (others => '0');
                midi_note <= (others => '0');
                gate_reg <= '0';
					 start_flag <= '0';
            else
                -- Normal operation
                case state is
                    when IDLE =>
						      start_flag <= '0';
								-- Waiting for MIDI start bit (low)
                        if midi_rx = '0' then
                            state <= START;
                            bit_timer <= BIT_PERIOD / 2;  -- Start in the middle of the start bit
                        end if;

                    when START =>
                        -- Start bit timing
                        if bit_timer = 0 then
                            state <= STATUS;
									 start_flag <= '1';
                            bit_count <= 7;
                            bit_timer <= BIT_PERIOD - 1;
                        else
                            bit_timer <= bit_timer - 1;
                        end if;

                    when STATUS =>
                        -- Shift in data bits
                        if bit_timer = 0 then
                            shift_reg(7-bit_count) <= midi_rx;
                            bit_timer <= BIT_PERIOD - 1;

                            -- If all 8 bits are received, go to stop bit
                            if bit_count = 0 then
										if shift_reg(7 downto 4) = "1000" then
                                state <= IDLE;
										  bit_count <= 7;
										  bit_timer <= BIT_PERIOD-1;  
										  gate_reg <= '0';
										
										elsif shift_reg(7 downto 4) = "1001" then
										  state <= IDLE1;
										  bit_count <= 7;
										  bit_timer <= BIT_PERIOD-1;
										  
										else
										  state <= IDLE;
										end if;
				
                            end if;
									 
									 bit_count <= bit_count - 1; 
                        else
                            bit_timer <= bit_timer - 1;
                        end if;

							when IDLE1 =>
						      start_flag <= '0';
								
								-- Waiting for MIDI start bit (low)
                        if midi_rx = '0' then
                            state <= START1;
                            bit_timer <= BIT_PERIOD / 2;  -- Start in the middle of the start bit
                        end if;
								
							when START1 =>
                        -- Start bit timing
                        if bit_timer = 0 then
                            state <= DATA1;
									 start_flag <= '1';
                            bit_count <= 7;
                            bit_timer <= BIT_PERIOD - 1;
                        else
                            bit_timer <= bit_timer - 1;
                        end if;	
								
                    when DATA1 =>
                        -- Verify stop bit and process the received byte
                        if bit_timer = 0 then
									bit_timer <= BIT_PERIOD-1;
									
									gate_reg <= '0';
									shift_reg(7-bit_count) <= midi_rx;
									
                           if bit_count = 0 then
										midi_note <= shift_reg(6 downto 0);
										gate_reg <= '1';
										state <= IDLE;
										bit_timer <= BIT_PERIOD-1;
										bit_count <= 7;
									end if;
									bit_count <= bit_count - 1; 
									
                        else
                            bit_timer <= bit_timer - 1;
                        end if;
								
                end case;
            end if;
        end if;
    end process;
	 
process(clk, start_flag) is
variable timeout_clk: integer := 0;
begin
if rising_edge(clk) then
	if start_flag = '1' then
		timeout_clk := timeout_clk + 1;
		if timeout_clk = 30*BIT_PERIOD then
			timeout_clk := 0;
			timeout <= '1';
		end if;
	else
		timeout_clk := 0;
		timeout <= '0';
	end if;
end if;
end process;	

midi_note_1 <= midi_note;


process(midi_note_1)
	begin
        case midi_note_1 is
            -- Low octave (0 to 11)
			when 	"0000000"	 => frequency <=	8	; 	-- Midi note	0
			when 	"0000001"	 => frequency <=	9	; 	-- Midi note	1
			when 	"0000010"	 => frequency <=	9	; 	-- Midi note	2
			when 	"0000011"	 => frequency <=	10	; 	-- Midi note	3
			when 	"0000100"	 => frequency <=	10	; 	-- Midi note	4
			when 	"0000101"	 => frequency <=	11	; 	-- Midi note	5
			when 	"0000110"	 => frequency <=	12	; 	-- Midi note	6
			when 	"0000111"	 => frequency <=	12	; 	-- Midi note	7
			when 	"0001000"	 => frequency <=	13	; 	-- Midi note	8
			when 	"0001001"	 => frequency <=	14	; 	-- Midi note	9
			when 	"0001010"	 => frequency <=	15	; 	-- Midi note	10
			when 	"0001011"	 => frequency <=	15	; 	-- Midi note	11
			when 	"0001100"	 => frequency <=	16	; 	-- Midi note	12
			when 	"0001101"	 => frequency <=	17	; 	-- Midi note	13
			when 	"0001110"	 => frequency <=	18	; 	-- Midi note	14
			when 	"0001111"	 => frequency <=	19	; 	-- Midi note	15
			when 	"0010000"	 => frequency <=	21	; 	-- Midi note	16
			when 	"0010001"	 => frequency <=	22	; 	-- Midi note	17
			when 	"0010010"	 => frequency <=	23	; 	-- Midi note	18
			when 	"0010011"	 => frequency <=	24	; 	-- Midi note	19
			when 	"0010100"	 => frequency <=	26	; 	-- Midi note	20
			when 	"0010101"	 => frequency <=	28	; 	-- Midi note	21
			when 	"0010110"	 => frequency <=	29	; 	-- Midi note	22
			when 	"0010111"	 => frequency <=	31	; 	-- Midi note	23
			when 	"0011000"	 => frequency <=	33	; 	-- Midi note	24
			when 	"0011001"	 => frequency <=	35	; 	-- Midi note	25
			when 	"0011010"	 => frequency <=	37	; 	-- Midi note	26
			when 	"0011011"	 => frequency <=	39	; 	-- Midi note	27
			when 	"0011100"	 => frequency <=	41	; 	-- Midi note	28
			when 	"0011101"	 => frequency <=	44	; 	-- Midi note	29
			when 	"0011110"	 => frequency <=	46	; 	-- Midi note	30
			when 	"0011111"	 => frequency <=	49	; 	-- Midi note	31
			when 	"0100000"	 => frequency <=	52	; 	-- Midi note	32
			when 	"0100001"	 => frequency <=	55	; 	-- Midi note	33
			when 	"0100010"	 => frequency <=	58	; 	-- Midi note	34
			when 	"0100011"	 => frequency <=	62	; 	-- Midi note	35
			when 	"0100100"	 => frequency <=	65	; 	-- Midi note	36
			when 	"0100101"	 => frequency <=	69	; 	-- Midi note	37
			when 	"0100110"	 => frequency <=	73	; 	-- Midi note	38
			when 	"0100111"	 => frequency <=	78	; 	-- Midi note	39
			when 	"0101000"	 => frequency <=	82	; 	-- Midi note	40
			when 	"0101001"	 => frequency <=	87	; 	-- Midi note	41
			when 	"0101010"	 => frequency <=	92	; 	-- Midi note	42
			when 	"0101011"	 => frequency <=	98	; 	-- Midi note	43
			when 	"0101100"	 => frequency <=	104	; 	-- Midi note	44
			when 	"0101101"	 => frequency <=	110	; 	-- Midi note	45
			when 	"0101110"	 => frequency <=	117	; 	-- Midi note	46
			when 	"0101111"	 => frequency <=	123	; 	-- Midi note	47
			when 	"0110000"	 => frequency <=	131	; 	-- Midi note	48
			when 	"0110001"	 => frequency <=	139	; 	-- Midi note	49
			when 	"0110010"	 => frequency <=	147	; 	-- Midi note	50
			when 	"0110011"	 => frequency <=	156	; 	-- Midi note	51
			when 	"0110100"	 => frequency <=	165	; 	-- Midi note	52
			when 	"0110101"	 => frequency <=	175	; 	-- Midi note	53
			when 	"0110110"	 => frequency <=	185	; 	-- Midi note	54
			when 	"0110111"	 => frequency <=	196	; 	-- Midi note	55
			when 	"0111000"	 => frequency <=	208	; 	-- Midi note	56
			when 	"0111001"	 => frequency <=	220	; 	-- Midi note	57
			when 	"0111010"	 => frequency <=	233	; 	-- Midi note	58
			when 	"0111011"	 => frequency <=	247	; 	-- Midi note	59
			when 	"0111100"	 => frequency <=	262	; 	-- Midi note	60
			when 	"0111101"	 => frequency <=	277	; 	-- Midi note	61
			when 	"0111110"	 => frequency <=	294	; 	-- Midi note	62
			when 	"0111111"	 => frequency <=	311	; 	-- Midi note	63
			when 	"1000000"	 => frequency <=	330	; 	-- Midi note	64
			when 	"1000001"	 => frequency <=	349	; 	-- Midi note	65
			when 	"1000010"	 => frequency <=	370	; 	-- Midi note	66
			when 	"1000011"	 => frequency <=	392	; 	-- Midi note	67
			when 	"1000100"	 => frequency <=	415	; 	-- Midi note	68
			when 	"1000101"	 => frequency <=	440	; 	-- Midi note	69
			when 	"1000110"	 => frequency <=	466	; 	-- Midi note	70
			when 	"1000111"	 => frequency <=	494	; 	-- Midi note	71
			when 	"1001000"	 => frequency <=	523	; 	-- Midi note	72
			when 	"1001001"	 => frequency <=	554	; 	-- Midi note	73
			when 	"1001010"	 => frequency <=	587	; 	-- Midi note	74
			when 	"1001011"	 => frequency <=	622	; 	-- Midi note	75
			when 	"1001100"	 => frequency <=	659	; 	-- Midi note	76
			when 	"1001101"	 => frequency <=	698	; 	-- Midi note	77
			when 	"1001110"	 => frequency <=	740	; 	-- Midi note	78
			when 	"1001111"	 => frequency <=	784	; 	-- Midi note	79
			when 	"1010000"	 => frequency <=	831	; 	-- Midi note	80
			when 	"1010001"	 => frequency <=	880	; 	-- Midi note	81
			when 	"1010010"	 => frequency <=	932	; 	-- Midi note	82
			when 	"1010011"	 => frequency <=	988	; 	-- Midi note	83
			when 	"1010100"	 => frequency <=	1047	; 	-- Midi note	84
			when 	"1010101"	 => frequency <=	1109	; 	-- Midi note	85
			when 	"1010110"	 => frequency <=	1175	; 	-- Midi note	86
			when 	"1010111"	 => frequency <=	1245	; 	-- Midi note	87
			when 	"1011000"	 => frequency <=	1319	; 	-- Midi note	88
			when 	"1011001"	 => frequency <=	1397	; 	-- Midi note	89
			when 	"1011010"	 => frequency <=	1480	; 	-- Midi note	90
			when 	"1011011"	 => frequency <=	1568	; 	-- Midi note	91
			when 	"1011100"	 => frequency <=	1661	; 	-- Midi note	92
			when 	"1011101"	 => frequency <=	1760	; 	-- Midi note	93
			when 	"1011110"	 => frequency <=	1865	; 	-- Midi note	94
			when 	"1011111"	 => frequency <=	1976	; 	-- Midi note	95
			when 	"1100000"	 => frequency <=	2093	; 	-- Midi note	96
			when 	"1100001"	 => frequency <=	2217	; 	-- Midi note	97
			when 	"1100010"	 => frequency <=	2349	; 	-- Midi note	98
			when 	"1100011"	 => frequency <=	2489	; 	-- Midi note	99
			when 	"1100100"	 => frequency <=	2637	; 	-- Midi note	100
			when 	"1100101"	 => frequency <=	2794	; 	-- Midi note	101
			when 	"1100110"	 => frequency <=	2960	; 	-- Midi note	102
			when 	"1100111"	 => frequency <=	3136	; 	-- Midi note	103
			when 	"1101000"	 => frequency <=	3322	; 	-- Midi note	104
			when 	"1101001"	 => frequency <=	3520	; 	-- Midi note	105
			when 	"1101010"	 => frequency <=	3729	; 	-- Midi note	106
			when 	"1101011"	 => frequency <=	3951	; 	-- Midi note	107
			when 	"1101100"	 => frequency <=	4186	; 	-- Midi note	108
			when 	"1101101"	 => frequency <=	4435	; 	-- Midi note	109
			when 	"1101110"	 => frequency <=	4699	; 	-- Midi note	110
			when 	"1101111"	 => frequency <=	4978	; 	-- Midi note	111
			when 	"1110000"	 => frequency <=	5274	; 	-- Midi note	112
			when 	"1110001"	 => frequency <=	5588	; 	-- Midi note	113
			when 	"1110010"	 => frequency <=	5920	; 	-- Midi note	114
			when 	"1110011"	 => frequency <=	6272	; 	-- Midi note	115
			when 	"1110100"	 => frequency <=	6645	; 	-- Midi note	116
			when 	"1110101"	 => frequency <=	7040	; 	-- Midi note	117
			when 	"1110110"	 => frequency <=	7459	; 	-- Midi note	118
			when 	"1110111"	 => frequency <=	7902	; 	-- Midi note	119
			when 	"1111000"	 => frequency <=	8372	; 	-- Midi note	120
			when 	"1111001"	 => frequency <=	8870	; 	-- Midi note	121
			when 	"1111010"	 => frequency <=	9397	; 	-- Midi note	122
			when 	"1111011"	 => frequency <=	9956	; 	-- Midi note	123
			when 	"1111100"	 => frequency <=	10548	; 	-- Midi note	124
			when 	"1111101"	 => frequency <=	11175	; 	-- Midi note	125
			when 	"1111110"	 => frequency <=	11840	; 	-- Midi note	126
			when 	"1111111"	 => frequency <=	12544	; 	-- Midi note	127		  
            when others => frequency <= 0;        -- Default case
        end case;
    end process;
	
end Behavioral;