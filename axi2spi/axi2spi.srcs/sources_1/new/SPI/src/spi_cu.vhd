library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity spi_cu is
  Port (
    -- External Signals
    rst_n              : IN STD_LOGIC;
    tx_empty           : IN STD_LOGIC;
    SPIDTR_read_enable : OUT STD_LOGIC;
    SPIDRR_enable      : OUT STD_LOGIC;
    ss_automatic       : OUT STD_LOGIC;
    
    -- Control Register Signals
    master_mode                          : IN STD_LOGIC;
    master_transaction_inhibit           : IN STD_LOGIC;
    manual_slave_select_assertion_enable : IN STD_LOGIC;
    spe                                  : IN STD_LOGIC;
    
    -- Shift Register Signals
    load_enable  : OUT STD_LOGIC;
    shift_enable : OUT STD_LOGIC;
    
    -- Clock Logic Signals
    clk                    : IN STD_LOGIC;
    enable_master_transfer : OUT STD_LOGIC;
    master_transfer_done   : IN STD_LOGIC;
    
    -- Pin Interface Signals
    SPISEL : IN STD_LOGIC;
    
    -- Status Signals
    modf              : OUT STD_LOGIC;
    slave_modf        : OUT STD_LOGIC;
    slave_select_mode : OUT STD_LOGIC
  );
end spi_cu;

architecture Behavioral of spi_cu is
  -- States
  CONSTANT S0  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  CONSTANT S1  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
  CONSTANT S2  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
  CONSTANT S3  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
  CONSTANT S4  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
  CONSTANT S5  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
  CONSTANT S6  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
  CONSTANT S7  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
  CONSTANT S8  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
  CONSTANT S9  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
  CONSTANT S10 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
  CONSTANT S11 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";

  -- State Output Logic
  -- (SPIDTR_read_enable, SPIDRR_enable, load_enable, shift_enable, enable_master_transfer, ss_automatic)
  CONSTANT SPI_DISABLED                      : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000001";
  CONSTANT SPI_ENABLED                       : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000001";
  CONSTANT SLAVE_LOAD_SHIFT_REGISTER         : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001001";
  CONSTANT SLAVE_RECEIVE_START               : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100101";
  CONSTANT SLAVE_RECEIVE_WAIT                : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000101";
  CONSTANT SLAVE_RECEIVE_END                 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "110001";
  CONSTANT MASTER_AUTO_LOAD_SHIFT_REGISTER   : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001001";
  CONSTANT MASTER_TRANSMIT_START             : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100110";
  CONSTANT MASTER_TRANSMIT_WAIT              : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000100";
  CONSTANT MASTER_AUTO_END                   : STD_LOGIC_VECTOR(5 DOWNTO 0) := "010001";
  CONSTANT MASTER_MANUAL_LOAD_SHIFT_REGISTER : STD_LOGIC_VECTOR(5 DOWNTO 0) := "001000";
  CONSTANT MASTER_MANUAL_END                 : STD_LOGIC_VECTOR(5 DOWNTO 0) := "010000";

  SIGNAL current_state : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL next_state    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL state_output  : STD_LOGIC_VECTOR(5 DOWNTO 0);

begin

  NEXT_STATE_LOGIC : process (current_state, tx_empty, master_mode, master_transaction_inhibit,
      manual_slave_select_assertion_enable, spe, master_transfer_done, SPISEL)
  begin
    case current_state is
      when S0 =>
        if (spe = '1') then
          next_state <= S1;
        
        else
          next_state <= S0;
        
        end if;
      when S1 =>
        if (master_mode = '1') then
          if (manual_slave_select_assertion_enable = '0') then
            next_state <= S6;
            
          else
            next_state <= S10;
          end if;
        else
          next_state <= S2;
        
        end if;
      when S2 =>
        if (SPE = '0') then
          next_state <= S0;
          
        else
          if (SPISEL = '0') then
            next_state <= S3;
            
          else 
            next_state <= S2;
            
          end if;
        end if;
      when S3 =>
        next_state <= S4;
        
      when S4 =>
        if (SPISEL = '0') then
          next_state <= S4;
          
        else
          next_state <= S5;
        
        end if;
      when S5 =>
        next_state <= S2;
        
      when S6 =>
        if (SPE = '0') then
          next_state <= S0;
          
        else
          if (master_transaction_inhibit = '1') then
            next_state <= S6;
            
          else
            if (tx_empty = '1') then
              next_state <= S6;
              
            else
              next_state <= S7;
            
            end if;
          end if;
        end if;
      when S7 =>
        next_state <= S8;
      when S8 =>
        if (master_transfer_done = '0') then
          next_state <= S8;
          
        else
          if (manual_slave_select_assertion_enable = '0') then
            next_state <= S9;
            
          else
            next_state <= S11;
            
          end if;
        end if;
      when S9 =>
        next_state <= S6;
        
      when S10 =>
        if (spe = '0') then
          next_state <= S0;
          
        else
          if (master_transaction_inhibit = '1') then
            next_state <= S10;
            
          else
            if (tx_empty = '1') then
              next_state <= S10;
              
            else
              next_state <= S7;
              
            end if;
          end if;
        end if;
      when S11 =>
        next_state <= S10;
        
      when OTHERS =>
        next_state <= S0;

    end case;
  end process NEXT_STATE_LOGIC;

  NEXT_STATE_REGISTER : process (clk, rst_n)
  begin
    if (rst_n = '0') then
      current_state <= S0;
      
    elsif (rising_edge(clk)) then
      current_state <= next_state;
    
    end if;
  end process NEXT_STATE_REGISTER;
  
  OUTPUT_LOGIC : process (current_state, tx_empty, master_mode, master_transaction_inhibit,
      manual_slave_select_assertion_enable, spe, master_transfer_done, SPISEL)
  begin
    case current_state is
      when S0     => state_output <= SPI_DISABLED;
      when S1     => state_output <= SPI_ENABLED;
      when S2     => state_output <= SLAVE_LOAD_SHIFT_REGISTER;
      when S3     => state_output <= SLAVE_RECEIVE_START;
      when S4     => state_output <= SLAVE_RECEIVE_WAIT;
      when S5     => state_output <= SLAVE_RECEIVE_END;
      when S6     => state_output <= MASTER_AUTO_LOAD_SHIFT_REGISTER;
      when S7     => state_output <= MASTER_TRANSMIT_START;
      when S8     => state_output <= MASTER_TRANSMIT_WAIT;
      when S9     => state_output <= MASTER_AUTO_END;
      when S10    => state_output <= MASTER_MANUAL_LOAD_SHIFT_REGISTER;
      when S11    => state_output <= MASTER_MANUAL_END;
      when OTHERS => state_output <= SPI_DISABLED;
      
    end case;
  end process OUTPUT_LOGIC;

  SPIDTR_read_enable     <= state_output(5);
  SPIDRR_enable          <= state_output(4);
  load_enable            <= state_output(3);
  shift_enable           <= state_output(2);
  enable_master_transfer <= state_output(1);
  ss_automatic           <= state_output(0);
  
  modf <= (NOT SPISEL) AND master_mode;
  slave_modf <= (NOT SPISEL) AND (NOT master_mode) AND (NOT spe);
  slave_select_mode <= (NOT master_mode) AND (NOT SPISEL);

end Behavioral;
