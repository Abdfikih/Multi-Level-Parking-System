
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

USE work.room_memory.ALL;

PACKAGE multilevel_functions IS

    FUNCTION hash(inputhash : STD_LOGIC_VECTOR(15 DOWNTO 0)) RETURN STD_LOGIC_VECTOR;

 

END PACKAGE multilevel_functions;

PACKAGE BODY multilevel_functions IS

    FUNCTION hash(inputhash : STD_LOGIC_VECTOR(15 DOWNTO 0)) RETURN STD_LOGIC_VECTOR IS
        VARIABLE result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN

        result(31 DOWNTO 24) := inputhash(15 DOWNTO 8) XOR inputhash(7 DOWNTO 0);
        result(23 DOWNTO 16) := inputhash(7 DOWNTO 0) XOR inputhash(15 DOWNTO 8);
        result(15 DOWNTO 8) := inputhash(15 DOWNTO 8) XOR inputhash(7 DOWNTO 0) XOR inputhash(15 DOWNTO 8);
        result(7 DOWNTO 0) := inputhash(7 DOWNTO 0) XOR inputhash(15 DOWNTO 8) XOR inputhash(7 DOWNTO 0);

        RETURN result;
    END FUNCTION;

    

END PACKAGE BODY multilevel_functions;