library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity write_channel_logic_tb is
end write_channel_logic_tb;

architecture Behavioral of write_channel_logic_tb is

  component write_channel_logic
    Generic (
      C_BASEADDR : STD_LOGIC_VECTOR;
      C_HIGHADDR : STD_LOGIC_VECTOR;
      C_S_AXI_ADDR_WIDTH : INTEGER := 32;
      C_S_AXI_DATA_WIDTH : INTEGER := 32
    );
    Port (
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
    
      WriteToReg : OUT STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- Input Data
      Strobe : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- Strobe to register
      
      SRR_En : OUT STD_LOGIC;    -- Software Reset Register Enable
      SPICR_En : OUT STD_LOGIC;  -- SPI Control Register Enable
      SPIDTR_En : OUT STD_LOGIC; -- SPI Data Transmit Register Enable
      SPISSR_En : OUT STD_LOGIC; -- SPI Slave Select Register Enable
      DGIER_En : OUT STD_LOGIC;  -- Device Global Interrupt Enable Register Enable
      IPISR_En : OUT STD_LOGIC;  -- IP Interrupt Status Register Enable
      IPIER_En : OUT STD_LOGIC;  -- IP Interrupt Enable Register Enable
    
      tx_full : IN STD_LOGIC;
      arready : IN STD_LOGIC;
      temp_read_address : IN STD_LOGIC_VECTOR((C_S_AXI_ADDR_WIDTH-1) DOWNTO 0)
    );
  end component;
  
  SIGNAL S_AXI_ACLK    : STD_LOGIC := '0';
  SIGNAL S_AXI_ARESETN : STD_LOGIC;
  SIGNAL S_AXI_AWADDR  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL S_AXI_AWVALID : STD_LOGIC;
  SIGNAL S_AXI_AWREADY : STD_LOGIC;
  SIGNAL S_AXI_WDATA  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL S_AXI_WSTB   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL S_AXI_WVALID : STD_LOGIC;
  SIGNAL S_AXI_WREADY : STD_LOGIC;
  SIGNAL S_AXI_BRESP  : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL S_AXI_BVALID : STD_LOGIC;
  SIGNAL S_AXI_BREADY : STD_LOGIC;
  SIGNAL WriteToReg : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Strobe : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL SRR_En : STD_LOGIC;
  SIGNAL SPICR_En : STD_LOGIC;
  SIGNAL SPIDTR_En : STD_LOGIC;
  SIGNAL SPISSR_En : STD_LOGIC;
  SIGNAL DGIER_En : STD_LOGIC;
  SIGNAL IPISR_En : STD_LOGIC;
  SIGNAL IPIER_En : STD_LOGIC;
  SIGNAL tx_full : STD_LOGIC;
  SIGNAL arready : STD_LOGIC;
  SIGNAL temp_read_address : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin

  DUT : write_channel_logic
    Generic Map(
      C_BASEADDR => x"0000_0000",
      C_HIGHADDR => x"0000_007F"
    )
    Port Map (
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_AWREADY => S_AXI_AWREADY,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTB => S_AXI_WSTB,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BRESP => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      WriteToReg => WriteToReg,
      Strobe => Strobe,
      SRR_En => SRR_En,
      SPICR_En => SPICR_En,
      SPIDTR_En => SPIDTR_En,
      SPISSR_En => SPISSR_En,
      DGIER_En => DGIER_En,
      IPISR_En => IPISR_En,
      IPIER_En => IPIER_En,
      tx_full => tx_full,
      arready => arready,
      temp_read_address => temp_read_address
    );
    
  S_AXI_ACLK <= NOT S_AXI_ACLK after 10ns;
  S_AXI_ARESETN <= '0', '1' after 1us;
  
  tb : process
  begin
    S_AXI_AWADDR <= x"0000_0000";
    S_AXI_AWVALID <= '0';
    S_AXI_WDATA <= x"FFFF_FFFF";
    S_AXI_WSTB <= "0000";
    S_AXI_WVALID <= '0';
    S_AXI_BREADY <= '0';
    tx_full <= '0';
    arready <= '0';
    temp_read_address <= x"0000_0000";
    
    wait until S_AXI_ARESETN <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test address write entered in first before data write
    -- Test response when written to a non-existing address
    S_AXI_AWVALID <= '1';

    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    S_AXI_BREADY <= '1';
    
    wait until S_AXI_AWREADY <= '1';
    wait until S_AXI_AWREADY <= '0';
    
    S_AXI_AWVALID <= '0';
    S_AXI_WVALID <= '1';
    S_AXI_WSTB <= "0001";
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    S_AXI_WVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test data write entered in first before address write
    -- Test response when written to SRR
    S_AXI_AWADDR <= x"0000_0040";
    S_AXI_WSTB <= "0011";
    S_AXI_WVALID <= '1';

    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    S_AXI_BREADY <= '1';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '1';
    
    
    wait until S_AXI_AWREADY <= '1';
    wait until S_AXI_AWREADY <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test data write entered in at same time as address write
    -- Test response when written to SPICR and when arready = 0 while temp_read_address = 0000_0000
    S_AXI_AWADDR <= x"0000_0060";
    S_AXI_WSTB <= "1111";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when SPICR is written to and when arready = 1 and temp_read_address = 0000_0060
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    arready <= '1';
    temp_read_address <= x"0000_0060";
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when SPISR is written to
    S_AXI_AWADDR <= x"0000_0064";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    arready <= '0';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when SPIDTR is written to when tx_full = 0
    S_AXI_AWADDR <= x"0000_0068";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    arready <= '0';
    tx_full <= '0';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when SPIDTR is written to when tx_full = 1
    S_AXI_AWADDR <= x"0000_0068";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    tx_full <= '1';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when SPIDRR is written to
    S_AXI_AWADDR <= x"0000_006C";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    arready <= '0';
    tx_full <= '0';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when SPISSR is written to when arready = 1 and temp_read_address = 0000_0070
    S_AXI_AWADDR <= x"0000_0070";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    temp_read_address <= x"0000_0070";
    arready <= '1';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when SPISSR is written to when arready = 0 and temp_read_address = 0000_0070
    S_AXI_AWADDR <= x"0000_0070";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    arready <= '0';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when Tx_FIFO_OCY is written to
    S_AXI_AWADDR <= x"0000_0074";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when Rx_FIFO_OCY is written to
    S_AXI_AWADDR <= x"0000_0078";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when DGIER is written to when arready = 1 and temp read address = 0000_001C
    S_AXI_AWADDR <= x"0000_001C";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    arready <= '1';
    temp_read_address <= x"0000_001C";
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when DGIER is written to when arready = 0 and temp read address = 0000_001C
    S_AXI_AWADDR <= x"0000_001C";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    arready <= '0';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when IPISR is written to when arready = 1 and temp read address = 0000_0020
    S_AXI_AWADDR <= x"0000_0020";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    arready <= '1';
    temp_read_address <= x"0000_0020";
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when IPISR is written to when arready = 0 and temp read address = 0000_0020
    S_AXI_AWADDR <= x"0000_0020";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    arready <= '0';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when IPIER is written to when arready = 1 and temp read address = 0000_0028
    S_AXI_AWADDR <= x"0000_0028";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    arready <= '1';
    temp_read_address <= x"0000_0028";
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- Test response when IPIER is written to when arready = 0 and temp read address = 0000_0028
    S_AXI_AWADDR <= x"0000_0020";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    arready <= '0';
    
    wait until S_AXI_WREADY <= '1';
    wait until S_AXI_WREADY <= '0';
    
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_BVALID <= '0';
    S_AXI_BREADY <= '0';
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
  
    report "Test Completed";
    wait;
  end process tb;

end Behavioral;
