library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_logic is
  Generic (
    C_NUM_TRANSFER_BITS : INTEGER := 8
  );
  Port (
    system_clk : IN STD_LOGIC;
    rst_n : IN STD_LOGIC;
    enable_master_transfer : IN STD_LOGIC;
    master_transfer_done : OUT STD_LOGIC;
    
    master_mode : IN STD_LOGIC;
    cpol : IN STD_LOGIC;
    cpha : IN STD_LOGIC;
    
    control_unit_clk : OUT STD_LOGIC;
    master_clk_o : OUT STD_LOGIC;
    slave_clk_i : IN STD_LOGIC;
    shift_register_clk : OUT STD_LOGIC
  );
end clock_logic;

architecture Behavioral of clock_logic is

  CONSTANT EDGE_COUNT : INTEGER := (C_NUM_TRANSFER_BITS * 2);

  SIGNAL master_edge_count : INTEGER;
  SIGNAL shift_register_edge_count : INTEGER;
  SIGNAL master_clk_o_temp : STD_LOGIC;
  SIGNAL shift_register_clk_temp  : STD_LOGIC;
  SIGNAL control_unit_clk_temp : STD_LOGIC;
  SIGNAL transfer_in_progress : STD_LOGIC;
  SIGNAL shifting_in_progress : STD_LOGIC;
  
  SIGNAL slave_clk_i_temp : STD_LOGIC;

begin

  master_clock_logic : process (system_clk, rst_n)
  begin
    if (rst_n = '0') then
      transfer_in_progress <= '0';
      master_clk_o_temp <= '0';
      master_edge_count <= 0;
      
    elsif (rising_edge(system_clk)) then
      if (master_mode = '1') then
        if ((enable_master_transfer = '1') AND (transfer_in_progress = '0')) then
          transfer_in_progress <= '1';
          master_clk_o_temp <= NOT cpol;
          master_edge_count <= master_edge_count + 1;
        
        elsif (transfer_in_progress  = '1') then
          if (master_edge_count < EDGE_COUNT) then
            master_clk_o_temp <= NOT master_clk_o_temp;
            master_edge_count <= master_edge_count + 1;
            
          else
            transfer_in_progress <= '0';
            master_edge_count <= 0;
            
          end if;
        end if;
      end if;
    end if;
  end process master_clock_logic;
  
  shift_reg_clk_logic : process (system_clk, rst_n)
  begin
    if (rst_n = '0') then
      shifting_in_progress <= '0';
      shift_register_clk_temp <= '0';
      shift_register_edge_count <= 0;
      
    elsif (rising_edge(system_clk)) then
      if (master_mode = '1') then
        if ((transfer_in_progress = '1') AND (shifting_in_progress = '0')) then
          shifting_in_progress <= '1';
          if (cpha = '0') then
            shift_register_clk_temp <= NOT shift_register_clk_temp;
            shift_register_edge_count <= shift_register_edge_count + 1;
              
          end if;
        elsif (shifting_in_progress = '1') then
          if (shift_register_edge_count < EDGE_COUNT) then
            shift_register_clk_temp <= NOT shift_register_clk_temp;
            shift_register_edge_count <= shift_register_edge_count + 1;
            
          else
            shifting_in_progress <= '0';
            shift_register_edge_count <= 0;
            
          end if;
        end if;
      end if;
    end if;
  end process shift_reg_clk_logic;

  master_transfer_done <= NOT transfer_in_progress;
  master_clk_o <= master_clk_o_temp when (transfer_in_progress = '1') else cpol;
  
  slave_clock : process (slave_clk_i, cpol, cpha)
  begin
    if ((cpol = '0' AND cpha = '0') OR (cpol = '1' AND cpha = '1')) then
      slave_clk_i_temp <= slave_clk_i;
    
    else
      slave_clk_i_temp <= NOT slave_clk_i;
    
    end if;
  
  end process slave_clock;
  
  control_unit_clock : process (system_clk, rst_n)
  begin
    if (rst_n = '0') then
      control_unit_clk_temp <= '0';
    
    elsif (rising_edge(system_clk)) then
      control_unit_clk_temp <= NOT control_unit_clk_temp;
      
    end if;
  end process control_unit_clock;
  
  control_unit_clk <= control_unit_clk_temp;
  shift_register_clk <= slave_clk_i_temp when (master_mode = '0') else shift_register_clk_temp;
  
end Behavioral;
