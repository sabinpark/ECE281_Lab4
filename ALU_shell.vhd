-------------------------------------------------------------------------------
--
-- Title       : ALU
-- Design      : ALU
-- Author      : usafa
-- Company     : usafa
--
-------------------------------------------------------------------------------
--
-- File        : ALU.vhd
-- Generated   : Fri Mar 30 11:16:54 2007
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : Performs arithmetic and logical operations when program instructions demand them
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {ALU} architecture {ALU}}

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
	 port(
		 OpSel : in STD_LOGIC_VECTOR(2 downto 0);
		 Data : in STD_LOGIC_VECTOR(3 downto 0);
		 Accumulator : in STD_LOGIC_VECTOR(3 downto 0);
		 Result : out STD_LOGIC_VECTOR(3 downto 0)
	     );
end ALU;

--}} End of automatically maintained section

architecture ALU of ALU is	   

	signal ROR_Result : std_logic_vector(3 downto 0);
	signal temp_Result : std_logic_vector(3 downto 0);

begin
	
-- fill in details to create result as a function of Data and Accumulator, based on OpSel.
 -- e.g : Build a multiplexer choosing between the eight ALU operations.  Either use a case statement (and thus a process)
 --       or a conditional signal assignment statement ( x <= Y when <condition> else . . .)
 -- ALU Operations are defined as:
 -- OpSel : Function
--  0     : AND
--  1     : NEG (2s complement)
--  2     : NOT (invert)
--  3     : ROR
--  4     : OR
--  5     : IN
--  6     : ADD
--  7     : LD
aluswitch: process (Accumulator, Data, OpSel)
      begin
		-- enter your if/then/else or case statements here
		case OpSel is
			-- AND
			when "000" =>
				temp_Result <= Accumulator and Data;
				
			-- NEG (A => -A)
			when "001" =>
				temp_Result <= STD_LOGIC_VECTOR(unsigned(not Accumulator) + 1);
				
			-- NOT
			when "010" =>
				temp_Result <= not Accumulator;
				
			-- ROR (rotate the data one bit to the right with wrap-around)
			when "011" =>
			
			-- QUESTION:  Why doesn't the temp signal work?
			
--				ROR_Result(3) <= Accumulator(0);
--				ROR_Result(2) <= Accumulator(3);
--				ROR_Result(1) <= Accumulator(2);
--				ROR_Result(0) <= Accumulator(1);
				temp_Result(2 downto 0) <= Accumulator(3 downto 1);
				temp_Result(3) <= Accumulator(0);
--				temp_Result <= ROR_Result;
				
			-- OR
			when "100" =>
				temp_Result <= Accumulator or Data;
			
			-- IN
			when "101" =>
				temp_Result <= Data;
				
			-- ADD
			when "110" =>
				temp_Result <= std_logic_vector(unsigned(Accumulator) + unsigned(Data));
			
			-- LDA
			when others =>  -- where others = "111"
				temp_Result <= Data;
				
		end case;
end process;

Result <= temp_Result;

-- OR, enter your conditional signal statement here

end ALU;

