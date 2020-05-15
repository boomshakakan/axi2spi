library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toggle_on_write is
    port (
        -- SYSTEM INTERFACE
        clk     :   in std_logic;
        wr_en   :   in std_logic;
        load_en :   in std_logic;
        load    :   in std_logic_vector(31 downto 0);
        -- DATA
        d_in    :   in std_logic_vector(31 downto 0);
        d_out   :   inout std_logic_vector(31 downto 0)
    );
end toggle_on_write;

architecture Behavioral of toggle_on_write is

begin

    process (clk, load_en)
    begin
        if load_en = '1' then
            d_out   <= load;
        elsif rising_edge(clk) then
            if wr_en = '1' then
                -- hard code the 9 significant bits for toggling
                d_out(0)    <= d_in(0) xor d_out(0); -- MODF
                d_out(1)    <= d_in(1) xor d_out(1); -- Slave MODF
                d_out(2)    <= d_in(2) xor d_out(2); -- DTR Empty
                d_out(3)    <= d_in(3) xor d_out(3); -- DTR Under-run
                d_out(4)    <= d_in(4) xor d_out(4); -- DRR Full
                d_out(5)    <= d_in(5) xor d_out(5); -- DRR Over-run
                d_out(6)    <= d_in(6) xor d_out(6); -- Tx FIFO Half Empty
                d_out(7)    <= d_in(7) xor d_out(7); -- Slave Mode Select
                d_out(8)    <= d_in(8) xor d_out(8); -- DRR Not Empty
            end if;
        end if;
    
    end process;


end Behavioral;
