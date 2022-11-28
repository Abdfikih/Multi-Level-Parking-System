
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

USE work.room_memory.ALL;

PACKAGE multilevel_functions IS
    -- function findindex return std_logic_vector;

END PACKAGE multilevel_functions;

PACKAGE BODY multilevel_functions IS
    -- function findindex () return std_logic_vector is
    -- variable index : std_logic_vector (0 to 3);
    -- variable i,j : integer;
    -- begin
    --     for i in 0 to 3 loop
    --         for j in 0 to 3 loop
    --             if (parking_array(i,j).room_status = '0') then
    --                 index := std_logic_vector(to_unsigned(i,2)) & std_logic_vector(to_unsigned(j,2));

    --             end if;
    --         end loop;
    --     end loop;
    --     return "0000";
    -- end function findindex;

END PACKAGE BODY multilevel_functions;