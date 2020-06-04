library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.axi_spi_components_pkg.Axi4Lite_Interface;
use work.axi_spi_components_pkg.axi_spi_core_registers;
use work.axi_spi_components_pkg.spi_module;

entity axi_spi is
  Generic (
    C_BASEADDR : STD_LOGIC_VECTOR; 
    C_HIGHADDR : STD_LOGIC_VECTOR;
    C_S_AXI_ADDR_WIDTH : INTEGER := 32;
    C_S_AXI_DATA_WIDTH : INTEGER := 32;
    C_FIFO_EXIST : INTEGER := 1;
    C_NUM_SS_BITS : INTEGER := 1;
    C_NUM_TRANSFER_BITS : INTEGER := 8;
    C_SCK_RATIO : INTEGER := 2
  );
  Port (
    -- AXI4-Lite Interface Ports
    S_AXI_ACLK    : IN STD_LOGIC;    -- Clock
    S_AXI_ARESETN : IN STD_LOGIC;    -- Reset Active Low
     
    S_AXI_AWADDR  : IN STD_LOGIC_VECTOR((C_S_AXI_ADDR_WIDTH-1) DOWNTO 0); -- Write Address
    S_AXI_AWVALID : IN STD_LOGIC;                                         -- Write Address Valid
    S_AXI_AWREADY : OUT STD_LOGIC;                                        -- Write Address Ready
    
    S_AXI_WDATA  : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- Write Data
    S_AXI_WSTB   : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- Write Strobes
    S_AXI_WVALID : IN STD_LOGIC;                                         -- Write Valid
    S_AXI_WREADY : OUT STD_LOGIC;                                        -- Write Ready
    
    S_AXI_BRESP  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- Write Response
    S_AXI_BVALID : OUT STD_LOGIC;                    -- Write Response Valid
    S_AXI_BREADY : IN STD_LOGIC;                     -- Write Response Ready
    
    S_AXI_ARADDR  : IN STD_LOGIC_VECTOR((C_S_AXI_ADDR_WIDTH-1) DOWNTO 0); -- Read Address
    S_AXI_ARVALID : IN STD_LOGIC;                                         -- Read Address Valid
    S_AXI_ARREADY : OUT STD_LOGIC;                                        -- Read Address Ready
   
    S_AXI_RDATA  : OUT STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- Read Data
    S_AXI_RRESP  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);                      -- Read Response
    S_AXI_RVALID : OUT STD_LOGIC;                                         -- Read Valid
    S_AXI_RREADY : IN STD_LOGIC;                                          -- Read Ready
    
    -- Interrupt Port
    IP2INTC_Irpt : OUT STD_LOGIC;
    
    -- SPI Ports
    SCK_I        : IN  STD_LOGIC;        ----- SCK INPUT FROM OUTSIDE SPI MASTER
    SCK_O        : OUT STD_LOGIC;         ----- SCK OUTPUT TO OUTSIDE SPI SLAVE
    SCK_T        : OUt STD_LOGIC;
    MISO_I       : IN  STD_LOGIC;        ----- MISO_I in master mode
    MOSI_O       : OUT STD_LOGIC;        ----- MOSI_O out master mode
    MISO_O       : OUT STD_LOGIC;        ----- MISO_O out slave mode
    MOSI_I       : IN  STD_LOGIC;        ----- MOSI_I in slave mode
    MOSI_T       : OUT STD_LOGIC;        ----- MOSI_T enable
    MISO_T       : OUT STD_LOGIC;        ----- MISO_T enable
    SS_T         : OUT STD_LOGIC; 
    SS_O         : OUT STD_LOGIC_VECTOR((C_NUM_SS_BITS-1) DOWNTO 0); ----- skave select out
    SS_I         : IN STD_LOGIC_VECTOR((C_NUM_SS_BITS-1) DOWNTO 0);
    SPISEL       : IN  STD_LOGIC        ----- SLAVE SELECT FROM OUTSIDE SPI MASTER
  );
end axi_spi;

