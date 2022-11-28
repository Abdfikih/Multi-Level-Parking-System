library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package room_memory is 

    type room is record
        room_status : std_logic;
        fee : integer;
        timer : time;
        password : std_logic_vector(31 downto 0);
        plate : std_logic_vector(15 downto 0);
    end record;


    type parking_lot is array (3 downto 0, 3 downto 0) of room;    
    constant def_password : std_logic_vector(31 downto 0) := (others => '0') ;
    constant def_plate : std_logic_vector(15 downto 0) := (others  => '0');
    
    shared variable parking_array : parking_lot := (
        (('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate)),
        (('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate)),
        (('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate)),
        (('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate), ('0', 0, 0 min, def_password, def_plate))
    );
    
end room_memory;



