

library ieee;
use ieee.std_logic_1164.all;

package multilevel_types is

    type state_type is (IDLE, SELECTMODE, CARIN, CAROUT, PASSSUCCESS, PASSFAIL, OVERLOAD,INSUCCESS,LICENSEINSERT);


end package;