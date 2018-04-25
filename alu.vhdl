--8 Bit Adder/Subtractor--------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity addsub_8bit is
    port(input_a, input_b : in std_logic_vector(7 downto 0);
        addsub_sel : in std_logic; --0 = addition, 1 is subtraction.
        sum : out std_logic_vector(7 downto 0));
end entity addsub_8bit;

architecture structural of addsub_8bit is
component adder_8bit is
    port(input_a, input_b : in std_logic_vector(7 downto 0);
         sum : out std_logic_vector(7 downto 0));
end component adder_8bit;

signal second_term, inverted_second_term, negative_second_term : std_logic_vector(7 downto 0);
constant one : std_logic_vector(7 downto 0) := "00000001";
begin
adder_8bit_0: adder_8bit port map(input_a, second_term, sum); --Preform the addition
adder_8bit_1: adder_8bit port map(inverted_second_term, one, negative_second_term); --Used for flipping sign of second term.

inverted_second_term <= not(input_b);

with addsub_sel select second_term <=
    input_b when '0', --Use regular term when adding
    negative_second_term when others; --Use negative second term when subtracting becasue A - B = A + (-B)

end architecture structural;
--------------------------------------------------------

--8 Bit Adder-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity adder_8bit is
    port(input_a, input_b : in std_logic_vector(7 downto 0);
         sum : out std_logic_vector(7 downto 0));
end entity adder_8bit;

architecture structural of adder_8bit is
component full_adder is
    port(a, b, c_in : in std_logic;
        sum, c_out : out std_logic);
end component full_adder;

signal c0, c1, c2, c3,c4,c5,c6 : std_logic;
begin                     --(a(in), b(in), c_in(in), sum(out), c_out(out))
    fa0: full_adder port map(input_a(0), input_b(0),'0', sum(0), c0); --c_in for the first full_adder is always 0, i.e. nothing.
    fa1: full_adder port map(input_a(1), input_b(1), c0, sum(1), c1);
    fa2: full_adder port map(input_a(2), input_b(2), c1, sum(2), c2);
    fa3: full_adder port map(input_a(3), input_b(3), c2, sum(3), c3);
    fa4: full_adder port map(input_a(4), input_b(4), c3, sum(4), c4);
    fa5: full_adder port map(input_a(5), input_b(5), c4, sum(5), c5);
    fa6: full_adder port map(input_a(6), input_b(6), c5, sum(6), c6);
    fa7: full_adder port map(input_a(7), input_b(7), c6, sum(7), open);

end architecture structural;
--------------------------------------------------------

--Full Adder--------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity full_adder is
    port(a, b, c_in : in std_logic;
        sum, c_out : out std_logic);
end entity full_adder;

architecture structural of full_adder is
component half_adder is
    port(a, b : in std_logic;
        sum, carry : out std_logic);
end component half_adder;

signal s1, s2, s3 : std_logic;
begin                    --(a(in), b(in), sum(out), c_out(out))
    h1: half_adder port map(a, b, s1, s3);
    h2: half_adder port map(s1, c_in, sum, s2);
    c_out <= s2 or s3;
end architecture structural;
--------------------------------------------------------

--Half Adder--------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity half_adder is
    port(a, b : in std_logic;
        sum, carry : out std_logic);
end entity half_adder;

architecture behavioral of half_adder is
begin
    sum <= a xor b;
    carry <= a and b;
end architecture behavioral;
--------------------------------------------------------