library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.axi_spi_components_pkg.clock_logic;
use work.axi_spi_components_pkg.shift_register_p2p;
use work.axi_spi_components_pkg.spi_cu;
use work.axi_spi_components_pkg.pin_interface;
use work.axi_spi_components_pkg.BRG;

entity spi_module is
  Generic (
    C_NUM_TRANSFER_BITS : INTEGER := 8;
    C_NUM_SS_BITS : INTEGER := 1;
    C_SCK_RATIO : INTEGER := 2
  );
  Port (
    -- Internal Ports
    S_AXI_ACLK : IN STD_LOGIC;
    rst_n : IN STD_LOGIC;
    
    spi_clk : OUT STD_LOGIC;
    
    SPISSR_Read : IN STD_LOGIC_VECTOR((C_NUM_SS_BITS-1) DOWNTO 0);

    tx_read : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    tx_read_enable : OUT STD_LOGIC;
    rx_write : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rx_enable : OUT STD_LOGIC;
    tx_empty : IN STD_LOGIC;
    end_of_transaction : OUT STD_LOGIC;

    lsb_first                            : IN STD_LOGIC;
    master_transaction_inhibit           : IN STD_LOGIC;
    manual_slave_select_assertion_enable : IN STD_LOGIC;
    cpha                                 : IN STD_LOGIC;
    cpol                                 : IN STD_LOGIC;
    master_mode                          : IN STD_LOGIC;
    spe                                  : IN STD_LOGIC;
    loopback                             : IN STD_LOGIC;

    slave_mode_select : OUT STD_LOGIC;
    modf              : OUT STD_LOGIC;
    slave_modf        : OUT STD_LOGIC;
    
    -- External Ports
    MISO_O : OUT STD_LOGIC;
    MOSI_O : OUT STD_LOGIC;
    SCK_O  : OUT STD_LOGIC;
    SS_O   : OUT STD_LOGIC_VECTOR((C_NUM_SS_BITS-1) DOWNTO 0);
    MISO_T : OUT STD_LOGIC;
    MOSI_T : OUT STD_LOGIC;
    SCK_T  : OUT STD_LOGIC;
    SS_T   : OUT STD_LOGIC;
    MISO_I : IN STD_LOGIC;
    MOSI_I : IN STD_LOGIC;
    SCK_I  : IN STD_LOGIC;
    SS_I   : IN STD_LOGIC_VECTOR((C_NUM_SS_BITS-1) DOWNTO 0);
    SPISEL : IN STD_LOGIC
  );
end spi_module;

architecture Structural of spi_module is

  SIGNAL brg_clk : STD_LOGIC;
  
  SIGNAL control_unit_clk : STD_LOGIC;
  SIGNAL enable_master_transfer : STD_LOGIC;
  SIGNAL master_transfer_done : STD_LOGIC;
  SIGNAL master_clk_o : STD_LOGIC;
  SIGNAL slave_clk_i : STD_LOGIC;
  SIGNAL shift_register_clk : STD_LOGIC;
  
  SIGNAL load_enable : STD_LOGIC;
  SIGNAL shift_enable : STD_LOGIC;
  SIGNAL shift_register_out : STD_LOGIC_VECTOR((C_NUM_TRANSFER_BITS-1) DOWNTO 0);
  
  SIGNAL ss_automatic : STD_LOGIC;
  
  SIGNAL slave_select : STD_LOGIC;
  SIGNAL slave_i : STD_LOGIC;
  SIGNAL master_i : STD_LOGIC;
  
  SIGNAL serial_out : STD_LOGIC;
  SIGNAL serial_in : STD_LOGIC;
  SIGNAL slave_select_out : STD_LOGIC_VECTOR((C_NUM_SS_BITS-1) DOWNTO 0);
  
  SIGNAL shift_enable_temp : STD_LOGIC;

