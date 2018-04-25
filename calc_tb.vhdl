library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

--The test bench has no interface.
entity calculator_tb is
end entity calculator_tb;

architecture structural of calculator_tb is

component calculator is
  port(
    F : in std_logic_vector(7 downto 0); --instruction input
    clk : in std_logic
  );
end component calculator;

signal F : std_logic_vector(7 downto 0);
signal clk : std_logic;

begin
    calculator_0 : calculator port map(F, clk);

    process
      file instruction_file : text is in "instructions.txt"; --Instructions in text(ASCII) file.
      variable instruction_line : line;
      variable intruction_vector : bit_vector(7 downto 0);
    begin
      wait for 999 ps; --Used to offset a wait delay in the calculator so time stamps in GTKwave look nicer.
      while (not(endfile(instruction_file))) loop --Loop to the end of the text file.
        clk <= '0';

        readline(instruction_file, instruction_line); --Read in instruction line from file
        read(instruction_line, intruction_vector); --Pass instruction to bit vector form
        F <= to_stdlogicvector(intruction_vector); --Convert bit vector to std_logic_vector and pass instruction to the calculator input.

        --Create a rising edge for the clock.
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
      end loop;
      wait;
    end process;
end architecture structural;