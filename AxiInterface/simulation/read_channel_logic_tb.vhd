library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity read_channel_logic_tb is
end read_channel_logic_tb;

architecture Behavioral of read_channel_logic_tb is

  component read_channel_logic
    Generic (
      C_BASEADDR : STD_LOGIC_VECTOR;
      C_HIGHADDR : STD_LOGIC_VECTOR;
      C_S_AXI_ADDR_WIDTH : INTEGER := 32;
      C_S_AXI_DATA_WIDTH : INTEGER := 32
    );
    Port (
      S_AXI_ACLK    : IN STD_LOGIC;    -- Clock
      S_AXI_ARESETN : IN STD_LOGIC;    -- Reset Active Low
    
      S_AXI_ARADDR  : IN STD_LOGIC_VECTOR((C_S_AXI_ADDR_WIDTH-1) DOWNTO 0); -- Read Address
      S_AXI_ARVALID : IN STD_LOGIC;                                         -- Read Address Valid
      S_AXI_ARREADY : OUT STD_LOGIC;                                        -- Read Address Ready
    
      S_AXI_RDATA  : OUT STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- Read Data
      S_AXI_RRESP  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);                      -- Read Response
      S_AXI_RVALID : OUT STD_LOGIC;                                         -- Read Valid
      S_AXI_RREADY : IN STD_LOGIC;                                          -- Read Ready
    
      SPICR_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- SPI Control Register Read
      SPISR_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- SPI Status Register Read
      SPIDRR_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Data Receive Register Read
      SPISSR_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Slave Select Register Read
      Tx_FIFO_OCY_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Transmit FIFO Occupancy Register Read
      Rx_FIFO_OCY_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Receive FIFO Occupancy Register Read
      DGIER_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- Device Global Intterupt Enable Register Read
      IPISR_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- IP Interrupt Status Register Read
      IPIER_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0)   -- IP Interrupt Enable Register Read
    );
  end component;
  
  SIGNAL S_AXI_ACLK : STD_LOGIC := '0';
  SIGNAL S_AXI_ARESETN : STD_LOGIC;
  SIGNAL S_AXI_ARADDR : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL S_AXI_ARVALID : STD_LOGIC;
  SIGNAL S_AXI_ARREADY : STD_LOGIC;
  SIGNAL S_AXI_RDATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL S_AXI_RRESP : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL S_AXI_RVALID : STD_LOGIC;
  SIGNAL S_AXI_RREADY : STD_LOGIC;
  SIGNAL SPICR_READ : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0001";
  SIGNAL SPISR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0002";
  SIGNAL SPIDDR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0003";
  SIGNAL SPISSR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0004";
  SIGNAL Tx_FIFO_OCY_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0005";
  SIGNAL Rx_FIFO_OCY_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0006";
  SIGNAL DGIER_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0007";
  SIGNAL IPISR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0008";
  SIGNAL IPIER_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0009";

begin

  DUT : read_channel_logic
    Generic Map (
      C_BASEADDR => x"0000_0000",
      C_HIGHADDR => x"0000_007F"
    )
    Port Map (
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      SPICR_Read => SPICR_Read,
      SPISR_Read => SPISR_Read,
      SPIDRR_Read => SPIDDR_Read,
      SPISSR_Read => SPISSR_Read,
      Tx_FIFO_OCY_Read => Tx_FIFO_OCY_Read,
      Rx_FIFO_OCY_Read => Rx_FIFO_OCY_Read,
      DGIER_Read => DGIER_Read,
      IPISR_Read => IPISR_Read,
      IPIER_Read => IPIER_Read
    );
    
  S_AXI_ACLK <= NOT S_AXI_ACLK after 10ns;
  S_AXI_ARESETN <= '0', '1' after 1us;
    
  tb : process
  begin
    S_AXI_ARADDR <= x"0000_0000";
    S_AXI_ARVALID <= '0';
    S_AXI_RREADY <= '0';
    wait for 10ns;
    
    wait until S_AXI_ARESETN <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test if RVALID will go high if ARVALID goes high first before RREADY
    -- Test non existing address response and read data
    S_AXI_ARVALID <= '1';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test if RVALID will go high if RREADY goes high first before ARVALID
    -- Test non-readable address (SSR) response and read data
    S_AXI_ARADDR <= x"0000_0040";
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    S_AXI_ARVALID <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test if RVALID goes high if RREADY and ARVALID go high at the same time
    -- Test read response and read data of SPISR
    S_AXI_ARADDR <= x"0000_0060";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test read response and read data of SPISR
    S_AXI_ARADDR <= x"0000_0064";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test read response and read data of SPIDTR
    S_AXI_ARADDR <= x"0000_0068";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test read response and read data of SPIDRR
    S_AXI_ARADDR <= x"0000_006C";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test read response and read data of SPISSR
    S_AXI_ARADDR <= x"0000_0070";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test read response and read data of Tx_FIFO_OCY
    S_AXI_ARADDR <= x"0000_0074";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test read response and read data of Rx_FIFO_OCY
    S_AXI_ARADDR <= x"0000_0078";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test read response and read data of DGIER
    S_AXI_ARADDR <= x"0000_001C";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test read response and read data of IPISR
    S_AXI_ARADDR <= x"0000_0020";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test read response and read data of IPIER
    S_AXI_ARADDR <= x"0000_0028";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ARREADY <= '1';
    wait until S_AXI_ARREADY <= '0';
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_RVALID <= '0';
    S_AXI_RREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
  
    report "Test Completed";
    wait;
  end process tb;

end Behavioral;
