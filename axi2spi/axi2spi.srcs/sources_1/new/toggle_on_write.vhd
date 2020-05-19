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
        d_out   :   out std_logic_vector(31 downto 0)
    );
end toggle_on_write;

architecture Behavioral of toggle_on_write is
    -- temporary bit vector to hold the value of d_out for logic
    signal b_out    : std_logic_vector(31 downto 0);

begin

    process (clk, load_en)
    begin
        if load_en = '1' then
            b_out   <= load;
        elsif rising_edge(clk) then
            if wr_en = '1' then
                -- hard code the 9 significant bits for toggling
                --b_out(0)    <= d_in(0) xor b_out(0); -- MODF
                --b_out(1)    <= d_in(1) xor b_out(1); -- Slave MODF
                --b_out(2)    <= d_in(2) xor b_out(2); -- DTR Empty
                --b_out(3)    <= d_in(3) xor b_out(3); -- DTR Under-run
                --b_out(4)    <= d_in(4) xor b_out(4); -- DRR Full
                --b_out(5)    <= d_in(5) xor b_out(5); -- DRR Over-run
                --b_out(6)    <= d_in(6) xor b_out(6); -- Tx FIFO Half Empty
                --b_out(7)    <= d_in(7) xor b_out(7); -- Slave Mode Select
                --b_out(8)    <= d_in(8) xor b_out(8); -- DRR Not Empty
                b_out   <= d_in xor b_out;
            end if;
        end if;
    
    end process;
    
    d_out   <= b_out;
    
end Behavioral;
