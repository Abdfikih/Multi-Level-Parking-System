LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
ENTITY mux_4to1 IS
    PORT (
        PlatIn, PlatOut : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        PassIn, PassOut : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        Zout : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END mux_4to1;

ARCHITECTURE bhv OF mux_4to1 IS
    CONSTANT NUM : std_logic_vector (15 DOWNTO 0) := "0000000000000000";
BEGIN
    PROCESS (PlatIn, PlatOut, PassIn, PassOut, Sel) IS
    BEGIN
        IF (Sel = "00") THEN
            Zout <= NUM & PlatIn;
        ELSIF (Sel = "01") THEN
            Zout <= NUM & PlatOut;
        ELSIF (Sel = "10") THEN
            Zout <= PassIn;
        ELSE
            Zout <= PassOut;
        END IF;

    END PROCESS;
END bhv;