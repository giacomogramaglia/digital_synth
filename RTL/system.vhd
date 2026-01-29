library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity system is
    Port (
		  -- SYSTEM INPUT PINS
        clk,rst		: in  STD_LOGIC;   
		 
		  -- UTILITY SWITCHES AND LEDS
		  MODE_SW		: in  STD_LOGIC;
		  STORE_BTN		: in  STD_LOGIC;
		 
		  -- MIDI PINS
		  MIDI_in		: in  STD_LOGIC;
		  MIDI_LED		: out STD_LOGIC;
		  
		  -- ATMEGA CONNECTIONS
		  ATMEGA_int0	: out STD_LOGIC;
		  ATMEGA_int1	: out STD_LOGIC;

		  -- ADC I2C PINS 
        I2C_SDA 		: inout STD_LOGIC;
		  I2C_SCL 		: inout STD_LOGIC; 
		  
		  -- DAC SPI PINS
		  CS_DAC			: out STD_LOGIC;
		  MOSI_DAC_a 	: out STD_LOGIC;
		  MOSI_DAC_b	: out STD_LOGIC;
		  SPI_SCL_DAC	: out STD_LOGIC;
		  
		  -- FLASH SPI PINS
		  CS_FLASH		: out STD_LOGIC;
		  MOSI_FLASH 	: out STD_LOGIC;
		  MISO_FLASH	: in STD_LOGIC;
		  SPI_SCL_FLASH: out STD_LOGIC
	 );
end system;

architecture Behavioral of system is

signal rst_deb		: STD_LOGIC;
signal sampl_clk	: STD_LOGIC;
signal LUT_clk		: STD_LOGIC;
signal a0,a1,a2,a3,a4,a5,a6,a7: STD_LOGIC_VECTOR(11 DOWNTO 0) := x"000";
signal mem_1  		: STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
signal freq 		: integer := 0;
signal dac_buf		: STD_LOGIC_VECTOR(0 DOWNTO 0)  := "0";
signal flash_addr	: STD_LOGIC_VECTOR(23 DOWNTO 0) := x"000000";  
signal MIDI_note  : STD_LOGIC_VECTOR(6 downto 0);
signal MIDI_gate  : STD_LOGIC;
signal out_ready 	: STD_LOGIC;
signal DAC_data_a : STD_LOGIC_VECTOR(11 downto 0) := x"800";
signal DAC_data_b : STD_LOGIC_VECTOR(11 downto 0) := x"800";
signal wave_out	: STD_LOGIC_VECTOR(11 downto 0) := x"800";
signal filter_out	: STD_LOGIC_VECTOR(11 downto 0) := x"800";
signal filter_alpha:STD_LOGIC_VECTOR(11 downto 0) := x"800";
signal LFO_out		: STD_LOGIC_VECTOR(11 downto 0) := x"800";

signal writing		: STD_LOGIC;

-- clock_divider COMPONENT DECLARATION
component clock_divider is
    generic(
        ticks : integer := 10
    ); 
	 Port ( 
        i_clk : in STD_LOGIC;
        o_clk : out STD_LOGIC
    );
end component; 
  
-- Debounce COMPONENT DECLARATION
COMPONENT Debounce is
    Port (
        clk         : in  STD_LOGIC;    -- Clock signal
        button_in   : in  STD_LOGIC;    -- Raw button input
        button_out  : out STD_LOGIC       -- Debounced button output
    );
end COMPONENT;
  
-- MIDI_interface COMPONENT DECLARATION
component MIDI_interface is
    Port (
        clk         : in std_logic;
        reset       : in std_logic;       -- Reset button to clear received data and restart UART
        midi_rx     : in std_logic;
        frequency   : out integer range 0 to 16383;    -- Integer output frequency in Hertz
		  gate        : out std_logic);
end component;
  
