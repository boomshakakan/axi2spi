library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
        stb_in  :   in std_logic_vector(3 downto 0);
        -- DATA
        d_in    :   in std_logic_vector(31 downto 0);
        d_out   :   out std_logic_vector(31 downto 0) 
    );
end load_register;

architecture Behavioral of load_register is

begin

    process (clk, wr_en, load_en)
    begin
    
        if load_en = '1' then
            d_out   <= load;
        elsif rising_edge(clk) then
            if wr_en = '1' then
                for i in 0 to 3 loop -- loop length of stb_in
                    if stb_in(i) = '1' then
                        d_out(((7*(i+1))+i) downto (8*i)) <= d_in(((7*(i+1))+i) downto (8*i));
                    end if;
                end loop;
            end if;
        end if;
        
        -- i=0      7*(1)+0   <=  8*0 = 7  <= 0
        -- i=1      7*(2)+1   <=  8*1 = 15 <= 8
        -- i=2      7*(3)+2   <=  8*2 = 23 <= 16 
        -- i=3      7*(4)+3   <=  8*3 = 31 <= 24 
        
        
    end process;

end Behavioral;
