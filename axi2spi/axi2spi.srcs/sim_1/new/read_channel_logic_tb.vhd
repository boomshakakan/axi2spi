library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
      IPIER_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- IP Interrupt Enable Register Read
      
      temp_read_address_out : OUT STD_LOGIC_VECTOR((C_S_AXI_ADDR_WIDTH-1) DOWNTO 0);
      SPIDRR_Read_en : OUT STD_LOGIC;
      SPISR_Read_en : OUT STD_LOGIC
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
  SIGNAL SPIDRR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0003";
  SIGNAL SPISSR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0004";
  SIGNAL Tx_FIFO_OCY_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0005";
  SIGNAL Rx_FIFO_OCY_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0006";
  SIGNAL DGIER_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0007";
  SIGNAL IPISR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0008";
  SIGNAL IPIER_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0009";
  SIGNAL temp_read_address_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SPIDRR_Read_en : STD_LOGIC;
  SIGNAL SPISR_Read_en : STD_LOGIC;
  
  SIGNAL address_read_handshake_complete : BOOLEAN;
  SIGNAL read_response_handshake_complete : BOOLEAN;

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
      SPIDRR_Read => SPIDRR_Read,
      SPISSR_Read => SPISSR_Read,
      Tx_FIFO_OCY_Read => Tx_FIFO_OCY_Read,
      Rx_FIFO_OCY_Read => Rx_FIFO_OCY_Read,
      DGIER_Read => DGIER_Read,
      IPISR_Read => IPISR_Read,
      IPIER_Read => IPIER_Read,
      temp_read_address_out => temp_read_address_out,
      SPIDRR_Read_en => SPIDRR_Read_en,
      SPISR_Read_en => SPISR_Read_en
    );
    
  -- Clock generator and power-on-reset
  S_AXI_ACLK <= NOT S_AXI_ACLK after 10ns;
  S_AXI_ARESETN <= '0', '1' after 1us;
  
  -- Check if AXI slave de-asserts arready when handshake is complete
  check_arready_clear : process (S_AXI_ACLK, S_AXI_ARESETN)
  begin
  
    if (S_AXI_ARESETN = '0') then
      address_read_handshake_complete <= FALSE;
      
    elsif (rising_edge(S_AXI_ACLK)) then
      if (S_AXI_ARVALID = '1' AND S_AXI_ARREADY = '1') then
        address_read_handshake_complete <= TRUE;
        
      elsif (address_read_handshake_complete = TRUE) then
        if (S_AXI_ARREADY = '1') then
          assert (FALSE) report "AXI4-Lite slave failed to de-assert arready after handshake."
          severity failure;
        end if;
        address_read_handshake_complete <= FALSE;

      end if;
    end if;
    
  end process check_arready_clear;
  
  -- Check if AXI slave de-asserts rvalid when handshake is complete
  check_rvalid_clear : process (S_AXI_ACLK, S_AXI_ARESETN)
  begin
  
    if (S_AXI_ARESETN = '0') then
      read_response_handshake_complete <= FALSE;

    elsif (rising_edge(S_AXI_ACLK)) then
      if (S_AXI_RVALID = '1' AND S_AXI_RREADY = '1') then
        read_response_handshake_complete <= TRUE;
        
      elsif (read_response_handshake_complete = TRUE) then
        if (S_AXI_RVALID = '1') then
          assert(FALSE) report "AXI4-LITE slave failed to de-assert rvalid after handshake."
          severity failure;
          
        end if;
        read_response_handshake_complete <= FALSE;
        
      end if;
    end if;
    
  end process check_rvalid_clear;
    
  tb : process
  begin
    S_AXI_ARADDR <= x"0000_0000";
    S_AXI_ARVALID <= '0';
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ARESETN <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 1 -----
    -- Test if RVALID will go high if ARVALID goes high first before RREADY
    -- Test non existing address response and read data
    S_AXI_ARVALID <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    wait until S_AXI_ACLK <= '1';
    
    S_AXI_RREADY <= '1';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= x"0000_0000") OR (S_AXI_RRESP /= "11") OR (SPIDRR_Read_en /= '0') OR (SPISR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 1 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 2 -----
    -- Test if RVALID will go high if RREADY goes high first before ARVALID
    -- Test non-readable address (SSR) response and read data
    S_AXI_ARADDR <= x"0000_0040";
    S_AXI_RREADY <= '1';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    S_AXI_ARVALID <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= x"0000_0000") OR (S_AXI_RRESP /= "01") OR (SPIDRR_Read_en /= '0') OR (SPISR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 2 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 3 -----
    -- Test if RVALID goes high if RREADY and ARVALID go high at the same time
    -- Test read response and read data of SPICR
    S_AXI_ARADDR <= x"0000_0060";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= SPICR_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '0') OR (SPISR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 3 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 4 -----
    -- Test read response and read data of SPISR
    S_AXI_ARADDR <= x"0000_0064";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= SPISR_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '0') OR (SPISR_Read_en /= '1')) then
      assert (FALSE) report "TEST CASE 4 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 5 -----
    -- Test read response and read data of SPIDTR
    S_AXI_ARADDR <= x"0000_0068";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= x"0000_0000") OR (S_AXI_RRESP /= "01") OR (SPIDRR_Read_en /= '0') OR (SPISR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 5 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 6 -----
    -- Test read response and read data of SPIDRR
    S_AXI_ARADDR <= x"0000_006C";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= SPIDRR_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '1') OR (SPISR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 6 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 7 -----
    -- Test read response and read data of SPISSR
    S_AXI_ARADDR <= x"0000_0070";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= SPISSR_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '0') OR (SPISR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 7 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 8 -----
    -- Test read response and read data of Tx_FIFO_OCY
    S_AXI_ARADDR <= x"0000_0074";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= Tx_FIFO_OCY_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '0') OR (SPISR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 8 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 9 -----
    -- Test read response and read data of Rx_FIFO_OCY
    S_AXI_ARADDR <= x"0000_0078";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= Rx_FIFO_OCY_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '0') OR (SPISR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 9 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 10 -----
    -- Test read response and read data of DGIER
    S_AXI_ARADDR <= x"0000_001C";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= DGIER_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '0') OR (SPISR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 10 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 11 -----
    -- Test read response and read data of IPISR
    S_AXI_ARADDR <= x"0000_0020";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= IPISR_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '0') OR (SPISR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 11 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 12 -----
    -- Test read response and read data of IPIER
    S_AXI_ARADDR <= x"0000_0028";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= IPIER_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '0') OR (SPISR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 12 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
  
    report "Test Completed";
    wait;
  end process tb;

end Behavioral;
