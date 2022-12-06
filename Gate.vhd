LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

USE work.multilevel_types.ALL;
USE work.multilevel_functions.ALL;
USE work.room_memory.ALL;

ENTITY Gate IS
    PORT (
        gate_sensor : IN STD_LOGIC;
        lift_sensor : IN STD_LOGIC;
        mode : IN STD_LOGIC;
        price : IN INTEGER := 0;
        clk : IN STD_LOGIC;
        overload_signal, enable : IN STD_LOGIC;
        overload_out : OUT STD_LOGIC;
        password_ready : IN STD_LOGIC;
        licence_plate_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        licence_plate_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        password_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        password_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        car_ready : OUT STD_LOGIC
        -- time_stamp : out integer

    );
END ENTITY;

ARCHITECTURE rtl OF Gate IS

    --State machine
    SIGNAL present_state, next_state : state_type;
    SIGNAL password_sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL park : parking_lot := parking_array;
    SIGNAL header : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

    --synchronize process
    sync_proc : PROCESS (clk, next_state)
    BEGIN
        IF rising_edge(clk) THEN
            present_state <= next_state;
        END IF;
    END PROCESS;

    --comb process
    comb_proc : PROCESS (present_state, gate_sensor, lift_sensor, mode, price, overload_signal, enable, password_ready, licence_plate_in, password_in)
        VARIABLE i, j : INTEGER;
        VARIABLE itemp, jtemp : INTEGER;
    BEGIN
        password_out <= password_sig;
        park <= parking_array;
        car_ready <= '0';
        CASE present_state IS
            WHEN IDLE =>
                car_ready <= '0';
                IF gate_sensor = '1' THEN
                    next_state <= SELECTMODE;
                ELSE
                    next_state <= IDLE;
                END IF;
            WHEN SELECTMODE =>
                IF enable = '1' AND mode = '1' THEN
                    next_state <= CARIN;

                ELSIF enable = '1' AND mode = '0' THEN
                    next_state <= CAROUT;
                ELSE
                    next_state <= SELECTMODE;
                END IF;
            WHEN CAROUT =>
                IF password_ready = '1' THEN

                    IF (parking_array(0, 0).password = password_in AND parking_array(0, 0).plate = licence_plate_in) THEN
                        itemp := 0;
                        jtemp := 0;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(0, 1).password = password_in AND parking_array(0, 1).plate = licence_plate_in) THEN
                        itemp := 0;
                        jtemp := 1;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(0, 2).password = password_in AND parking_array(0, 2).plate = licence_plate_in) THEN
                        itemp := 0;
                        jtemp := 2;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(0, 3).password = password_in AND parking_array(0, 3).plate = licence_plate_in) THEN
                        itemp := 0;
                        jtemp := 3;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(1, 0).password = password_in AND parking_array(1, 0).plate = licence_plate_in) THEN
                        itemp := 1;
                        jtemp := 0;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(1, 1).password = password_in AND parking_array(1, 1).plate = licence_plate_in) THEN
                        itemp := 1;
                        jtemp := 1;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(1, 2).password = password_in AND parking_array(1, 2).plate = licence_plate_in) THEN
                        itemp := 1;
                        jtemp := 2;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(1, 3).password = password_in AND parking_array(1, 3).plate = licence_plate_in) THEN
                        itemp := 1;
                        jtemp := 3;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(2, 0).password = password_in AND parking_array(2, 0).plate = licence_plate_in) THEN
                        itemp := 2;
                        jtemp := 0;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(2, 1).password = password_in AND parking_array(2, 1).plate = licence_plate_in) THEN
                        itemp := 2;
                        jtemp := 1;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(2, 2).password = password_in AND parking_array(2, 2).plate = licence_plate_in) THEN
                        itemp := 2;
                        jtemp := 2;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(2, 3).password = password_in AND parking_array(2, 3).plate = licence_plate_in) THEN
                        itemp := 2;
                        jtemp := 3;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(3, 0).password = password_in AND parking_array(3, 0).plate = licence_plate_in) THEN
                        itemp := 3;
                        jtemp := 0;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(3, 1).password = password_in AND parking_array(3, 1).plate = licence_plate_in) THEN
                        itemp := 3;
                        jtemp := 1;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(3, 2).password = password_in AND parking_array(3, 2).plate = licence_plate_in) THEN
                        itemp := 3;
                        jtemp := 2;
                        next_state <= PASSSUCCESS;
                    ELSIF (parking_array(3, 3).password = password_in AND parking_array(3, 3).plate = licence_plate_in) THEN
                        itemp := 3;
                        jtemp := 3;
                        next_state <= PASSSUCCESS;
                    ELSE
                        next_state <= PASSFAIL;
                    END IF;
                    parking_array(itemp, jtemp).room_status := '0';
                    parking_array(itemp, jtemp).plate := (OTHERS => '0');
                    parking_array(itemp, jtemp).timer := 0 ns;
                    parking_array(itemp, jtemp).password := (OTHERS => '0');

                ELSE
                    next_state <= CAROUT;
                END IF;

            WHEN CARIN =>
                IF overload_signal = '1' THEN
                    next_state <= OVERLOAD;
                ELSE
                    next_state <= LICENSEINSERT;

                END IF;

            WHEN LICENSEINSERT =>
                IF lift_sensor = '1' AND NOT (licence_plate_in = "0000000000000000") THEN
                    IF (parking_array(0, 0).room_status = '0') THEN
                        itemp := 0;
                        jtemp := 0;
                    ELSIF (parking_array(0, 1).room_status = '0') THEN
                        itemp := 0;
                        jtemp := 1;
                    ELSIF (parking_array(0, 2).room_status = '0') THEN
                        itemp := 0;
                        jtemp := 2;
                    ELSIF (parking_array(0, 3).room_status = '0') THEN
                        itemp := 0;
                        jtemp := 3;
                    ELSIF (parking_array(1, 0).room_status = '0') THEN
                        itemp := 1;
                        jtemp := 0;
                    ELSIF (parking_array(1, 1).room_status = '0') THEN
                        itemp := 1;
                        jtemp := 1;
                    ELSIF (parking_array(1, 2).room_status = '0') THEN
                        itemp := 1;
                        jtemp := 2;
                    ELSIF (parking_array(1, 3).room_status = '0') THEN
                        itemp := 1;
                        jtemp := 3;
                    ELSIF (parking_array(2, 0).room_status = '0') THEN
                        itemp := 2;
                        jtemp := 0;
                    ELSIF (parking_array(2, 1).room_status = '0') THEN
                        itemp := 2;
                        jtemp := 1;
                    ELSIF (parking_array(2, 2).room_status = '0') THEN
                        itemp := 2;
                        jtemp := 2;
                    ELSIF (parking_array(2, 3).room_status = '0') THEN
                        itemp := 2;
                        jtemp := 3;
                    ELSIF (parking_array(3, 0).room_status = '0') THEN
                        itemp := 3;
                        jtemp := 0;
                    ELSIF (parking_array(3, 1).room_status = '0') THEN
                        itemp := 3;
                        jtemp := 1;
                    ELSIF (parking_array(3, 2).room_status = '0') THEN
                        itemp := 3;
                        jtemp := 2;
                    ELSIF (parking_array(3, 3).room_status = '0') THEN
                        itemp := 3;
                        jtemp := 3;
                    END IF;
                    parking_array(itemp, jtemp).room_status := '1';
                    parking_array(itemp, jtemp).plate := licence_plate_in;
                    parking_array(itemp, jtemp).timer := now;
                    parking_array(itemp, jtemp).password := licence_plate_in & licence_plate_in;
                    licence_plate_out <= licence_plate_in;
                    next_state <= INSUCCESS;
                ELSE
                    next_state <= LICENSEINSERT;
                END IF;

            WHEN INSUCCESS =>
                car_ready <= '1';
                next_state <= IDLE;
            WHEN PASSFAIL =>

                next_state <= IDLE;
            WHEN PASSSUCCESS =>
                next_state <= IDLE;
            WHEN OVERLOAD =>
                next_state <= IDLE;
        END CASE;
    END PROCESS;

END ARCHITECTURE;