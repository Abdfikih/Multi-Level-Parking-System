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
        password_ready : IN STD_LOGIC;
        licence_plate_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        --licence_plate_out : out std_logic_vector(15 downto 0);
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

            WHEN CARIN =>
                IF overload_signal = '1' THEN
                    next_state <= OVERLOAD;
                ELSE
                    next_state <= LICENSEINSERT;

                END IF;
            WHEN LICENSEINSERT =>
                IF lift_sensor = '1' AND NOT (licence_plate_in = "0000000000000000") THEN
                    FOR i IN 0 TO 3 LOOP
                        FOR j IN 0 TO 3 LOOP
                            IF (parking_array(i, j).room_status = '0') THEN
                                itemp := i;
                                jtemp := j;
                                header <= STD_LOGIC_VECTOR(to_unsigned(i, 2)) & STD_LOGIC_VECTOR(to_unsigned(j, 2));
                                EXIT;
                            END IF;
                        END LOOP;
                    END LOOP;
                    parking_array(itemp, jtemp).plate := licence_plate_in;
                    parking_array(to_integer(unsigned(header(1 DOWNTO 0))), to_integer(unsigned(header(3 DOWNTO 2)))).password := licence_plate_in & licence_plate_in;
                    parking_array(to_integer(unsigned(header(1 DOWNTO 0))), to_integer(unsigned(header(3 DOWNTO 2)))).room_status := '1';
                    next_state <= INSUCCESS;
                ELSE
                    next_state <= LICENSEINSERT;
                END IF;
            WHEN INSUCCESS =>
                car_ready <= '1';
                --parking_array(0, 1).plate := "1111000011110000";
                next_state <= IDLE;
            WHEN PASSFAIL =>
            WHEN PASSSUCCESS =>
            WHEN OVERLOAD =>
        END CASE;
    END PROCESS;

END ARCHITECTURE;