architecture Structural of axi_spi is

  SIGNAL WriteToReg : STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- Input Data
  SIGNAL Strobe : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Strobe sent out to registers
     
  SIGNAL SRR_En : STD_LOGIC;    -- Software Reset Register Enable
  SIGNAL SPICR_En : STD_LOGIC;  -- SPI Control Register Enable
  SIGNAL SPIDTR_En : STD_LOGIC; -- SPI Data Transmit Register Enable
  SIGNAL SPISSR_En : STD_LOGIC; -- SPI Slave Select Register Enable
  SIGNAL DGIER_En : STD_LOGIC;  -- Device Global Interrupt Enable Register Enable
  SIGNAL IPISR_En : STD_LOGIC;  -- IP Interrupt Status Register Enable
  SIGNAL IPIER_En : STD_LOGIC;  -- IP Interrupt Enable Register Enable
    
  SIGNAL SPICR_Read : STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- SPI Control Register Read
  SIGNAL SPISR_Read : STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- SPI Status Register Read
  SIGNAL SPIDRR_Read : STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Data Receive Register Read
  SIGNAL SPISSR_Read : STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Slave Select Register Read
  SIGNAL Tx_FIFO_OCY_Read : STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Transmit FIFO Occupancy Register Read
  SIGNAL Rx_FIFO_OCY_Read : STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Receive FIFO Occupancy Register Read
  SIGNAL DGIER_Read : STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- Device Global Intterupt Enable Register Read
  SIGNAL IPISR_Read : STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- IP Interrupt Status Register Read
  SIGNAL IPIER_Read : STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- IP Interrupt Enable Register Read
    
  SIGNAL SPIDRR_Read_en : STD_LOGIC;                                      -- Enable read for DRR
  SIGNAL SPISR_Read_en : STD_LOGIC;
  
  SIGNAL rst_n : STD_LOGIC;
  
  SIGNAL spi_clk       : STD_LOGIC;  ----- spi clock
  SIGNAL SPICR_signal  : STD_LOGIC_VECTOR(9 DOWNTO 0);  ----- SPI CONTROL SIGNALS
  SIGNAL SPISSR_signal : STD_LOGIC_VECTOR(C_NUM_SS_BITS-1 DOWNTO 0); ----- SLAVE SELECT SIGNALS
  SIGNAL MODF          : STD_LOGIC;
  SIGNAL SLAVE_SEL_MOD : STD_LOGIC;
  SIGNAL SLAVE_MODF    : STD_LOGIC;
  SIGNAL TX_EN         : STD_LOGIC;
  SIGNAL RX_EN         : STD_LOGIC;
  SIGNAL TX_FIFO_REG   : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL RX_FIFO_REG   : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL TX_EMPTY         : STD_LOGIC;
  SIGNAL RX_FULL          : STD_LOGIC;
  SIGNAL cpha_o        : STD_LOGIC;
  SIGNAL cpol_o        : STD_LOGIC;
  
  SIGNAL end_of_transaction : STD_LOGIC;

