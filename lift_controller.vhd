library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.room_memory.all;


entity lift_controller is
    port (
        clk   : in std_logic;
        reset : in std_logic := '0';
        position_header : in std_logic_vector(3 downto 0) := (others => '0'); --kl mau parkir nilainya dpt dari function, kl mau ambil nilanya dapet dr password
        paid : in std_logic := '0';
        park_or_pick : in std_logic := '0';
        close_door : out std_logic := '0';
        ready : out std_logic := '0'

    );
end entity lift_controller;

architecture rtl of lift_controller is
    TYPE states IS (Base_floor, Search_floor, Search_room, Pick, Park);
	SIGNAL present_state, next_state : states := base_floor;   
    signal number_of_floor : integer := 0;
    signal number_of_room : integer := 0;
    signal out_park : parking_lot := parking_array;  
    signal current_floor : integer := 0;
    signal current_room : integer := 0; 
    signal lifting_state : std_logic_vector(1 downto 0) := (others => '0'); 
begin
    proc_sync : PROCESS (CLK, next_state)
	BEGIN
		IF (rising_edge(CLK))
			THEN
			present_state <= next_state;
		END IF;
	END PROCESS proc_sync;

    proc_comb : process (present_state, current_floor, current_room, lifting_state, paid, position_header)
    begin
        number_of_floor <= to_integer(unsigned(position_header(3 downto 2)));
        number_of_room <= to_integer(unsigned(position_header(1 downto 0)));
        if park_or_pick = '0' then lifting_state <= "01";
        else lifting_state <= "10"; 
        end if;

        case present_state is 
            when Base_floor =>
                if lifting_state = "00" or (lifting_state = "1-" and paid = '0') 
                    then next_state <= Base_floor;
                else next_state <= Search_floor;
                end if;

            when Search_floor =>
                if current_floor = number_of_floor then
                    next_state <= Search_room;
                else 
                    current_floor <= current_floor + 1;
                end if;
                
            
            when Search_room =>
                if current_room = number_of_room then
                    if lifting_state = "01" then
                        next_state <= Park;
                    else
                        next_state <= Pick;
                    end if;
                else 
                    current_room <= current_room + 1;
                end if;
                
            when Pick =>
                ready <= '1';
                next_state <= Base_floor;
                current_floor <= 0;
                current_room <= 0;

            when Park =>
                parking_array(number_of_floor, number_of_room).room_status := '1';
                ready <= '1';
                next_state <= Base_floor;
                current_floor <= 0;
                current_room <= 0;
        end case;
    end process;
    

end architecture;


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