-- pmod_dac COMPONENT DECLARATION
COMPONENT pmod_dac IS
	  GENERIC(
		 clk_freq    : INTEGER := 50;  --system clock frequency in MHz
		 spi_clk_div : INTEGER := 2);  --spi_clk_div = clk_freq/60 (answer rounded up)
	  PORT(
		 clk        : IN      STD_LOGIC;                      --system clock
		 reset_n    : IN      STD_LOGIC;                      --active low asynchronous reset
		 dac_tx_ena : IN      STD_LOGIC;                      --enable transaction with DACs
		 dac_data_a : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC A
		 dac_data_b : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC B
		 busy       : OUT     STD_LOGIC;                      --indicates when transactions with DACs can be initiated
		 mosi_a     : OUT     STD_LOGIC;                      --SPI bus to DAC A: master out, slave in (DIN A)
		 mosi_b     : OUT     STD_LOGIC;                      --SPI bus to DAC B: master out, slave in (DIN B)
		 sclk       : BUFFER  STD_LOGIC;                      --SPI bus to DAC: serial clock (SCLK)
		 ss_n       : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0));  --SPI bus to DAC: slave select (~SYNC)
END COMPONENT;

-- i2c_controller COMPONENT DECLARATION
component i2c_controller is
    Port (
        -- PHYSICAL PINS
		  clk              : in  STD_LOGIC;                     -- FPGA clock (50 MHz)
        reset            : in  STD_LOGIC;                     -- Reset signal
        sda              : inout STD_LOGIC;                   -- I2C data line
        scl              : inout STD_LOGIC;                   -- I2C clock line
        ena				    : out STD_LOGIC;
		  
		  -- ANALOG INPUTS
		  ain_0        : out STD_LOGIC_VECTOR(11 downto 0); -- Read data from conversion register
		  ain_1        : out STD_LOGIC_VECTOR(11 downto 0); -- Read data from conversion register
		  ain_2        : out STD_LOGIC_VECTOR(11 downto 0); -- Read data from conversion register
		  ain_3        : out STD_LOGIC_VECTOR(11 downto 0); -- Read data from conversion register
	  	  ain_4        : out STD_LOGIC_VECTOR(11 downto 0); -- Read data from conversion register
		  ain_5        : out STD_LOGIC_VECTOR(11 downto 0); -- Read data from conversion register
		  ain_6        : out STD_LOGIC_VECTOR(11 downto 0); -- Read data from conversion register
		  ain_7        : out STD_LOGIC_VECTOR(11 downto 0)  -- Read data from conversion register
    );
end component;

-- spi_flash_controller COMPONENT DECLARATION
COMPONENT spi_flash_controller IS
  PORT(
    clock        : IN  STD_LOGIC;                        -- System clock
    reset_n      : IN  STD_LOGIC;                        -- Asynchronous reset
    start        : IN  STD_LOGIC;                        -- Start signal for the SPI transaction
	 MODE_SW		  : in  STD_LOGIC;
	 STORE_BTN    : in  STD_LOGIC;
    flash_addr   : BUFFER  STD_LOGIC_VECTOR(23 DOWNTO 0) := x"000000";    -- Start address for the flash memory
    miso         : IN  STD_LOGIC;                        -- Master in, slave out
    sclk         : OUT STD_LOGIC;                        -- SPI clock
    ss_n         : OUT STD_LOGIC;                        -- Slave select (single slave)
    mosi         : OUT STD_LOGIC;                        -- Master out, slave in
    read_data    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);     -- Two bytes of read data
    out_ready 	  : BUFFER STD_LOGIC;
	 freq			  : IN  INTEGER;
	 mix_in		  : IN  STD_LOGIC_VECTOR(11 DOWNTO 0);
	 writing		  : OUT STD_LOGIC
	);
END COMPONENT;

-- waveforms COMPONENT DECLARATION
COMPONENT waveforms IS
	 Port ( 
        address  : in  STD_LOGIC_VECTOR(15 downto 0);
		  shape	  : in  STD_LOGIC_VECTOR(11 downto 0);
		  in_sine  : in  STD_LOGIC_VECTOR(11 downto 0);
		  out_mix  : out STD_LOGIC_VECTOR(11 downto 0);
		  out_sqr  : out STD_LOGIC
    );
END COMPONENT;

-- ADSR_VCA COMPONENT DECLARATION
COMPONENT ADSR_VCA is
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
END COMPONENT;

-- iir_lowpass COMPONENT DECLARATION
COMPONENT iir_lowpass is
    Port (
        clk   : in  STD_LOGIC;                     -- Clock signal
        reset : in  STD_LOGIC;                     -- Reset signal
        x     : in  STD_LOGIC_VECTOR(11 downto 0); -- 12-bit input audio signal
        alpha : in  STD_LOGIC_VECTOR(11 downto 0); -- 12-bit filter coefficient (alpha)
        y     : out STD_LOGIC_VECTOR(11 downto 0)  -- 12-bit output filtered signal
    );