begin

  axi_interface : Axi4Lite_Interface
    Generic Map (
      C_BASEADDR => C_BASEADDR,
      C_HIGHADDR => C_HIGHADDR,
      C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH,
      C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH
    )
    Port Map (
      S_AXI_ACLK    => S_AXI_ACLK,
      S_AXI_ARESETN => rst_n,
     
      S_AXI_AWADDR  => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_AWREADY => S_AXI_AWREADY,
    
      S_AXI_WDATA  => S_AXI_WDATA,
      S_AXI_WSTB   => S_AXI_WSTB,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_WREADY => S_AXI_WREADY,
    
      S_AXI_BRESP  => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_BREADY => S_AXI_BREADY,
    
      S_AXI_ARADDR  => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_ARREADY => S_AXI_ARREADY,
    
      S_AXI_RDATA  => S_AXI_RDATA,
      S_AXI_RRESP  => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_RREADY => S_AXI_RREADY,
    
      WriteToReg => WriteToReg,
      Strobe => Strobe,
     
      SRR_En => SRR_En,
      SPICR_En => SPICR_En,
      SPIDTR_En => SPIDTR_En,
      SPISSR_En => SPISSR_En,
      DGIER_En => DGIER_En,
      IPISR_En => IPISR_En,
      IPIER_En => IPIER_En,
    
      SPICR_Read => SPICR_Read,
      SPISR_Read => SPISR_Read,
      SPIDRR_Read => SPIDRR_Read,
      SPISSR_Read => SPISSR_Read,
      Tx_FIFO_OCY_Read => Tx_FIFO_OCY_Read,
      Rx_FIFO_OCY_Read => Rx_FIFO_OCY_Read,
      DGIER_Read => DGIER_Read,
      IPISR_Read => IPISR_Read,
      IPIER_Read => IPIER_Read,
    
      SPIDRR_Read_en => SPIDRR_Read_en,
      SPISR_Read_en => SPISR_Read_en
    );
  
  core_registers : axi_spi_core_registers
    Generic Map (
      C_FIFO_EXIST => C_FIFO_EXIST,
      C_NUM_SS_BITS => C_NUM_SS_BITS
    )
    Port Map (
      S_AXI_ACLK => S_AXI_ACLK,
      spi_clk    => spi_clk,
      S_AXI_ARESETN => S_AXI_ARESETN,
      rst_n         => rst_n,
      strobe        => Strobe,
    
      SRR_en => SRR_En,
      SPICR_en => SPICR_En,
      SPIDTR_en => SPIDTR_En,
      SPIDRR_en => RX_EN,
      SPISSR_en => SPISSR_En,
      DGIER_en => DGIER_En,
      IPISR_en => IPISR_En,
      IPIER_en => IPIER_En,

      axi_write_bus => WriteToReg,
    
      slave_mode_select_spi => SLAVE_SEL_MOD,
      modf_spi              => MODF,
      slave_modf_spi        => SLAVE_MODF,
      end_of_transaction    => end_of_transaction,
    
      SPIDRR_Write      => RX_FIFO_REG,

      SPISR_Read_en  => SPISR_Read_en,
      SPIDRR_Read_en => SPIDRR_Read_en,
      SPIDTR_Read_en => TX_EN,

      SPICR_Read       => SPICR_Read,
      SPISR_Read       => SPISR_Read,
      SPIDTR_Read      => TX_FIFO_REG,
      SPIDRR_Read      => SPIDRR_Read,
      SPISSR_Read      => SPISSR_Read,
      Tx_FIFO_OCY_Read => Tx_FIFO_OCY_Read,
      Rx_FIFO_OCY_Read => Rx_FIFO_OCY_Read,
      DGIER_Read       => DGIER_Read,
      IPISR_Read       => IPISR_Read,
      IPIER_Read       => IPIER_Read,

      IP2INTC_Irpt => IP2INTC_Irpt,
    
      SPICR_bits_synched  => SPICR_signal,
      SPISSR_bits_synched => SPISSR_signal,
      rx_full => RX_FULL,
      tx_empty => TX_EMPTY
    );

  spi : spi_module
    Generic Map (
      C_NUM_TRANSFER_BITS => C_NUM_TRANSFER_BITS,
      C_NUM_SS_BITS       => C_NUM_SS_BITS,
      C_SCK_RATIO         => C_SCK_RATIO
    )
    Port Map (
      S_AXI_ACLK => S_AXI_ACLK,
      rst_n      => rst_n,
      
      spi_clk    => spi_clk,
    
      SPISSR_Read => SPISSR_signal,

      tx_read        => TX_FIFO_REG,
      tx_read_enable => TX_EN,
      rx_write       => RX_FIFO_REG,
      rx_enable      => RX_EN,
      tx_empty       => TX_EMPTY,
      end_of_transaction => end_of_transaction,

      lsb_first                            => SPICR_signal(9),
      master_transaction_inhibit           => SPICR_signal(8),
      manual_slave_select_assertion_enable => SPICR_signal(7),
      cpha                                 => SPICR_signal(4),
      cpol                                 => SPICR_signal(3),
      master_mode                          => SPICR_signal(2),
      spe                                  => SPICR_signal(1),
      loopback                             => SPICR_signal(0),

      slave_mode_select => SLAVE_SEL_MOD,
      modf              => MODF,
      slave_modf        => SLAVE_MODF,

      MISO_O => MISO_O,
      MOSI_O => MOSI_O,
      SCK_O => SCK_O,
      SS_O   => SS_O,
      MISO_T => MISO_T,
      MOSI_T => MOSI_T,
      SCK_T => SCK_T,
      SS_T   => SS_T,
      MISO_I => MISO_I,
      MOSI_I => MOSI_I,
      SCK_I => SCK_I,
      SS_I   => SS_I,
      SPISEL => SPISEL
    );
    
end Structural;
