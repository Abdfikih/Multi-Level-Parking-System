LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sevenSegment IS
    PORT (
        Bin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Outer : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END sevenSegment;

ARCHITECTURE rtl OF sevenSegment IS
BEGIN
    PROCESS (Bin)
    BEGIN
        CASE Bin IS
            when "0000" => Outer <= "0000001"; -- 0
            when "0001" => Outer <= "1001111"; -- 1
            when "0010" => Outer <= "0010010"; -- 2
            when "0011" => Outer <= "0000110"; -- 3
            when "0100" => Outer <= "1001100"; -- 4
            when "0101" => Outer <= "0100100"; -- 5
            when "0110" => Outer <= "0100000"; -- 6
            when "0111" => Outer <= "0001111"; -- 7
            when "1000" => Outer <= "0000000"; -- 8
            when "1001" => Outer <= "0000100"; -- 9
            when "1010" => Outer <= "0000010"; -- A
            when "1011" => Outer <= "1100000"; -- B
            when "1100" => Outer <= "0110001"; -- C
            when "1101" => Outer <= "1000010"; -- D
            when "1110" => Outer <= "1000010"; -- E
            when "1111" => Outer <= "0111000"; -- F
            when others => Outer <= "0000000";
        END CASE;
    END PROCESS;
END ARCHITECTURE rtl;