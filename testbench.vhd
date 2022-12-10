library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

USE work.room_memory.ALL;

entity testbench is
end entity testbench;

architecture rtl of testbench is
    TYPE states IS (idle, fill_15_room, park_in, overload, pick_out);
    SIGNAL present_state, next_state : states := idle;
    type test_plate is array (natural range <>) of std_logic_vector(15 downto 0);
    constant car_plate : test_plate := (
        "1111000011110000", "0101101001011010", "1010010110100101", "0000111100001111",
        "1100110011001100", "0011001100110011", "1001110011100111", "0110001111000011",
        "1001011011011010", "0101000000000101", "1010101010101010", "0100100010000100",
        "1011011101111011", "0010110110010101", "1110111011101110", "1011011010111101"
    );    
    constant correct_password : std_logic_vector(31 downto 0) := "00001011000010111011110110110110";
    constant wrong_password : std_logic_vector(31 downto 0) := "00001011000010111111110110110110";
    SIGNAL CLK : STD_LOGIC := '0';

    signal gate_sensor_tb : STD_LOGIC := '0';
    signal lift_sensor_tb : STD_LOGIC := '0';
    signal mode_tb : STD_LOGIC := '0'; 
    signal CLK_tb : STD_LOGIC := '0';
    signal paid_tb : STD_LOGIC := '0';
    signal enable_tb : STD_LOGIC := '0';
    signal overload_out_tb : STD_LOGIC := '0';
    signal password_ready_tb : STD_LOGIC := '0';
    SIGNAL header_out_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    SIGNAL licence_plate_in_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL password_in_tb : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL password_out_tb : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    SIGNAL car_ready_tb : STD_LOGIC := '0';
    SIGNAL price_out_tb : INTEGER := 0;
begin
    gate : entity work.Gate
        port map (gate_sensor_tb, lift_sensor_tb, mode_tb, CLK_tb, paid_tb, enable_tb, overload_out_tb, 
                  password_ready_tb, header_out_tb, licence_plate_in_tb, password_in_tb, password_out_tb, car_ready_tb, price_out_tb);
    CLK_tb <= NOT CLK_tb AFTER 100 ps;
    CLK <= NOT CLK After 200 ps;
    
    proc_sync : PROCESS (CLK, next_state)
    BEGIN
        IF (rising_edge(CLK))
            THEN
            present_state <= next_state;
        END IF;
    END PROCESS proc_sync;
    
    process(present_state, car_ready_tb, overload_out_tb)
    begin 
        CASE present_state IS
            WHEN idle => 
                next_state <= fill_15_room;

            WHEN fill_15_room => 
                parking_array(0,0) := (('1', 50000, 60 min, def_password, car_plate(0)));
                parking_array(0,1) := (('1', 50000, 60 min, def_password, car_plate(1)));
                parking_array(0,2) := (('1', 50000, 60 min, def_password, car_plate(2)));
                parking_array(0,3) := (('1', 50000, 60 min, def_password, car_plate(3)));
                parking_array(1,0) := (('1', 50000, 60 min, def_password, car_plate(4)));
                parking_array(1,1) := (('1', 50000, 60 min, def_password, car_plate(5)));
                parking_array(1,2) := (('1', 50000, 60 min, def_password, car_plate(6)));
                parking_array(1,3) := (('1', 50000, 60 min, def_password, car_plate(7)));
                parking_array(2,0) := (('1', 50000, 60 min, def_password, car_plate(8)));
                parking_array(2,2) := (('1', 50000, 60 min, def_password, car_plate(9)));
                parking_array(2,3) := (('1', 50000, 60 min, def_password, car_plate(10)));
                parking_array(3,0) := (('1', 50000, 60 min, def_password, car_plate(11)));
                parking_array(3,1) := (('1', 50000, 60 min, def_password, car_plate(12)));
                parking_array(3,2) := (('1', 50000, 60 min, def_password, car_plate(13)));
                parking_array(3,3) := (('1', 50000, 60 min, def_password, car_plate(14)));
                next_state <= park_in;

            WHEN park_in => 
                if (car_ready_tb = '1') then
                    next_state <= overload;
                end if;
                gate_sensor_tb <= '1';
                lift_sensor_tb <= '1';
                mode_tb <= '1';
                paid_tb <= '0';
                enable_tb <= '1';
                password_ready_tb <= '0';
                licence_plate_in_tb <= car_plate(15);
                

            WHEN overload =>
                if (overload_out_tb = '1') then
                    next_state <= pick_out;
                end if;
                gate_sensor_tb <= '1';
                lift_sensor_tb <= '1';
                mode_tb <= '1';
                paid_tb <= '0';
                enable_tb <= '1';
                password_ready_tb <= '0';
                licence_plate_in_tb <= car_plate(15);
                

            WHEN pick_out => 
                gate_sensor_tb <= '1';
                lift_sensor_tb <= '1';
                mode_tb <= '0';
                paid_tb <= '1'; --dah bayar
                enable_tb <= '1';
                password_ready_tb <= '1';
                password_in_tb <= correct_password;

                --case salah password
                --case belum bayar
                
                
        end case; 
    end process;


    --park

    --test overload 

    --pick

    

end architecture;