ECE281_Lab4
===========

Sabin's Lab 4

### Overview
  1.  Create PRISM's ALU to execute math and logic operations
  2.  Create PRISM's datapath using the ALU
  3.  Simulate the datapath and understand its operation


### Provided Files
  * ALU_shell.vhd
  * ALU_testbench.vhd
  * Datapath_shell.vhd
  * Datapath_testbench.vhd
  * Lab4_waveform.wcfg



# Design

### ALU (Arithmetic Logic Unit)
After downloading the appropriate files, the first task was to write code inside the ALU_shell to implement the ALU functionality.  

#### ALU Functionality 
| OpSel  | Function 
|:------:|:---------
| 0 | AND
| 1 | NEG
| 2 | NOT
| 3 | ROR
| 4 | OR
| 5 | IN 
| 6 | ADD
| 7 | LDA

#### ALU Schematic
![alt text](https://raw.githubusercontent.com/sabinpark/ECE281_Lab4/master/ALU_schematic.jpg "ALU Schematic")

#### ALU Coding
Under *ARCHITECTURE*, I created a std_logic_vector called *temp_Result*, which was used to store the value of what *Result* would ultimately be.  I proceeded to use the case statement method of creating the MUX.  Because *OpSel* determined which function the ALU accomplish, it was easy to see that *OpSel* would also act as the case.  Writing the actual code for the different functions was not all too difficult--all but one of the functionality took only one line of code.  *UPDATE*  Now all functionality is written using one line of code.

The only trouble I had was in ROR.  I first attempted to create an intermediary signal which would store the "shifted" values of the *Accumulator*, then send in the intermediary signal to *temp_Result*.  However, when I simulated the design, I had errors in that the values I should have gotten were all shifted to the right.  This error occurred because the intermediary signal acted as a latch and took in the previous value of the intermediary signal.  I then changed my approach to the problem by directly assigning *temp_Result* to the appropriate values from *Accumulator*.  This fixed the problem and ROR worked as expected.

*UPDATE:* I found another way to do the ROR functionality using the built-in functionality within ISE.

```vhdl
    temp_Result <= std_logic_vector(unsigned(Accumulator) ror 1);
```

After checking my syntax and making sure nothing was wrong with the code, I proceeded to simulate the ALU using the provided testbench.

#### ALU Simulation

The simulation ran successfully, displaying a beautiful green wave of results.  I went through each of the *OpSel* values with their corresponding values for *Accumulator* and *Data*.  After going through each combination of values, I am happy to say that the outputs were indeed correct.  Most of the funcionality is quite self-explanatory (AND is used to AND stuff together, NEG negates the accumulator value, etc...).  The only thing that maay require further explaining is the the ROR functionality, which basically rotates the bit values to the right (with a wrap around).  IE) "1010" --> "0101"

