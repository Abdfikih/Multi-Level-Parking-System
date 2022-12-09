LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

USE work.room_memory.ALL;
ENTITY lift_controller IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC := '0';

        -- memberi tahu posisi ruangan yang akan dituju 
        position_header : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); --kl mau parkir nilainya dpt dari function, kl mau ambil nilanya dapet dr password

        -- if pick, tell wether the client is already paid or not
        paid : IN STD_LOGIC := '0';

        --00 : no client
        --01 : park in
        --10 : pick up
        --11 : done
        lifting_state : INOUT STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');

        --0 : closed
        --1 : open
        --lift_door : OUT STD_LOGIC := '0';

        --to 1 if lifting state is 11
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

    SIGNAL out_park : parking_lot := parking_array;
   
BEGIN
    proc_sync : PROCESS (CLK, next_state)
    BEGIN
        IF (rising_edge(CLK))
            THEN
            present_state <= next_state;
        END IF;
    END PROCESS proc_sync;

    proc_comb : PROCESS (present_state, current_floor, current_room, lifting_state, paid, position_header)
    BEGIN
        number_of_floor <= to_integer(unsigned(position_header(3 DOWNTO 2)));
        number_of_room <= to_integer(unsigned(position_header(1 DOWNTO 0)));
        out_park <= parking_array;

        CASE present_state IS
            WHEN base_floor =>
                --toggling the ready signal back to 0
                if(ready = '1') then ready <= '0'; end if;

                IF lifting_state = "00" OR 
                   lifting_state = "11" OR 
                  (lifting_state = "10" and paid = '0')
                    THEN
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
                    IF lifting_state = "01" THEN
                        next_state <= Park;
                    ELSE
                        next_state <= Pick;
                    END IF;
                ELSE
                    current_room <= current_room + 1;
                END IF;

            WHEN Pick =>
                ready <= '1';
                
            WHEN Park =>
                parking_array(number_of_floor, number_of_room).room_status := '1';
                ready <= '1';
                next_state <= base_floor;
                current_floor <= 0;
                current_room <= 0;
        END CASE;

        if(ready = '1') then 
            lifting_state <= "11";
            next_state <= base_floor;
            current_floor <= 0;
            current_room <= 0;
        end if;
    END PROCESS;
END ARCHITECTURE;



--read the the lifting state : pick or put 
-- using priority encoder
-- 00 for idle
-- 01 for put
-- 10 for pick
-- 11 for done  

--read the position header to know the current floor and room
-- 1. convert the first 3 bits to integer to as the floor number
-- 2. convert the last 3 bits to integer to as the room number
--read the paid signal to know if the user has paid or not

--make model for each room, which consist 
--timer, 