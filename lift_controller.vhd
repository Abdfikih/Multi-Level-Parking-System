LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

USE work.room_memory.ALL;
ENTITY lift_controller IS
    PORT (
        clk : IN STD_LOGIC;
        position_header : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); 
        enable : IN STD_LOGIC := '0';
        mode : IN STD_LOGIC := '0';
        ready : INOUT STD_LOGIC := '0'

    );
END ENTITY lift_controller;

ARCHITECTURE rtl OF lift_controller IS
    TYPE states IS (base_floor, search_floor, search_room, pick, park);
    SIGNAL present_state, next_state : states := base_floor;

    SIGNAL number_of_floor : INTEGER := 0;
    SIGNAL number_of_room : INTEGER := 0;
    SIGNAL current_floor : INTEGER := 0;
    SIGNAL current_room : INTEGER := 0;
    SIGNAL lifting_state : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL out_park : parking_lot := parking_array;

BEGIN
    proc_sync : PROCESS (CLK, next_state)
    BEGIN
        IF (rising_edge(CLK))
            THEN
            present_state <= next_state;
        END IF;
    END PROCESS proc_sync;

    proc_comb : PROCESS (present_state, current_floor, current_room, lifting_state, mode, enable, position_header)
    BEGIN
        number_of_floor <= to_integer(unsigned(position_header(3 DOWNTO 2)));
        number_of_room <= to_integer(unsigned(position_header(1 DOWNTO 0)));
        out_park <= parking_array;

        CASE present_state IS
            WHEN base_floor =>
                --toggling the ready signal back to 0
                IF (ready = '1') THEN
                    ready <= '0';
                END IF;

                IF enable = '0' THEN
                    next_state <= base_floor;
                ELSE
                    next_state <= search_floor;
                END IF;

            WHEN search_floor =>
                IF current_floor = number_of_floor THEN
                    next_state <= search_room;
                ELSE
                    current_floor <= current_floor + 1;
                END IF;

            WHEN search_room =>
                IF current_room = number_of_room THEN
                    IF mode = '1' THEN
                        next_state <= Park;
                    ELSE
                        next_state <= Pick;
                    END IF;
                ELSE
                    current_room <= current_room + 1;
                END IF;

            WHEN Pick =>
                ready <= '1';
                next_state <= base_floor;
                current_floor <= 0;
                current_room <= 0;

            WHEN Park =>
                ready <= '1';
                next_state <= base_floor;
                current_floor <= 0;
                current_room <= 0;
        END CASE;

        IF (ready = '1') THEN
            --lifting_state <= "11";
            next_state <= base_floor;
            current_floor <= 0;
            current_room <= 0;
        END IF;
    END PROCESS;
END ARCHITECTURE;