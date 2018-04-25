--Dylan Leh, Tom Huber
--Lab 3: Single-Cycle Calculator


-------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity calculator is
    port(
      F : in std_logic_vector(7 downto 0);
      clk : in std_logic);
end calculator;

architecture Behavioral of calculator is

    component regFile is
        Port (  CLK, WE : in std_logic;
                RS, RT, RD : in STD_LOGIC_VECTOR(1 downto 0); 
                WD : in STD_LOGIC_VECTOR(7 downto 0);
                SData, TData : out STD_LOGIC_VECTOR(7 downto 0));
    end component regFile;

    component addsub_8bit is
        port ( input_a, input_b : in std_logic_vector(7 downto 0);
               addsub_sel : in std_logic; --0 = addition, 1 is subtraction.
               sum : out std_logic_vector(7 downto 0));
    end component addsub_8bit;

signal print, load, add, sub, skip1, skip2, WE, cmpOut : std_logic;
signal RS, RT, RD : std_logic_vector(1 downto 0);
signal SD, TD, ALUout, SE, WD : std_logic_vector(7 downto 0);

begin

    print <= F(7) and F(6) and F(0);
    add <= F(6) and not(F(7));
    sub <= F(7) and not(F(6));
    load <= not(F(7)) and not(F(6));
    skip1 <= F(7) and F(6) and not(F(1)) and not(F(0));
    skip2 <= F(7) and F(6) and F(1) and not(F(0));

    WE <= (LOAD or ADD or SUB) and not(print or skip1 or skip2);

    RS <= F(5 downto 4);
    RT <= F(3 downto 2);

    with load select RD <=
        F(1 downto 0) when '0',
        F(5 downto 4) when others;

    SE(3 downto 0) <= F(3 downto 0);
    with F(3) select SE(7 downto 4) <=
        "0000" when '0',
        "1111" when others;

    with LOAD select WD <=
        SE when '1',
        ALUout when others;

    regFile_0: regFile port map (clk, WE, RS, RT, RD, WD, SD, TD);
    ALU: addsub_8bit port map(SD, TD, F(7), ALUout);

    cmpOut <= (SD(7) xnor TD(7)) and
        (SD(6) xnor TD(6)) and
        (SD(5) xnor TD(5)) and
        (SD(4) xnor TD(4)) and
        (SD(3) xnor TD(3)) and
        (SD(2) xnor TD(2)) and
        (SD(1) xnor TD(1)) and
        (SD(0) xnor TD(0));

    process(clk, print) is
        variable ival : integer;
        begin
            if ((clk'event and clk = '1') and (print = '1')) then
                ival := to_integer(signed(SD));

        --Make the ouput right aligned.
                if(ival >= 0) then
                    if(ival < 10) then
                        report "   " & integer'image(ival) severity note;
                    elsif(ival < 100) then
                        report "  " & integer'image(ival) severity note;
                    else
                        report " " & integer'image(ival) severity note;
                    end if;
                else --Display value is negative
                    if(ival > -10) then
                        report "  " & integer'image(ival) severity note;
                    elsif(ival > -100) then
                        report " " & integer'image(ival) severity note;
                    else
                        report integer'image(ival) severity note;
                    end if;
                end if;
            end if;
  end process;
end Behavioral;
-------------------------------------------
