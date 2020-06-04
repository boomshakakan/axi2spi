library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BRG is
  Generic (
    C_SCK_RATIO : INTEGER := 2
  );
  Port (
    clk_in : in STD_LOGIC;
    rst_n  : IN STD_LOGIC;
    clk_out : OUT STD_LOGIC
  );
end BRG;

architecture Behavioral of BRG is
  -- The clock will be divided once again when processed through clock_logic module
  CONSTANT slow_clk_freq : integer := (c_sck_ratio - 1);

  SIGNAL counter : INTEGER range 0 to slow_clk_freq ;
  SIGNAL clk_temp : std_logic := '0';

begin

  process (clk_in, rst_n)
  begin
    if (rst_n = '0') then
      counter  <= 0;
      clk_temp <= '0';
    
    elsif (rising_edge(clk_in)) then
      if (counter = slow_clk_freq) then
        counter  <= 0;
        clk_temp <= not clk_temp;

      else
        counter <= counter + 1;
        
      end if;
    end if;
  end process;

  clk_out <= clk_temp;

end Behavioral;
