LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

USE work.room_memory.ALL;

ENTITY control_payment IS
    PORT (
        inp_mode : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        i, j : IN integer;
        inp_plat : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        out_plat : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END control_payment;

ARCHITECTURE control_payment_arch OF control_payment IS

    TYPE state_type IS (S0, S1, S2);
    SIGNAL state : state_type;

    SIGNAL out_temp : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL out_memory : parking_lot := parking_array;

BEGIN

    PROCESS (inp_mode, inp_plat, clk)

        VARIABLE inp_time : TIME := 0 ns;
        VARIABLE temp_time : TIME := 0 ns;
        VARIABLE out_time : INTEGER;
        VARIABLE price : INTEGER := 0;


    BEGIN
        out_memory <= parking_array;

        IF rising_edge(clk) THEN
            CASE state IS
                WHEN S0 =>
                    IF (inp_mode = '0' OR price > 0) THEN
                        parking_array(i, j).plate := inp_plat;
                        parking_array(i, j).timer := now;
                        state <= S1;
                    END IF;
                WHEN S1 =>
                    IF (inp_mode = '1') THEN
                        temp_time := parking_array(i, j).timer;
                        inp_time := inp_time - temp_time;
                        out_time := inp_time/TIME'val(1);
                        price := out_time * 2000;
                        parking_array(i, j).fee := price;
                        state <= S2;
                    END IF;
                WHEN S2 =>
                    IF (inp_mode = '1' AND price > 0) THEN
                        parking_array(i, j).fee := price;
                        out_plat <= out_temp;
                        REPORT "Biaya Parkir : " & INTEGER'image(price);
                        state <= S0;
                    END if;
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE;