# cpeg324Proj3
Compile:
ghdl -a calc.vhdl regFile.ghdl alu.ghdl calc_tb.ghdl
ghdl -e calculator_tb
ghdl -r calculator_tb
