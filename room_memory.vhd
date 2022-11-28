LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

PACKAGE room_memory IS

    TYPE room IS RECORD
        room_status : STD_LOGIC;
        fee : INTEGER;
        timer : TIME;
        password : STD_LOGIC_VECTOR(31 DOWNTO 0);
        plate : STD_LOGIC_VECTOR(15 DOWNTO 0);
    END RECORD;
    TYPE parking_lot IS ARRAY (3 DOWNTO 0, 3 DOWNTO 0) OF room;
    CONSTANT def_password : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    CONSTANT def_plate : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    SHARED VARIABLE parking_array : parking_lot := (
    (('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate)),
        (('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate)),
        (('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate)),
        (('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate))
    );
END room_memory;