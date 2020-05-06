library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- REGISTER MODULE WITH SYNCHRONOUS RESET AND LOAD

entity load_register is
    port (
        -- SYSTEM INTERFACE 
        clk     :   in std_logic;
        load    :   in std_logic;
        -- DATA
        d_in    :   in std_logic_vector(31 downto 0);
        d_out   :   out std_logic_vector(31 downto 0)
    );
end load_register;

architecture Behavioral of load_register is

begin

    process (clk)
    begin
        -- INCLUDE SYSTEM & INTERNAL RESETS?
        if rising_edge(clk) then
            if load = '1' then
                d_out   <= d_in;
            end if;
        end if;

    end process;

end Behavioral;
