library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity testbench is
end entity testbench;

architecture rtl of testbench is
    type test_plate is array (natural range <>) of std_logic_vector(15 downto 0);
    constant car_plate : test_plate := (
        "1111000011110000", "0101101001011010", "1010010110100101", "0000111100001111",
        "1100110011001100", "0011001100110011", "1001110011100111", "0110001111000011",
        "1001011011011010", "0101000000000101", "1010101010101010", "0100100010000100",
        "1011011101111011", "0010110110010101", "1110111011101110", "1011011010111101"
    );    
begin
    

    

end architecture;