end COMPONENT;

-- LFO COMPONENT DECLARATION
COMPONENT LFO is
    Port (
        clk     : in  STD_LOGIC;                     -- 50 MHz clock
        freq    : in  STD_LOGIC_VECTOR(11 downto 0); -- Frequency control input
        LFO_out : out STD_LOGIC_VECTOR(11 downto 0)  -- 12-bit triangle wave output
    );
end COMPONENT;


begin

clk1: clock_divider generic map(
	ticks 		=> 763)
	port map(
	i_clk 		=> clk,
	o_clk 		=> LUT_clk);

deb1: debounce port map(
	clk 			=> clk,
	button_in 	=> rst,
	button_out 	=> rst_deb);
	
MIDI1: MIDI_interface port map(
	clk 			=> clk,
	reset			=> rst_deb,
	midi_rx  	=> MIDI_in,
	frequency	=> freq,
	gate			=> MIDI_gate);	

ADC1: i2c_controller port map(
	clk			=> clk,
	reset			=> rst_deb,
	sda			=> i2c_SDA,
	scl			=> i2c_SCL,
	ena			=> open,
	ain_0			=> a0,
	ain_1			=> a1,
	ain_2			=> a2,
	ain_3			=> a3,
	ain_4			=> a4,
	ain_5			=> a5,
	ain_6			=> a6,
	ain_7			=> a7);
  
DAC1: pmod_dac port map(
	clk 			=> clk,
	reset_n 		=> rst_deb,
	dac_tx_ena 	=> out_ready,
	dac_data_a 	=> DAC_data_a,
	dac_data_b 	=> DAC_data_b,
	busy			=> open,
	mosi_a 		=> MOSI_DAC_a,
	mosi_b 		=> MOSI_DAC_b,
	sclk 			=> SPI_SCL_DAC,
	ss_n 			=> dac_buf);
  
MEM1: spi_flash_controller port map(
	clock 		=> clk,
	reset_n 		=> rst_deb,
	start  		=> LUT_clk,
	MODE_SW		=> MODE_SW,
	STORE_BTN 	=> STORE_BTN,
   flash_addr  => flash_addr,
   miso        => MISO_FLASH,
   sclk        => SPI_SCL_FLASH,
   ss_n        => CS_FLASH,
   mosi        => MOSI_FLASH,
   read_data   => mem_1,
	out_ready	=> out_ready,
	freq			=> freq,
	mix_in		=> filter_out,
	writing		=> ATMEGA_int1);
 
WAV1: waveforms port map(
	address		=> flash_addr(16 downto 1),
	shape			=> a0,
	in_sine		=> mem_1(15 downto 4),
	out_mix		=> wave_out,
	out_sqr		=> ATMEGA_int0);
 
 
ADSR1: ADSR_VCA port map(
	clk    		=> clk,   
	gate      	=> MIDI_gate,
	attack    	=> a7,
	decay     	=> a6,
	sustain   	=> a5,
	release   	=> a4,
	audio_in   	=> filter_out,
	audio_out 	=> DAC_data_b,
	adsr_out		=> open);
 
iir1: iir_lowpass port map(
	clk 			=> clk,
	reset			=> rst_deb,
	x				=> wave_out,
	alpha			=> filter_alpha,
	y				=> filter_out);

	
LFO1: LFO port map(
	clk			=> clk,
	freq			=> a3,
	LFO_out		=> LFO_out);
 

process(clk, a1, a2, LFO_out)
variable product:	unsigned(23 downto 0);
variable scaled_prod: unsigned(11 downto 0);
begin
	if (a2 > x"200") then
		product := unsigned(a2)*(unsigned(LFO_out) - x"800");
		scaled_prod := product(23 downto 12);
	else
		scaled_prod := x"000";
	end if;
	filter_alpha <= std_LOGIC_VECTOR(unsigned(a1) + scaled_prod);
end process;


DAC_data_a <= filter_out;
CS_DAC <= dac_buf(0);
midI_LED <= not midi_in;


end Behavioral;