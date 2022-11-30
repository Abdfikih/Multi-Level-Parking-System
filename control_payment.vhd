LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

USE work.room_memory.ALL;

ENTITY control_payment IS
    PORT (
        inp_mode : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        inp_plat : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        out_mode : OUT std_logic;
        out_plat : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END control_payment;

ARCHITECTURE control_payment_arch OF control_payment IS

    TYPE state_type IS (S0, S1, S2);
    SIGNAL state : state_type;

    SIGNAL out_temp : STD_LOGIC_VECTOR (15 DOWNTO 0);
    
BEGIN

    PROCESS (inp_mode, inp_plat, clk)

        VARIABLE inp_time : TIME := 0 ns;
        VARIABLE temp_time : TIME := 0 ns;
        VARIABLE out_time : INTEGER;
        VARIABLE price : INTEGER := 0;
        VARIABLE temp_i : INTEGER := 0;
        VARIABLE temp_j : INTEGER := 0;
        
    BEGIN

        IF rising_edge(clk) THEN
            CASE state IS
                WHEN S0 =>
                    IF (inp_mode = '0' OR price > 0) THEN
                        FOR i IN 0 TO 3 LOOP
                            FOR j IN 0 TO 3 LOOP
                                IF (parking_array(i, j).plate = "000000000000000") THEN
                                    --parking_array(i, j).plate := inp_plat;
                                    temp_i := i;
                                    temp_j := j;
                                    inp_time := now;
                                    exit;
                                ELSE
                                    out_temp <= "0000000000000000";
                                END IF;
                            END loop;
                        END LOOP;
                        out_time := inp_time/TIME'val(1);
                        REPORT "Biaya Parkir : " & INTEGER'image(out_time);
                        out_mode <= '0';
                        parking_array(temp_i, temp_j).plate := inp_plat;
                        parking_array(temp_i, temp_j).timer := inp_time;
                        state <= S1;
                    END IF;
                WHEN S1 =>
                    IF (inp_mode = '1') THEN
                        FOR i IN 0 TO 3 LOOP
                            FOR j IN 0 TO 3 LOOP
                                IF (inp_plat = parking_array(i, j).plate) THEN
                                    out_temp <= parking_array(i, j).plate;
                                    temp_i := i;
                                    temp_j := j;
                                    inp_time := now;
                                    temp_time := parking_array(i, j).timer;
                                    inp_time := inp_time - temp_time;
                                    out_time := inp_time/TIME'val(1);
                                ELSE
                                    out_temp <= "0000000000000000";
                                END IF;
                            END loop;
                        END LOOP;
                        out_mode <= '0';
                        parking_array(temp_i, temp_j).timer := out_time * TIME'val(1);
                        state <= S2;
                    END IF;
                WHEN S2 =>
                    IF (inp_mode = '1' AND price > 0) THEN
                    FOR i IN 0 TO 3 LOOP
                        FOR j IN 0 TO 3 LOOP
                            IF ((((parking_array(i, j).room_status = '1') 
                            AND (parking_array(i, j).fee > 0)) AND (inp_plat = parking_array(i, j).plate))) THEN
                                temp_i := i;
                                temp_j := j;
                                price := parking_array(temp_i, temp_j).timer/TIME'val(1) * 2000;
                            END if;
                        END loop;
                    END loop;
                REPORT "Biaya Parkir : " & INTEGER'image(price);
                parking_array(temp_i, temp_j).fee := price;
                parking_array(temp_i, temp_j).fee := price;
                out_mode <= 1;
                state <= S0;
                END if;
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE;