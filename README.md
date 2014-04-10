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

## ALU (Arithmetic Logic Unit)
After downloading the appropriate files, my first task was to write code inside the ALU_shell to implement the ALU functionality.  

### ALU Functionality
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


Under *ARCHITECTURE*, I created a std_logic_vector called *temp_Result*, which was used to store the value of what *Result* would ultimately be.  I proceeded to use the case statement method of creating the MUX.  Because *OpSel* determined which function the ALU accomplish, it was easy to see that *OpSel* would also act as the case.  Writing the actual code for the different functions was not all too difficult--all but one of the functionality took only one line of code.

The only trouble I had was in ROR.  I first attempted to create an intermediary signal which would store the "shifted" values of the *Accumulator*, then send in the intermediary signal to *temp_Result*.  However, when I simulated the design, I had errors in that the values I should have gotten were all shifted to the right.  This error occurred because the intermediary signal acted as a latch and took in the previous value of the intermediary signal.  I then changed my approach to the problem by directly assigning *temp_Result* to the appropriate values from *Accumulator*.  This fixed the problem and ROR worked as expected.

*UPDATE:* I found another way to do the ROR functionality using the built-in functionality within ISE.
```vhdl
    temp_Result <= std_logic_vector(unsigned(Accumulator) ror 1);
```

After checking my syntax and making sure nothing was wrong with the code, I proceeded to simulate the ALU using the provided testbench.

### ALU Simulation

The simulation ran successfully, displaying a beautiful wave of green results.  I went through each of the *OpSel* values with their corresponding values for *Accumulator* and *Data*.  I am happy to say that all of the values were correct.  Most of the funcionality is quite self-explanatory--they did what they were supposed to.  And so I find it unnecessary to go into depth for each part.

![alt text](https://raw.githubusercontent.com/sabinpark/ECE281_Lab4/master/ALU_Simulation.PNG "ALU Simulation")

## Datapath

### Datapath Simulation

After writing code for the Datapath shell, I proceeded to simulate the testbench file.  There were two errors that I needed to correct: an extra semicolon and an extra comma.  These errors were quickly fixed.

I checked my syntax and started the testbench simulation.  The results were successful--the simulation matched the provided answer in the lab handout.  The problem I had to verify the simulation, however, resulted from the fact that my file path for the Lab4_waveform.wcfg was not properly inserted, resulting in precious minutes lost to submit the simulation in time (of all the days to have a parade...).  In the end, I was able to fix the minor error.  The resulting simulation is shown below.

![alt text](https://raw.githubusercontent.com/sabinpark/ECE281_Lab4/master/Datapath_Simulation.PNG "Datapath Simulation")
