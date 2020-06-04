library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
  
entity pin_interface is
  Generic (
    C_NUM_SS_BITS : INTEGER := 1
  ); 
  Port (
    -- External Ports
    SCK_O : OUT STD_LOGIC;
    SCK_T : OUT STD_LOGIC;
    SCK_I : IN STD_LOGIC;
    
    MOSI_O : OUT STD_LOGIC;
    MOSI_T : OUT STD_LOGIC;
    MOSI_I : IN STD_LOGIC;
    
    MISO_O : OUT STD_LOGIC;
    MISO_T : OUT STD_LOGIC;
    MISO_I : IN STD_LOGIC;
    
    SS_O : OUT STD_LOGIC_VECTOR((C_NUM_SS_BITS-1) DOWNTO 0);
    SS_T : OUT STD_LOGIC;
    SS_I : IN STD_LOGIC_VECTOR((C_NUM_SS_BITS-1) DOWNTO 0);
    
    SPISEL : IN STD_LOGIC;
    
    -- Internal Ports
    slave_clk  : OUT STD_LOGIC;
    master_clk : IN STD_LOGIC;
    
    slave_o  : IN STD_LOGIC;
    master_o : IN STD_LOGIC;
    
    slave_i  : OUT STD_LOGIC;
    master_i : OUT STD_LOGIC;
    
    master_mode : IN STD_LOGIC;
    spe         : IN STD_LOGIC;
    loopback    : IN STD_LOGIC;
    SPISSR_Read : IN STD_LOGIC_VECTOR((C_NUM_SS_BITS-1) DOWNTO 0);
    
    slave_select : OUT STD_LOGIC
  );
end pin_interface;

architecture Behavioral of pin_interface is
begin

  process (SCK_I, MISO_I, MOSI_I, SS_I, SPISEL, master_clk, slave_o,
      master_o, master_mode, spe, loopback, SPISSR_Read)
  begin
    if (SPE = '0') then
      SCK_T <= '1';
      MISO_T <= '1';
      MOSI_T <= '1';
      SS_T   <= '1';
      SCK_O <= '0';
      MISO_O <= '0';
      MOSI_O <= '0';
      SS_O   <= (OTHERS => '1');
      
      slave_clk <= '0';
      slave_i   <= '0';
      master_i  <= '0';
    
    else
      if (master_mode = '1') then
        if (loopback = '1') then
          SCK_T <= '1';
          MISO_T <= '1';
          MOSI_T <= '1';
          SS_T   <= '1';
          SCK_O <= '0';
          MISO_O <= '0';
          MOSI_O <= '0';
          SS_O   <= (OTHERS => '1');
        
          slave_clk <= '0';
          slave_i   <= slave_o;
          master_i  <= master_o;
          
        else
          if (SPISSR_Read /= ((C_NUM_SS_BITS-1) DOWNTO 0 => '1')) then
            SCK_T <= '0';
            MISO_T <= '1';
            MOSI_T <= '0';
            SS_T   <= '0';
            SCK_O <= master_clk;
            MISO_O <= '0';
            MOSI_O <= master_o;
            SS_O   <= SPISSR_Read;
        
            slave_clk <= '0';
            slave_i   <= '0';
            master_i  <= MISO_I;
          
          else
            SCK_T  <= '1';
            MISO_T <= '1';
            MOSI_T <= '1';
            SS_T   <= '1';
            SCK_O  <= master_clk;
            MISO_O <= '0';
            MOSI_O <= '0';
            SS_O   <= SPISSR_Read;
        
            slave_clk <= '0';
            slave_i   <= '0';
            master_i  <= MISO_I;
          
          end if;
        end if;
      else
        if (SPISEL = '0') then
          SCK_T <= '1';
          MISO_T <= '0';
          MOSI_T <= '1';
          SS_T   <= '1';
          SCK_O <= '0';
          MISO_O <= slave_o;
          MOSI_O <= '0';
          SS_O   <= (OTHERS => '1');
        
          slave_clk <= SCK_I;
          slave_i   <= MOSI_I;
          master_i  <= '0';
          
        else
          SCK_T <= '1';
          MISO_T <= '1';
          MOSI_T <= '1';
          SS_T   <= '1';
          SCK_O <= '0';
          MISO_O <= '0';
          MOSI_O <= '0';
          SS_O   <= (OTHERS => '1');
        
          slave_clk <= SCK_I;
          slave_i   <= MOSI_I;
          master_i  <= '0';
          
        end if;
        
      end if;
    end if;
  end process;
  
  slave_select <= SPISEL;

end Behavioral;


