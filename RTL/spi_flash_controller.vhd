LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;

ENTITY spi_flash_controller IS
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
	 writing		  : OUT STD_LOGIC := '0'
	 );
END spi_flash_controller;

ARCHITECTURE behavior OF spi_flash_controller IS
  
  TYPE   state_type		is (IDLE, PAUSE, ASSIGN, READOUT, INITIATE_WR, PAUSE2, ASSIGN2, 
									READOUT2, PAUSE3, WRITE_ENABLE, FINISH_WREN, PAUSE4, ASSIGN3, 
									WRITE_LUT, ITERATE, DELAY_WREN, PAUSE5, WRENX0, WRENX1, WRENX2, WRENX3,
									BLER1, BLER2, BLER3, READOUT2c);
  SIGNAL spi_enable     : STD_LOGIC;
  SIGNAL spi_tx_data    : STD_LOGIC_VECTOR(47 DOWNTO 0);  -- Data to transmit
  SIGNAL spi_rx_data    : STD_LOGIC_VECTOR(47 DOWNTO 0);  -- Data received
  SIGNAL current_addr   : STD_LOGIC_VECTOR(23 DOWNTO 0);  -- Current address to read
  SIGNAL state          : state_type := IDLE;          	 -- State machine for reading 2 bytes
  SIGNAL busy				: STD_LOGIC;
  SIGNAL start_prev		: STD_LOGIC;
  SIGNAL cs_forced		: STD_LOGIC := '1';
  SIGNAL repeat			: STD_LOGIC;
  
