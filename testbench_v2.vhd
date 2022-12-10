library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;

USE work.room_memory.ALL;

entity testbench_v2 is
end entity testbench_v2;

architecture rtl of testbench_v2 is
    
    type test_plate is array (natural range <>) of std_logic_vector(15 downto 0);
    constant car_plate : test_plate := (
        "1111000011110000", "0101101001011010", "1010010110100101", "0000111100001111",
        "1100110011001100", "0011001100110011", "1001110011100111", "0110001111000011",
        "1001011011011010", "0101000000000101", "1010101010101010", "0100100010000100",
        "1011011101111011", "0010110110010101", "1110111011101110", 
        --case in
        "1011011010111101",
        --case overload
        "1111011010111111"
    );    
    constant correct_password : std_logic_vector(31 downto 0) := "00001011000010111011110110110110";
    constant wrong_password : std_logic_vector(31 downto 0) := "00001011000010111111110110110110";
    
    type vector_tb is record
        gate_sensor : std_logic;
        lift_sensor : std_logic;
        mode : std_logic;
        paid : std_logic;
        enable : std_logic;
        password_ready : std_logic;
        licence_plate_in : std_logic_vector(15 downto 0);
        password_in : std_logic_vector(31 downto 0);
    end record; 

    type array_tb is array (natural range <>) of vector_tb;
    constant test_cases : array_tb := (
        --#1 in success
        ('1', '1', '1', '0', '1', '0', car_plate(15), def_password), 
        --#2 in (overload)
        ('1', '1', '1', '0', '1', '0', car_plate(16), def_password), 
        --#3 out (wrong pass)
        ('1', '1', '0', '1', '1', '1', def_plate, wrong_password),
        --#4 out (paid'nt)
        ('1', '1', '0', '0', '1', '1', def_plate, correct_password),
        --#5 out success
        ('1', '1', '0', '1', '1', '1', def_plate, correct_password)  
    );

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
    SIGNAL pass_status_tb : STD_LOGIC := '0';

    --tb
begin
    gate : entity work.Gate
        port map (gate_sensor_tb, lift_sensor_tb, mode_tb, CLK_tb, paid_tb, enable_tb, overload_out_tb, 
                  password_ready_tb, header_out_tb, licence_plate_in_tb, password_in_tb, password_out_tb, 
                  car_ready_tb, price_out_tb, pass_status_tb);
    
    CLK_tb <= NOT CLK_tb After 100 ps;
    
    process
        VARIABLE initialization_done : boolean := false;
    begin 
        if (not initialization_done) then
            parking_array(0,0) := (('1', 50000, 60 min, def_password, car_plate(0)));
            parking_array(0,1) := (('1', 60000, 60 min, def_password, car_plate(1)));
            parking_array(0,2) := (('1', 20000, 60 min, def_password, car_plate(2)));
            parking_array(0,3) := (('1', 55000, 60 min, def_password, car_plate(3)));
            parking_array(1,0) := (('1', 50800, 60 min, def_password, car_plate(4)));
            parking_array(1,1) := (('1', 40009, 60 min, def_password, car_plate(5)));
            parking_array(1,2) := (('1', 55090, 60 min, def_password, car_plate(6)));
            parking_array(1,3) := (('1', 20070, 60 min, def_password, car_plate(7)));
            parking_array(2,0) := (('1', 59000, 60 min, def_password, car_plate(8)));
            parking_array(2,2) := (('1', 80000, 60 min, def_password, car_plate(9)));
            parking_array(2,3) := (('1', 100000, 98 min, def_password, car_plate(10)));
            parking_array(3,0) := (('1', 55000, 60 min, def_password, car_plate(11)));
            parking_array(3,1) := (('1', 51000, 60 min, def_password, car_plate(12)));
            parking_array(3,2) := (('1', 35000, 60 min, def_password, car_plate(13)));
            parking_array(3,3) := (('1', 57000, 60 min, def_password, car_plate(14))); 
            initialization_done := true;
        end if;
             
        assert not initialization_done 
            report "PARKING ROOM IS FULL 15!"
            severity note;

        for i in test_cases'range loop
            gate_sensor_tb <= test_cases(i).gate_sensor;
            lift_sensor_tb <= test_cases(i).lift_sensor;
            mode_tb <= test_cases(i).mode;
            paid_tb <= test_cases(i).paid;
            enable_tb <= test_cases(i).enable;
            password_ready_tb <= test_cases(i).password_ready;
            licence_plate_in_tb <= test_cases(i).licence_plate_in;
            password_in_tb <= test_cases(i).password_in;
            
            if i = 0 then
                wait for 1499 ps;
                assert car_ready_tb = '0'
                    report "Mobil berhasil diparkir di ruangan " 
                           & INTEGER'image(to_integer(unsigned(header_out_tb(3 DOWNTO 2)))) & ", "
                           & INTEGER'image(to_integer(unsigned(header_out_tb(1 DOWNTO 0))))
                    severity note;
                wait for 1 ps;
            elsif i = 1 then
                wait for 1000 ps;
                assert overload_out_tb = '0'
                    report "Mobil tidak berhail diparkir karena ruangan overload" 
                    severity note;
            elsif i = 2 then
                wait for 800 ps;
                assert pass_status_tb = '1'
                    report "Mobil tidak bisa diambil karena password salah" 
                    severity note;
            elsif i = 3 then
                wait for 800 ps;
                assert paid_tb = '1'
                    report "Mobil tidak bisa diambil karena fee belum dibayar" 
                    severity note;
            elsif i = 4 then
                wait for 800 ps;
                assert pass_status_tb = '0'
                report "Mobil berhasil diambil dari ruangan" 
                severity note;
            end if; 

        end loop;   
                
    end process;

end architecture;