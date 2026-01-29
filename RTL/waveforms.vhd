library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity waveforms is
	 Port ( 
        address  : in  STD_LOGIC_VECTOR(15 downto 0);
		  shape	  : in  STD_LOGIC_VECTOR(11 downto 0);
		  in_sine  : in  STD_LOGIC_VECTOR(11 downto 0);
		  out_mix  : out STD_LOGIC_VECTOR(11 downto 0);
		  out_sqr  : out STD_LOGIC
    );
end waveforms;

architecture Behavioral of waveforms is
signal tri_wave: STD_LOGIC_VECTOR(11 downto 0);
signal sqr_wave: STD_LOGIC_VECTOR(11 downto 0);
signal saw_wave: STD_LOGIC_VECTOR(11 downto 0);
signal interp     : std_logic_vector(21 downto 0); -- Interpolated signal
signal weight     : std_logic_vector(9 downto 0); -- Weighting factor for interpolation


begin

-- SQUARE, SAWTOOTH, TRIANGLE WAVE GENERATOR
process(address) is
begin
	-- square wave
	if (address(15 downto 4) < x"7FF") then sqr_wave <= x"FFF";
   else sqr_wave <= x"000"; 
	end if;
	
	-- sawtooth wave
	saw_wave <= address(15 downto 4) + x"7FF";
	
	-- triangle wave
	if (address(15 downto 4) < x"400") then
		tri_wave <= x"7FF" + (address(14 downto 4) & "0");
	elsif (address(15 downto 4) > x"3FF" and address(15 downto 4) < x"C00") then
		tri_wave <= x"FFF" - ((address(14 downto 4) - "10000000000") & "0");
	else
		tri_wave <= ((address(14 downto 4) - "10000000000") & "0") ;
	end if;
end process;


-- MIX ALL FOUR WAVES
process(shape, weight, in_sine, tri_wave, saw_wave, sqr_wave)
    begin
		  weight <= shape(9 downto 0);    
        if (shape(11 downto 10) < "01") then
            interp <= (in_sine * (1023 - weight) + tri_wave * weight);
        elsif (shape(11 downto 10) < "10") then
              interp <= (tri_wave * (1023 - weight) + saw_wave * weight);
        elsif (shape(11 downto 10) < "11") then
            interp <= (saw_wave * (1023 - weight) + sqr_wave * weight);
        else
            interp <= (sqr_wave * (1023 - weight) + in_sine * weight);
        end if;
end process;


out_mix <= interp(21 downto 10); -- Assign the interpolated value to the output
out_sqr <= sqr_wave(11);

end Behavioral;