begin

  baud_rate_generator : BRG
    Generic Map (
      C_SCK_RATIO => C_SCK_RATIO
    )
    Port Map (
      clk_in  => S_AXI_ACLK,
      rst_n   => rst_n,
      clk_out => brg_clk
    );
    
  internal_clock_logic : clock_logic
    Generic Map (
      C_NUM_TRANSFER_BITS => C_NUM_TRANSFER_BITS
    )
    Port Map (
      system_clk             => brg_clk,
      rst_n                  => rst_n,
      enable_master_transfer => enable_master_transfer,
      master_transfer_done   => master_transfer_done,
    
      master_mode => master_mode,
      cpol        => cpol,
      cpha        => cpha,
    
      control_unit_clk   => control_unit_clk,
      master_clk_o       => master_clk_o,
      slave_clk_i        => slave_clk_i,
      shift_register_clk => shift_register_clk
    );
  spi_clk <= control_unit_clk;
    
  shift_register : shift_register_p2p
    Generic Map (
      C_NUM_TRANSFER_BITS => C_NUM_TRANSFER_BITS
    )
    Port Map (
      clk          => shift_register_clk,
      rst_n        => rst_n,
      load_enable  => load_enable,
      load         => tx_read((C_NUM_TRANSFER_BITS-1) DOWNTO 0),
      r_in         => serial_in,
      l_in         => serial_in,
      shift_rnl    => lsb_first,
      shift_enable => shift_enable_temp,
      d_out        => shift_register_out
    );
  shift_enable_temp <= shift_enable when (master_mode = '1')else (NOT slave_select);
  rx_write((C_NUM_TRANSFER_BITS-1) DOWNTO 0) <= shift_register_out;
  pad_rx_reg : if (C_NUM_TRANSFER_BITS < 32) generate
    rx_write(31 DOWNTO C_NUM_TRANSFER_BITS) <= (OTHERS => '0');

  end generate pad_rx_reg;
  
  end_of_transaction <= load_enable;
  
  control_unit : spi_cu
    Port Map (
      rst_n              => rst_n,
      tx_empty           => tx_empty,
      SPIDTR_read_enable => tx_read_enable,
      SPIDRR_enable      => rx_enable,
      ss_automatic       => ss_automatic,
      
      master_mode                          => master_mode,
      master_transaction_inhibit           => master_transaction_inhibit,
      manual_slave_select_assertion_enable => manual_slave_select_assertion_enable,
      spe                                  => spe,

      load_enable  => load_enable,
      shift_enable => shift_enable,

      clk                    => control_unit_clk,
      enable_master_transfer => enable_master_transfer,
      master_transfer_done   => master_transfer_done,

      SPISEL => slave_select,

      modf              => modf,
      slave_modf        => slave_modf,
      slave_select_mode => slave_mode_select
    );
    
    
  spi_pin_interface : pin_interface
    Generic Map (
      C_NUM_SS_BITS => C_NUM_SS_BITS
    )
    Port Map (
      SCK_O => SCK_O,
      SCK_T => SCK_T,
      SCK_I => SCK_I,
    
      MOSI_O => MOSI_O,
      MOSI_T => MOSI_T,
      MOSI_I => MOSI_I,
    
      MISO_O => MISO_O,
      MISO_T => MISO_T,
      MISO_I => MISO_I,
    
      SS_O => SS_O,
      SS_T => SS_T,
      SS_I => SS_I,
    
      SPISEL => SPISEL,

      slave_clk  => slave_clk_i,
      master_clk => master_clk_o,
    
      slave_o  => serial_out,
      master_o => serial_out,
    
      slave_i  => slave_i,
      master_i => master_i,
    
      master_mode => master_mode,
      spe         => spe,
      loopback    => loopback,
      SPISSR_Read => slave_select_out,
    
      slave_select => slave_select
    );  
  serial_out <= shift_register_out(0) when (lsb_first = '1') else shift_register_out(C_NUM_TRANSFER_BITS-1);
  serial_in  <= slave_i when (master_mode = '0') else master_i;
  slave_select_out <= SPISSR_Read when (ss_automatic = '0') else (OTHERS => '1');
  
end Structural;
