library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register_p2p is
  Generic (
    C_NUM_TRANSFER_BITS : INTEGER := 8
  );
  Port (
    clk : IN STD_LOGIC;
    rst_n : IN STD_LOGIC;
    load_enable : IN STD_LOGIC;
    load : IN STD_LOGIC_VECTOR((C_NUM_TRANSFER_BITS-1) DOWNTO 0);
    r_in : IN STD_LOGIC;
    l_in : IN STD_LOGIC;
    shift_rnl : IN STD_LOGIC;
    shift_enable : IN STD_LOGIC;
    d_out : OUT STD_LOGIC_VECTOR((C_NUM_TRANSFER_BITS-1) DOWNTO 0)
  );
end shift_register_p2p;

architecture Behavioral of shift_register_p2p is

  SIGNAL d_out_temp : STD_LOGIC_VECTOR((C_NUM_TRANSFER_BITS-1) DOWNTO 0);

begin

  process (clk, rst_n, load_enable)
  begin
    if (rst_n = '0') then
      d_out_temp <= (OTHERS => '0');
    
    elsif (load_enable = '1') then
      d_out_temp <= load;
      
    elsif (rising_edge(clk)) then
      if (shift_enable = '1') then
        if (shift_rnl = '0') then
          d_out_temp <= d_out_temp((C_NUM_TRANSFER_BITS-1)-1 DOWNTO 0) & l_in;
        
        else
          d_out_temp <= r_in & d_out_temp((C_NUM_TRANSFER_BITS-1) DOWNTO 1);
        
        end if;
      end if;
    end if;
  end process;
  
  d_out <= d_out_temp;

end Behavioral;
