library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- REGISTER MODULE 
-- (05/11) got rid of rst input - rst will be checked in registers file to set defaults to
-- every register and only in the case where rst is NOT enabled will we use load_register

entity load_register is
    port (
        -- SYSTEM INTERFACE 
        -- include async set condition?
        clk     :   in std_logic;
        wr_en   :   in std_logic; -- enables data to be written to register
        load_en :   in std_logic; -- enables value in load to be written to register asynchronously
        load    :   in std_logic_vector(31 downto 0);
        -- DATA
        d_in    :   in std_logic_vector(31 downto 0);
        d_out   :   out std_logic_vector(31 downto 0) 
    );
end load_register;

architecture Behavioral of load_register is

begin

    process (clk, load_en)
    begin
        if load_en = '1' then
            d_out   <= load;
        elsif rising_edge(clk) then
            if wr_en = '1' then
                d_out   <= d_in;
            end if;
        end if; 

    end process;

end Behavioral;
