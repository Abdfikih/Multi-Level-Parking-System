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
        clk : IN STD_LOGIC;
        paid : IN STD_LOGIC;
        overload_signal, enable : IN STD_LOGIC;
        overload_out : OUT STD_LOGIC;
        password_ready : IN STD_LOGIC;
        header_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        licence_plate_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        password_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        password_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        car_ready : OUT STD_LOGIC;
        price_out : OUT INTEGER
        -- time_stamp : out integer

    );
END ENTITY;

ARCHITECTURE rtl OF Gate IS

    --State machine
    SIGNAL present_state, next_state : state_type;
    SIGNAL password_sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL park : parking_lot := parking_array;

    SIGNAL header : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL priceout : INTEGER;
BEGIN

    header_out <= header;
    --synchronize process
    sync_proc : PROCESS (clk, next_state)
    BEGIN
        IF rising_edge(clk) THEN
            present_state <= next_state;
        END IF;
    END PROCESS;

    --comb process
    comb_proc : PROCESS (present_state, gate_sensor, lift_sensor, mode, overload_signal, enable, password_ready, licence_plate_in, password_in, paid)
        VARIABLE price, timeelapsed : INTEGER := 0;
        VARIABLE overload_var : STD_LOGIC;
    BEGIN
        password_out <= password_sig;
        park <= parking_array;
        car_ready <= '0';
        overload_var := '0';
        overload_out <= overload_var;
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
                    next_state <= PASSSUCCESS;
                    IF (parking_array(0, 0).password = password_in) THEN
                        header_out <= "0000";
                    ELSIF (parking_array(0, 1).password = password_in) THEN
                        header <= "0001";
                    ELSIF (parking_array(0, 2).password = password_in) THEN
                        header <= "0010";
                    ELSIF (parking_array(0, 3).password = password_in) THEN
                        header <= "0011";
                    ELSIF (parking_array(1, 0).password = password_in) THEN
                        header <= "0100";
                    ELSIF (parking_array(1, 1).password = password_in) THEN
                        header <= "0101";
                    ELSIF (parking_array(1, 2).password = password_in) THEN
                        header <= "0110";
                    ELSIF (parking_array(1, 3).password = password_in) THEN
                        header <= "0111";
                    ELSIF (parking_array(2, 0).password = password_in) THEN
                        header <= "1000";
                    ELSIF (parking_array(2, 1).password = password_in) THEN
                        header <= "1001";
                    ELSIF (parking_array(2, 2).password = password_in) THEN
                        header <= "1010";
                    ELSIF (parking_array(2, 3).password = password_in) THEN
                        header <= "1011";
                    ELSIF (parking_array(3, 0).password = password_in) THEN
                        header <= "1100";
                    ELSIF (parking_array(3, 1).password = password_in) THEN
                        header <= "1101";
                    ELSIF (parking_array(3, 2).password = password_in) THEN
                        header <= "1110";
                    ELSIF (parking_array(3, 3).password = password_in) THEN
                        header <= "1111";
                    ELSE
                        next_state <= PASSFAIL;
                    END IF;

                ELSE
                    next_state <= CAROUT;
                END IF;

            WHEN CARIN =>
                IF (parking_array(0, 0).room_status = '0') THEN
                    header <= "0000";
                ELSIF (parking_array(0, 1).room_status = '0') THEN
                    header <= "0001";
                ELSIF (parking_array(0, 2).room_status = '0') THEN
                    header <= "0010";
                ELSIF (parking_array(0, 3).room_status = '0') THEN
                    header <= "0011";
                ELSIF (parking_array(1, 0).room_status = '0') THEN
                    header <= "0100";
                ELSIF (parking_array(1, 1).room_status = '0') THEN
                    header <= "0101";
                ELSIF (parking_array(1, 2).room_status = '0') THEN
                    header <= "0110";
                ELSIF (parking_array(1, 3).room_status = '0') THEN
                    header <= "0111";
                ELSIF (parking_array(2, 0).room_status = '0') THEN
                    header <= "1000";
                ELSIF (parking_array(2, 1).room_status = '0') THEN
                    header <= "1001";
                ELSIF (parking_array(2, 2).room_status = '0') THEN
                    header <= "1010";
                ELSIF (parking_array(2, 3).room_status = '0') THEN
                    header <= "1011";
                ELSIF (parking_array(3, 0).room_status = '0') THEN
                    header <= "1100";
                ELSIF (parking_array(3, 1).room_status = '0') THEN
                    header <= "1101";
                ELSIF (parking_array(3, 2).room_status = '0') THEN
                    header <= "1110";
                ELSIF (parking_array(3, 3).room_status = '0') THEN
                    header <= "1111";
                ELSE
                    overload_var := '1';
                END IF;

                IF overload_var = '1' THEN
                    next_state <= OVERLOAD;
                ELSE
                    next_state <= LICENSEINSERT;
                END IF;

            WHEN LICENSEINSERT =>
                IF lift_sensor = '1' AND NOT (licence_plate_in = "0000000000000000") THEN
                    next_state <= INSUCCESS;
                ELSE
                    next_state <= LICENSEINSERT;
                END IF;

            WHEN INSUCCESS =>
                car_ready <= '1';
                parking_array(to_integer(unsigned(header(3 DOWNTO 2))), to_integer(unsigned(header(1 DOWNTO 0)))).room_status := '1';
                parking_array(to_integer(unsigned(header(3 DOWNTO 2))), to_integer(unsigned(header(1 DOWNTO 0)))).plate := licence_plate_in;
                parking_array(to_integer(unsigned(header(3 DOWNTO 2))), to_integer(unsigned(header(1 DOWNTO 0)))).timer := now;
                parking_array(to_integer(unsigned(header(3 DOWNTO 2))), to_integer(unsigned(header(1 DOWNTO 0)))).password := hash(licence_plate_in);
                next_state <= IDLE;
            WHEN PASSFAIL =>
                next_state <= IDLE;
            WHEN PASSSUCCESS =>
                price := (now - parking_array(to_integer(unsigned(header(3 DOWNTO 2))), to_integer(unsigned(header(1 DOWNTO 0)))).timer) / 1 ps;
                REPORT "Price: " & INTEGER'image(price);
                price_out <= price;
                IF paid = '1' THEN
                    parking_array(to_integer(unsigned(header(3 DOWNTO 2))), to_integer(unsigned(header(1 DOWNTO 0)))).room_status := '0';
                    parking_array(to_integer(unsigned(header(3 DOWNTO 2))), to_integer(unsigned(header(1 DOWNTO 0)))).plate := (OTHERS => '0');
                    parking_array(to_integer(unsigned(header(3 DOWNTO 2))), to_integer(unsigned(header(1 DOWNTO 0)))).timer := 0 ns;
                    parking_array(to_integer(unsigned(header(3 DOWNTO 2))), to_integer(unsigned(header(1 DOWNTO 0)))).password := (OTHERS => '0');
                    next_state <= IDLE;
                ELSE
                    next_state <= PASSSUCCESS;
                END IF;
            WHEN OVERLOAD =>
                next_state <= IDLE;
        END CASE;
    END PROCESS;

END ARCHITECTURE;