library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- REGISTER MODULE 
-- (05/11) got rid of rst input - rst will be checked in registers file to set defaults to
-- every register and only in the case where rst is NOT enabled will we use load_register

entity load_register is
    port (
        -- SYSTEM INTERFACE
        clk     :   in std_logic;
        wr_en   :   in std_logic; -- enables data to be written to register
        load_en :   in std_logic; -- enables value in load to be written to register asynchronously
        load    :   in std_logic_vector(31 downto 0);
        stb_in  :   in std_logic_vector(1 downto 0);
        -- DATA
        d_in    :   in std_logic_vector(31 downto 0);
        d_out   :   out std_logic_vector(31 downto 0) 
    );
end load_register;

architecture Behavioral of load_register is

begin

    -- load_en, wr_en or both for sensitivity list?
    process (clk, wr_en, load_en)
    begin
    
        if load_en = '1' then
            d_out   <= load;
        elsif rising_edge(clk) then
            if wr_en = '1' then
                case stb_in is
                    when "00"   =>
                        d_out(7 downto 0)   <= d_in(7 downto 0);
                    when "01"   =>
                        d_out(15 downto 8)  <= d_in(15 downto 8);
                    when "10"   =>
                        d_out(23 downto 16) <= d_in(23 downto 16);
                    when "11"   =>
                        d_out(31 downto 24) <= d_in(31 downto 24);
                    -- NOT SURE WHAT TO DO IN OTHERS CASE POSSIBLY ASSERT AND REPORT?
                    when others => 
                        d_out   <= d_in;
                end case;
            end if;
        end if; 

    end process;

end Behavioral;
