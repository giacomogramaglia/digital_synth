-------------------------------------------------------------------------------
--
--   FileName:         	i2c_controller.vhd
--   Author:				Giacomo Gramaglia
--   Design Software:  	Quartus II
--
--   
--	  Code that encapsulates the i2c_master, interfacing an ADS1115
--   ADC and setting the data to write to/ read from its registers.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- Needed for arithmetic on std_logic_vector

entity i2c_controller is
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
end i2c_controller;

architecture Behavioral of i2c_controller is
    signal enable       		: STD_LOGIC;                     -- Enable      
    signal rw                 : STD_LOGIC;  
    signal data_wr      		: STD_LOGIC_VECTOR(7 downto 0); -- Data to write (Config, LO_THRESH, HI_THRESH)
    signal data_received      : STD_LOGIC_VECTOR(15 downto 0); -- Data received from ADS1115
    signal busy, busy_prev 	: STD_LOGIC := '1';               -- busy signal from I2C master
	 signal finish					: STD_LOGIC;
	 signal addr					: STD_LOGIC_VECTOR(6 downto 0);
	 signal data_buffer 			: STD_LOGIC_VECTOR(15 downto 0);
	 
	 signal in_sel	: integer range 0 to 7;
	 
    -- Instantiate the I2C Master module
 COMPONENT i2c_master IS
  GENERIC(
    input_clk : INTEGER := 100000000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 400000);   --speed the i2c bus (scl) will run at in Hz
  PORT(
    clk       : IN     STD_LOGIC;                    --system clock
    reset_n   : IN     STD_LOGIC;                    --active low reset
    ena       : IN     STD_LOGIC;                    --latch in command
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
    data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
    busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
    finish    : out std_logic; 
    data_rd   : OUT    STD_LOGIC_VECTOR(15 DOWNTO 0); --data read from slave
    ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
END COMPONENT;

    -- States for the controller
    type state_type is (CONFIG_REG, CALL_CONV, READ_CONV, CHANGE_POT);
    signal state : state_type := CONFIG_REG;

begin
    -- Instance of the I2C Master
    i2c_inst: i2c_master generic map(
				input_clk => 50000000,
				bus_clk => 200000)
	 port map (
            clk         => clk,
            reset_n     => reset,
            ena         => enable,
            addr        => addr,
            rw          => rw,
            data_wr     => data_wr,
            busy        => busy,
            finish      => finish,
				data_rd     => data_received,
				ack_error	=> open,
            sda         => sda,
            scl         => scl);

 
---------------------------------------------------------------
--			! STATE MACHINE !
---------------------------------------------------------------
  
    process(clk, reset)
	 constant delay_CC: integer := 1000;
	 constant delay_CC1: integer := 100000;
	 variable busy_cnt: integer range 0 to 4 := 0;
	 variable delay   : integer range 0 to delay_CC1 := 0;
	 begin  
		  if reset = '0' then
		  
            state <= CONFIG_REG;
            enable <= '0';  
				busy_cnt := 0;
            data_wr <= (others => '0');  -- Clear data
        elsif rising_edge(clk) then
           busy_prev <= busy;
			  
			  case state is
					
-------------------------- SELECT NEXT POTENTIOMETER, ASSIGN				
					when CHANGE_POT =>
						
						if in_sel < 4 then
							addr <= "1001000";
						else
							addr <= "1001001";
						end if;	
						
						if data_buffer(14) = '0' then
							case in_sel is
								when 6 => ain_0 <= data_buffer(13 downto 2);
								when 7 => ain_1 <= data_buffer(13 downto 2);
								when 0 => ain_2 <= data_buffer(13 downto 2);
								when 5 => ain_3 <= data_buffer(13 downto 2);	
								when 2 => ain_4 <= data_buffer(13 downto 2);
								when 3 => ain_5 <= data_buffer(13 downto 2);
								when 4 => ain_6 <= data_buffer(13 downto 2);
								when 1 => ain_7 <= data_buffer(13 downto 2);
								when others => NULL;
							end case;
						else 
							case in_sel is
								when 6 => ain_0 <= x"FFF";
								when 7 => ain_1 <= x"FFF";
								when 0 => ain_2 <= x"FFF";
								when 5 => ain_3 <= x"FFF";
								when 2 => ain_4 <= x"FFF";
								when 3 => ain_5 <= x"FFF";
								when 4 => ain_6 <= x"FFF";
								when 1 => ain_7 <= x"FFF";
								when others => NULL;
							end case;
						end if;
						
						if delay < delay_CC1 then
							delay := delay + 1;
						else 
							state <= CONFIG_REG;								
							busy_cnt := 0;
							delay := 0;																												
						end if;	
					
-------------------------- WRITE TO THE CONFIGURATION REGISTER
					when CONFIG_REG =>
																				
						IF(busy_prev = '1' AND busy = '0') THEN 	   
							if busy_cnt < 3 then
								busy_cnt := busy_cnt + 1; 
							end if;
						END IF;
						
						case busy_cnt is 
						
								when 0 =>								-- address pointer register													
									enable <= '1';										
									data_wr <= "00000001";
									rw <= '0';
									
									if finish = '1' then
										busy_cnt := busy_cnt + 1; 
										
										case in_sel is
											when 0 => data_wr <= "1" & "100" & "000"& "0";
											when 1 => data_wr <= "1" & "101" & "000"& "0";
											when 2 => data_wr <= "1" & "110" & "000"& "0";
											when 3 => data_wr <= "1" & "111" & "000"& "0";
											when 4 => data_wr <= "1" & "100" & "000"& "0";
											when 5 => data_wr <= "1" & "101" & "000"& "0";
											when 6 => data_wr <= "1" & "110" & "000"& "0";
											when 7 => data_wr <= "1" & "111" & "000"& "0";
										end case;
									end if;
									
									
									
								when 1 =>								-- data byte 1
									enable <= '1';
									rw <= '0';
										
								when 2 =>								-- data byte 2
									enable <= '1';
									data_wr <= "111" & "000" & "11";
									rw <= '0';
									
								when 3 =>								-- stop transmission
									enable <= '0';
									if busy = '0' and delay < delay_CC then
										delay := delay + 1;
									elsif busy = '0' and delay = delay_CC then
										state <= CALL_CONV;
										busy_cnt := 0;
										delay := 0;
									end if;
									
							 when others => NULL;
						end case;
						
-------------------------- CALL CONVERSION REGISTER		
					when CALL_CONV =>
						IF(busy_prev = '1' AND busy = '0') THEN 	   
							if busy_cnt < 7 then
								busy_cnt := busy_cnt + 1; 
							end if;
						END IF;
					
						case busy_cnt is 
						
								when 0 =>								-- address pointer register		
									enable <= '1';
									data_wr <= "00000000";
									rw <= '0';
									if finish = '1' then
										busy_cnt := busy_cnt + 1;
									end if;
									
									
								when others =>								-- stop transmission
									enable <= '0';
									if delay < delay_CC then
										delay := delay + 1;
									elsif busy = '0' and delay = delay_CC then		
										state <= READ_CONV;
										busy_cnt := 0;
										delay := 0;
									end if;
		
						end case;
						
-------------------------- READ CONVERSION
					when READ_CONV =>
						IF(busy_prev = '1' AND busy = '0') THEN 	   
							if busy_cnt < 7 then
								busy_cnt := busy_cnt + 1; 
							end if;
						END IF;
					
						case busy_cnt is 
						
								when 0 =>								-- address pointer register		
									enable <= '1';
									rw <= '1';

									
								when 1 =>								-- data byte 1
									enable <= '1';
									rw <= '1';
									
								when others =>								-- stop transmission
									enable <= '0';
									if busy = '0' then						
										
										if delay < delay_CC then
											delay := delay + 1;
										else 
											state <= CHANGE_POT;									
											busy_cnt := 0;
											delay := 0;	
											data_buffer <= data_received;																												
											
											in_sel <= in_sel + 1;
										
										end if;
									end if;
									
						end case;
						
					when others => NULL;
				end case;						-- outer case statement (TX)
        	  
		  end if;								-- clock edge
    end process;
	 
	 ena <= enable;
end Behavioral;