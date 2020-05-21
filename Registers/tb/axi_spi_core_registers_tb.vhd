library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.axi_spi_components_pkg.axi_spi_core_registers;

entity axi_spi_core_registers_tb is
end axi_spi_core_registers_tb;

architecture Behavioral of axi_spi_core_registers_tb is
  
    SIGNAL S_AXI_ACLK : STD_LOGIC := '0';
    SIGNAL spi_clk    : STD_LOGIC := '0';
    SIGNAL S_AXI_ARESETN : STD_LOGIC;
    SIGNAL rst_n         : STD_LOGIC;
    SIGNAL strobe        : STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    SIGNAL SRR_en : STD_LOGIC;
    SIGNAL SPICR_en : STD_LOGIC;
    SIGNAL SPIDTR_en : STD_LOGIC;
    SIGNAL SPIDRR_en : STD_LOGIC;
    SIGNAL SPISSR_en : STD_LOGIC;
    SIGNAL DGIER_en       :   STD_LOGIC;
    SIGNAL IPISR_en        :   STD_LOGIC;
    SIGNAL IPIER_en        :   STD_LOGIC;
          
    -- REGISTER WRITE DATA INPUT
    SIGNAL axi_write_bus     : STD_LOGIC_VECTOR(31 DOWNTO 0);   -- data to be written to registers
    
    SIGNAL slave_mode_select_spi : STD_LOGIC; -- SPISR input from SPI
    SIGNAL modf_spi              : STD_LOGIC; -- SPISR input from SPI
    SIGNAL slave_modf_spi        : STD_LOGIC;
    
    SIGNAL SPIDRR_Write      : STD_LOGIC_VECTOR(31 DOWNTO 0);
        
    -- REGISTER READ ENABLES
    SIGNAL SPISR_Read_en  : STD_LOGIC; -- Used to clear MODF bit
    SIGNAL SPIDRR_Read_en : STD_LOGIC; -- Used to read from FIFO to AXI interface
    SIGNAL SPIDTR_Read_en : STD_LOGIC; -- Used to read from transfer register to SPI 
        
    -- REGISTER READ DATA OUTPUT
    SIGNAL SPICR_Read       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SPISR_Read       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SPIDTR_Read      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SPIDRR_Read      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SPISSR_Read      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Tx_FIFO_OCY_Read : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Rx_FIFO_OCY_Read : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL DGIER_Read       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IPISR_Read       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IPIER_Read       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    -- EXTERNAL INTERRUPT
    SIGNAL IP2INTC_Irpt : STD_LOGIC;
    
    -- REG TO SPI
    SIGNAL SPICR_bits_synched  : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL SPISSR_bits_synched : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL rx_full : STD_LOGIC;
    SIGNAL tx_empty : STD_LOGIC;

begin

  DUT : axi_spi_core_registers
    Generic Map (
      C_FIFO_EXIST => 1,
      C_NUM_SS_BITS => 2
    )
    Port Map (
      S_AXI_ACLK => S_AXI_ACLK,
      spi_clk    => spi_clk,
      S_AXI_ARESETN => S_AXI_ARESETN,
      rst_n         => rst_n,
      strobe        => strobe,
    
      SRR_en => SRR_en,
      SPICR_en => SPICR_en,
      SPIDTR_en => SPIDTR_en,
      SPIDRR_en => SPIDRR_en,
      SPISSR_en => SPISSR_en,
      DGIER_en => DGIER_en,
      IPISR_en   => IPISR_en,
      IPIER_en  => IPIER_en,
      axi_write_bus => axi_write_bus,
      slave_mode_select_spi => slave_mode_select_spi,
      modf_spi => modf_spi,
      slave_modf_spi  => slave_modf_spi,
      SPIDRR_Write    => SPIDRR_Write,
      SPISR_Read_en  => SPISR_Read_en,
      SPIDRR_Read_en => SPIDRR_Read_en,
      SPIDTR_Read_en => SPIDTR_Read_en,
      SPICR_Read     => SPICR_Read,
      SPISR_Read      => SPISR_Read,
      SPIDTR_Read     => SPIDTR_Read,
      SPIDRR_Read      => SPIDRR_Read,
      SPISSR_Read      => SPISSR_Read,
      Tx_FIFO_OCY_Read => Tx_FIFO_OCY_Read,
      Rx_FIFO_OCY_Read => Rx_FIFO_OCY_Read,
      DGIER_Read       => DGIER_Read,
      IPISR_Read      => IPISR_Read,
      IPIER_Read      => IPIER_Read,
      IP2INTC_Irpt    => IP2INTC_Irpt,
      SPICR_bits_synched => SPICR_bits_synched,
      SPISSR_bits_synched => SPISSR_bits_synched,
      rx_full => rx_full,
      tx_empty => tx_empty
    );
  
  -- Clock generator and power-on-reset
  S_AXI_ACLK <= NOT S_AXI_ACLK after 10ns;
  spi_clk    <= NOT spi_clk after 20ns;
  S_AXI_ARESETN <= '0', '1' after 1us;
  
  tb : process
  begin
    strobe <= "1111";
    SRR_en <= '0';
    SPICR_en <= '0';
    SPIDTR_en <= '0';
    SPIDRR_en <= '0';
    SPISSR_en <= '0';
    DGIER_en  <= '0';
    IPISR_en  <= '0';
    IPIER_en  <= '0';
    axi_write_bus     <= x"FFFF_FFFF";
    slave_mode_select_spi <= '0';
    modf_spi              <= '0';
    slave_modf_spi        <= '0';
    SPIDRR_Write      <= x"AAAA_AAAA";
    SPISR_Read_en  <= '0';
    SPIDRR_Read_en <= '0';
    SPIDTR_Read_en <= '0';
        
    wait until S_AXI_ARESETN <= '0';
    wait until S_AXI_ARESETN <= '1';
    wait until S_AXI_ACLK <= '0';
  
    SRR_en <= '1';
    SPICR_en <= '1';
    SPIDTR_en <= '0';
    SPIDRR_en <= '0';
    SPISSR_en <= '1';
    DGIER_en  <= '0';
    IPISR_en  <= '0';
    IPIER_en  <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    axi_write_bus <= x"8000_0100";
    SRR_en <= '0';
    SPICR_en <= '0';
    SPIDTR_en <= '0';
    SPIDRR_en <= '0';
    SPISSR_en <= '0';
    DGIER_en  <= '1';
    IPISR_en  <= '0';
    IPIER_en  <= '1';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    SPIDTR_en <= '1';
    SPIDRR_en <= '1';
    
    wait until rx_full <= '1';
    
    SPIDTR_en <= '0';
    SPIDRR_en <= '0';
  
    report "TEST COMPLETED";
    wait;
  end process tb;
 
end Behavioral;
