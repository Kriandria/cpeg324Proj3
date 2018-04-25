--Register File Functionality
------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regFile is
    Port (  CLK, WE : in std_logic;
            RS, RT, RD : in STD_LOGIC_VECTOR(1 downto 0); 
            WD : in STD_LOGIC_VECTOR(7 downto 0);
            SData, TData : out STD_LOGIC_VECTOR(7 downto 0));
end regFile;

architecture behavioral of regFile is

signal r0, r1, r2, r3 : std_logic_vector(7 downto 0) := "00000000";

begin

    with RS select SData <=
        r0 when "00",
        r1 when "01",
        r2 when "10",
        r3 when others;

    with RT select TData <=
        r0 when "00",
        r1 when "01",
        r2 when "10",
        r3 when others;

process (CLK) is
    begin
        if (CLK'event and CLK = '1') then
            if (WE = '1') then       
                if (RD = "00") then
                    r0 <= WD;
                elsif (RD = "01") then
                    r1 <= WD;
                elsif (RD = "10") then
                    r2 <= WD;
                elsif (RD = "11") then
                    r3 <= WD;
                end if;
            end if; -- WE = 1
        end if;
    end process;

end behavioral;
-------------------------------------------