Below is an image of the simulation results:
![alt text](https://raw.githubusercontent.com/sabinpark/ECE281_Lab4/master/ALU_Simulation.PNG "ALU Simulation")

### Datapath

The datapath is an important part of the CPU.  It contains the instruction register, the program counter, and the ALU, and performs data processing operations.

#### Datapath Coding

The datapath subsystem circuit on page 3 of the lab handout was very helpful for implementing all of the parts of the datapath.

##### ALU and Program Counter
I began by first declaring the ALU component under the ARCHITECTURE of the vhdl shell file.  Going down the code, I instantiated the ALU under the CONNECTIONS part.  Pretty standard thus far.  Also under connections, I found that the Program Counter was already programmed.  I proceeded to code the rest of the file beginning with the Instruction Register.

##### Instruction Register
The instruction register will be sensitive to *Clock* and *Reset_L*.  If *Reset_L* equals '0', then the IR will reset back to "0000".  Otherwise, if the clock is on a rising edge and *IRLd* (IR load) is true, then the IR will take in the information from the data bus.

```vhdl
  	process(Clock, Reset_L)
  	begin				 
		if(Reset_L = '0') then
		  	IR <= "0000";
		elsif (rising_edge(Clock) and IRLd = '1') then 
			IR <= Data;
		end if;		
  	end process;  
```

##### Memory Address Register (HI and LO)
I had to use two process for the MAR couples--one for HI and one for LO.  They were both sensitive to *Clock* and *Reset_L*.  If *Reset_L* equaled '0', the MAR would be reset to "0000".  Similar to the IR, if on a rising edge and the MAR Hi load signal is true for the respective MAR (1 for MAR Hi and 0 for MAR Lo), then that MAR will take in the value from the data bus.  

##### Address Selector
The address selector is sensitive to *Clock*, *Reset_L*, *PC*, and *AddrSel*.  As shown in the code below, if AddrSel is 0, then the Address will take in the values of MAR Hi and MAR Lo.  Otherwise, the Address Bus will take in the value from the Program Counter

```vhdl
  	process(Clock, Reset_L, PC, AddrSel)
    	begin				 
  		if(AddrSel = '0') then
  			Addr(7 downto 4) <= MARHi;
  			Addr(3 downto 0) <= MARLo;
  		elsif (AddrSel = '1') then
  			Addr <= PC;
  		end if;
    	end process;   
```

##### Accumulator
The Accumulator is sensitive to *Clock* and *Reset_L*.  If *Reset_L* is 0, then the Accumulator will take in "0000".  Otherwise, the Accumulator will take in the value from *ALU_Result*.

```vhdl
  	process(Clock, Reset_L)
  	begin			
		if(Reset_L = '0') then
			Accumulator <= "0000";
		elsif (rising_edge(Clock) and AccLd = '1') then
			Accumulator <= ALU_Result;
		end if;
  	end process;    
```

##### Tri-State Buffer and Datapath sign signals
The buffer is implemented in such a way so that when *EnAccBuffer* is 1, the Accumulator data will pass on to the Data Bus.  Otherwise, the Data Bus will simply take in "ZZZZ".
```vhdl
    Data <= Accumulator when EnAccBuffer = '1' else "ZZZZ";
```

The Datapath sign signals were implemented as follows:  

*Alesszero* was set to 1 when the MSB of the accumulator was a 1.  This meant that the accumulator value was a negative number.  Otherwise, *Alesszero* was set to 0.

*Aeqzero* was set to 1 when the accumulator value was a 0; otherwise, *Aeqzero* was set to 0.

#### Datapath Simulation

After writing code for the Datapath shell, I proceeded to simulate the testbench file.  There were two errors that I needed to correct: an extra semicolon and an extra comma.  These errors were quickly fixed.

I checked my syntax and started the testbench simulation.  The results were successful--the simulation matched the provided answer in the lab handout.  One problem I had resulted from the fact that my file path for the Lab4_waveform.wcfg was not properly inserted, resulting in precious minutes lost to submit the simulation in time (of all the days to have a parade...).  In the end, I was able to fix the minor error.  The resulting simulation is shown below.  *UPDATE* I updated the image below to read out the values (and value lengths) to match exactly with the example given in the lab handout.

![alt text](https://raw.githubusercontent.com/sabinpark/ECE281_Lab4/master/Datapath_Simulation_0_to_50.PNG "Datapath Simulation (initial)")

To initially test the correctness of the datapath, I went through my simulation and compared it to the provided results image from the lab handout.  I went through line by line, value by value, and found that the two results were 100% the same (at least from 0 to 50 ns).  Knowing this, I safely concluded that my datapath was indeed functioning correctly.

As for the operation of the test bench (getting the results to show exactly like the example), I simply followed the instructions step by step.  Nothing was added or taken out from the instructions.


# Reverse Engineering

This next part is where I will analyze the simulation.  There are three time segments to analyze:

* Time period from 0 to 50 ns
* Time period from 50 to 100 ns
* The jump instruction at 225 ns

Each segment will have two parts of analysis:

* Address Locations
* Detailed analysis of the simulation

### 0 to 50 ns

The initial analysis was provided for by Captain Silva.  

### 50 to 100 ns
The results from 50 ns to 100 ns is shown below:
![alt text](https://raw.githubusercontent.com/sabinpark/ECE281_Lab4/master/Datapath_Simulation_0_to_50.PNG "Datapath Simulation from 50 to 100 ns")

First, at 50 ns, we see that data = 3.  At the next cycle, 3 is put into the data bus.  3 is the opcode for ROR.  Therefore, at the next cycle, the operand, "1011", is rotated.  The cycle following that, the accumulator takes in the value of ROR(1011), which is "1101".  The cycle starting at 75 ns begins with the data bus taking in 4.  The opcode for 4 is "OR".  We see that beginning at 85 ns, the IR takes in the opcode value of 4.  Simultaneously, the operand, 3, is put into the data bus.  The cycle after 100 ns, the accumulator value and the data bus value will be OR'ed together to get a value of 0011 as shown at 105 ns.  As for the Address, each address value corresponds exactly with the program counter value (at least for the segment from 50 to 100 ns).

### Jump Instruction at 225 ns
The results at 225 ns is shown below:
![alt text](https://raw.githubusercontent.com/sabinpark/ECE281_Lab4/master/Datapath_Simulation_250.PNG "Datapath Simulation at the jump instruction")

At 225 ns, *jmpsel* is set to 1.  At the same time, *addrsel* is also set to 1.  Corresponding with those signals, the address to jump to is the current address value, which is a 2. 