COMPONENT spi_master IS
  GENERIC(
    slaves  : INTEGER := 4;  --number of spi slaves
    d_width : INTEGER := 2); --data bus width
  PORT(
    clock   : IN     STD_LOGIC;                             --system clock
    reset_n : IN     STD_LOGIC;                             --asynchronous reset
    enable  : IN     STD_LOGIC;                             --initiate transaction
    cpol    : IN  	STD_LOGIC;                        -- SPI clock polarity
    cpha    : IN  	STD_LOGIC;                        -- SPI clock phase
    cont    : IN     STD_LOGIC;                             --continuous mode command
    clk_div : IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
    addr    : IN     INTEGER;                               --address of slave
    tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
    miso    : IN     STD_LOGIC;                             --master in, slave out
    sclk    : BUFFER STD_LOGIC;                             --spi clock
    ss_n    : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
    mosi    : OUT    STD_LOGIC;                             --master out, slave in
    busy    : OUT    STD_LOGIC;                             --busy / data ready signal
    rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
END COMPONENT;

BEGIN

  -- Instantiate the SPI Master
  SPI_inst : spi_master
    GENERIC MAP(
      slaves  => 1,          -- Single slave (flash memory)
      d_width => 48           -- 8-bit data width
    )
    PORT MAP(
      clock   => clock,
      reset_n => reset_n,
      enable  => spi_enable,  -- Control SPI enable signal in state machine
      cpol    => '0',
      cpha    => '0',
      cont    => '0',         -- No continuous mode
      clk_div => 4,
      addr    => 0,           -- Single slave device (W25Q64)
      tx_data => spi_tx_data, -- Transmit address or dummy data
      miso    => miso,
      sclk    => sclk,
      ss_n    => open, -- Connect internal slave select vector
      mosi    => mosi,
      busy    => busy,        -- SPI busy status
      rx_data => spi_rx_data  -- Data received
    );

  -- Output the slave select as a single bit for external connection
  ss_n <= cs_forced;

  -- State machine for SPI communication with flash memory
  PROCESS(clock, reset_n)
  constant delay_CC: integer := 100;	-- short general purpose delay
  constant delay_CC1: integer := 400;	-- long general purpose delay
  constant delay_CC2: integer := 65;	-- 1 byte transmission	(WREN)
  constant delay_ERA: integer := 260; 	-- 4 byte tansmission	(BLER)
  constant delay_BIG: integer := 15000000; 
  constant delay_CC3: integer := 1000;
  variable delay   : integer range 0 to delay_BIG := 0;
    
  BEGIN
    IF reset_n = '0' THEN
      state <= IDLE;
      spi_enable <= '0';
      read_data <= (OTHERS => '0');
      current_addr <= (OTHERS => '0');
		cs_forced <= '1';

    ELSIF rising_edge(clock) THEN
	   CASE state IS
        WHEN IDLE =>  -- Idle, waiting for start signal
		     IF busy = '0' THEN 
					cs_forced <= '1';
					out_ready <= '1';
					
					
					IF start = '1' and start_prev = '0' and STORE_BTN = '1' THEN
						current_addr <= flash_addr;  -- Load start address
						state <= PAUSE;
						spi_enable <= '0';
						
						spi_tx_data <= x"03" & current_addr & x"FFFF"; 
						cs_forced <= '0';
						out_ready <= '0';
					
					ELSIF start = '1' and start_prev = '0' and STORE_BTN = '0' THEN
						flash_addr(16 downto 1) <= x"0000";
						spi_tx_data <= x"06FFFFFFFFFF";
						writing <= '1';
						state <= WRENX0;
						cs_forced <= '0';
						repeat <= '0';
					END IF;
					
			  END IF;
			
  		   WHEN PAUSE =>								-- stop transmission
				if  delay < delay_CC then
					delay := delay + 1;
				elsif delay = delay_CC then
					state <= ASSIGN;
					delay := 0;
				end if; 
		
		  WHEN ASSIGN =>
				state <= READOUT;
				spi_enable <= '1';
				
		  WHEN READOUT => 
				spi_enable <= '0';
				if busy = '0' then
					flash_addr(16 DOWNTO 1) <= flash_addr(16 DOWNTO 1) + STD_LOGIC_VECTOR(to_unsigned(freq, 14));
					state <= IDLE;
					read_data(15 downto 8) <= spi_rx_data(15 downto 8);
					read_data(7 downto 0) <= spi_rx_data(7 downto 0);
				end if;
		  
		  
		  WHEN WRENX0 =>	
				if  delay < delay_CC then
					delay 	:= delay + 1;		
				elsif delay = delay_CC then
					state 	<= WRENX1;
					delay 	:= 0;	
				end if; 
				
		  WHEN WRENX1 =>
				state <= WRENX2;
				spi_enable <= '1';
	
		  WHEN WRENX2 =>
				if  delay < delay_CC2 then
					spi_enable <= '0';
					delay 	:= delay + 1;			   
				elsif delay = delay_CC2 then
					state 	<= WRENX3;
					cs_forced <= '1';
					delay 	:= 0;											
				end if; 			  	
		
		  WHEN WRENX3 =>
				spi_enable <= '0';
				if busy = '0' then
					state <= BLER1;	
					cs_forced <= '0';
					if repeat = '0' then
						spi_tx_data <= x"D8" & x"020000" & x"FFFF"; 
					elsif repeat = '1' then
						spi_tx_data <= x"D8" & x"030000" & x"FFFF"; 
					end if;
				end if;	
		  
		  
		  WHEN BLER1 =>								-- stop transmission
				if  delay < delay_CC1 then
					delay 	:= delay + 1;		
				elsif delay = delay_CC1 then
					state 	<= BLER2;
					cs_forced <= '0';
					delay 	:= 0;	
					spi_enable <= '1';					
				end if; 		
			
		  WHEN BLER2 =>			
				if  delay < delay_ERA then
					spi_enable <= '0';
					delay 	:= delay + 1;			   
				elsif delay = delay_ERA then
					state 	<= BLER3;
					cs_forced <= '1';
					delay 	:= 0;											
				end if; 					
		
		
		  WHEN BLER3 => 
				spi_enable <= '0';
				if busy = '0' then
					if  delay < delay_BIG then
						delay 	:= delay + 1;			   
					elsif delay = delay_BIG then
					
						if repeat = '0' then
							spi_tx_data <= x"06FFFFFFFFFF";
							state <= WRENX0;
							repeat <= '1';
							cs_forced <= '0';
						else
							state 	<= INITIATE_WR;
							cs_forced <= '1';
						end if;
						delay 	:= 0;											
					end if; 							
				end if;	
				
		  
		  WHEN INITIATE_WR =>
				if busy = '0' then
					current_addr <= flash_addr;
					out_ready <= '0';
					spi_enable 	<= '0';				
					spi_tx_data <= x"03" & current_addr & x"FFFF"; 
					cs_forced 	<= '0';
					state 		<= PAUSE2;
				end if;
		  
		  WHEN PAUSE2 =>								-- stop transmission
				if  delay < delay_CC3 then
					delay 	:= delay + 1;
				elsif delay = delay_CC3 then
					state 	<= ASSIGN2;
					delay 	:= 0;
					spi_enable <= '1';
				end if; 

		  WHEN ASSIGN2 =>
				state <= READOUT2;
				spi_enable <= '0';
				
		  WHEN READOUT2 => 
				spi_enable <= '0';
				if busy = '0' then
					read_data(15 downto 8) <= spi_rx_data(15 downto 8);
					read_data(7 downto 0) <= spi_rx_data(7 downto 0);				
					state <= READOUT2c;
					cs_forced <= '1';
				end if;				
			
		  WHEN READOUT2c => 
				if busy = '0' then
					out_ready <= '1';
					--cs_forced <= '1';
					state <= PAUSE3;
				end if;
			
		  WHEN PAUSE3 =>								-- stop transmission
				if  delay < delay_CC1 then
					delay 	:= delay + 1;		
					spi_tx_data <= x"06FFFFFFFFFF"; 
					
				elsif delay = delay_CC1 then
					state 	<= PAUSE5;
					delay 	:= 0;	
					cs_forced <= '0';
				end if; 
			
		
	     WHEN PAUSE5 =>	
				if  delay < delay_CC then
					delay 	:= delay + 1;		
				elsif delay = delay_CC then
					state 	<= WRITE_ENABLE;
					delay 	:= 0;	
				end if; 
				
		  WHEN WRITE_ENABLE =>
				state <= DELAY_WREN;
				spi_enable <= '1';
	
		  WHEN DELAY_WREN =>
				if  delay < delay_CC2 then
					spi_enable <= '0';
					delay 	:= delay + 1;			   
				elsif delay = delay_CC2 then
					state 	<= FINISH_WREN;
					cs_forced <= '1';
					delay 	:= 0;											
				end if; 			  	
		
		  WHEN FINISH_WREN =>
				spi_enable <= '0';
				if busy = '0' then
					state <= PAUSE4;	
					cs_forced <= '0';
				end if;					
				  
			
			
		  WHEN PAUSE4 =>								-- stop transmission
				if  delay < delay_CC1 then
					delay 	:= delay + 1;		
					spi_tx_data <= x"02" & current_addr(23 downto 18) & '1' & current_addr(16 downto 0) & mix_in & x"0"; 
				   
				elsif delay = delay_CC1 then
					state 	<= ASSIGN3;
					cs_forced <= '0';
					delay 	:= 0;	
					spi_enable <= '1';					
				end if; 		
			
		  WHEN ASSIGN3 =>
				state <= WRITE_LUT;
				spi_enable <= '0';				
				
		  WHEN WRITE_LUT => 
				spi_enable <= '0';
				if busy = '0' then
					flash_addr(16 DOWNTO 1) <= flash_addr(16 DOWNTO 1) + 1;
					state <= ITERATE;	
					cs_forced <= '1';
				end if;					
		
		
		
	     WHEN ITERATE =>
				if  delay < delay_CC1 then
					delay 	:= delay + 1;			   
				elsif delay = delay_CC1 then
					delay 	:= 0;	
					if flash_addr(16 DOWNTO 1) = x"0000" then
						state <= IDLE;
						writing <= '0';
					else
						state <= INITIATE_WR;

					end if;												
				end if; 		
				
					
			
		  
		  WHEN OTHERS =>
			state <= IDLE;
			
		  END CASE;

		start_prev <= start;
    END IF;
  END PROCESS;
  
  flash_addr(23 DOWNTO 18) <= "000000";
  flash_addr(17) <= MODE_SW;
  flash_addr(0) <= '0';
  
END behavior;