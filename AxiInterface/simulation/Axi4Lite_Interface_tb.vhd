library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Axi4Lite_Interface_tb is
end Axi4Lite_Interface_tb;

architecture Behavioral of Axi4Lite_Interface_tb is

  component Axi4Lite_Interface
    Generic (
      C_BASEADDR : STD_LOGIC_VECTOR;
      C_HIGHADDR : STD_LOGIC_VECTOR;
      C_S_AXI_ADDR_WIDTH : INTEGER := 32;
      C_S_AXI_DATA_WIDTH : INTEGER := 32
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
    
      -- Internal Ports
      WriteToReg : OUT STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- Input Data
      Strobe : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- Strobe sent out to registers
    
      SRR_En : OUT STD_LOGIC;    -- Software Reset Register Enable
      SPICR_En : OUT STD_LOGIC;  -- SPI Control Register Enable
      SPIDTR_En : OUT STD_LOGIC; -- SPI Data Transmit Register Enable
      SPISSR_En : OUT STD_LOGIC; -- SPI Slave Select Register Enable
      DGIER_En : OUT STD_LOGIC;  -- Device Global Interrupt Enable Register Enable
      IPISR_En : OUT STD_LOGIC;  -- IP Interrupt Status Register Enable
      IPIER_En : OUT STD_LOGIC;  -- IP Interrupt Enable Register Enable
    
      SPICR_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- SPI Control Register Read
      SPISR_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- SPI Status Register Read
      SPIDRR_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Data Receive Register Read
      SPISSR_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Slave Select Register Read
      Tx_FIFO_OCY_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Transmit FIFO Occupancy Register Read
      Rx_FIFO_OCY_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0); -- SPI Receive FIFO Occupancy Register Read
      DGIER_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- Device Global Intterupt Enable Register Read
      IPISR_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- IP Interrupt Status Register Read
      IPIER_Read : IN STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH-1) DOWNTO 0);  -- IP Interrupt Enable Register Read
      SPIDRR_Read_en : OUT STD_LOGIC
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
    
  SIGNAL S_AXI_ARADDR  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL S_AXI_ARVALID : STD_LOGIC;
  SIGNAL S_AXI_ARREADY : STD_LOGIC;
    
  SIGNAL S_AXI_RDATA  : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL S_AXI_RRESP  : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL S_AXI_RVALID : STD_LOGIC;
  SIGNAL S_AXI_RREADY : STD_LOGIC;
    
  SIGNAL WriteToReg : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Strobe : STD_LOGIC_VECTOR(3 DOWNTO 0);
    
  SIGNAL SRR_En : STD_LOGIC;
  SIGNAL SPICR_En : STD_LOGIC;
  SIGNAL SPIDTR_En : STD_LOGIC;
  SIGNAL SPISSR_En : STD_LOGIC;
  SIGNAL DGIER_En : STD_LOGIC;
  SIGNAL IPISR_En : STD_LOGIC;
  SIGNAL IPIER_En : STD_LOGIC;
    
  SIGNAL SPICR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0001";
  SIGNAL SPISR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0002";
  SIGNAL SPIDRR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0003";
  SIGNAL SPISSR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0004";
  SIGNAL Tx_FIFO_OCY_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0005";
  SIGNAL Rx_FIFO_OCY_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0006";
  SIGNAL DGIER_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0007";
  SIGNAL IPISR_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0008";
  SIGNAL IPIER_Read : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"0000_0009";
  SIGNAL SPIDRR_Read_en : STD_LOGIC;

  SIGNAL address_write_handshake_complete : BOOLEAN;
  SIGNAL data_write_handshake_complete : BOOLEAN;
  SIGNAL write_response_handshake_complete : BOOLEAN;
  SIGNAL address_read_handshake_complete : BOOLEAN;
  SIGNAL read_response_handshake_complete : BOOLEAN;
  
begin

  DUT : Axi4Lite_Interface
    Generic Map (
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
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
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
      SPIDRR_Read_en => SPIDRR_Read_en
    );
    
  -- Clock generator and power-on-reset
  S_AXI_ACLK <= NOT S_AXI_ACLK after 10ns;
  S_AXI_ARESETN <= '0', '1' after 1us;
  
  -- Check if AXI slave de-asserts awready when handshake is complete
  check_awready_clear : process (S_AXI_ACLK, S_AXI_ARESETN)
  begin
  
    if (S_AXI_ARESETN = '0') then
      address_write_handshake_complete <= FALSE;
      
    elsif (rising_edge(S_AXI_ACLK)) then
      if (S_AXI_AWVALID = '1' AND S_AXI_AWREADY = '1') then
        address_write_handshake_complete <= TRUE;
        
      elsif (address_write_handshake_complete = TRUE) then
        if (S_AXI_AWREADY = '1') then
          assert (FALSE) report "AXI4-Lite slave failed to de-assert awready after handshake."
          severity failure;
        end if;
        address_write_handshake_complete <= FALSE;

      end if;
    end if;
    
  end process check_awready_clear;
  
  -- Check if AXI slave de-asserts wready when handshake is complete
  check_wready_clear : process (S_AXI_ACLK, S_AXI_ARESETN)
  begin
  
    if (S_AXI_ARESETN = '0') then
      data_write_handshake_complete <= FALSE;
      
    elsif (rising_edge(S_AXI_ACLK)) then
      if (S_AXI_WVALID = '1' AND S_AXI_WREADY = '1') then
        data_write_handshake_complete <= TRUE;
        
      elsif (data_write_handshake_complete = TRUE) then
        if (S_AXI_WREADY = '1') then
          assert (FALSE) report "AXI4-Lite slave failed to de-assert wready after handshake."
          severity failure;
        end if;
        data_write_handshake_complete <= FALSE;

      end if;
    end if;
    
  end process check_wready_clear;
  
  -- Check if AXI slave de-asserts bvalid when handshake is complete
  check_bvalid_clear : process (S_AXI_ACLK, S_AXI_ARESETN)
  begin
  
    if (S_AXI_ARESETN = '0') then
      write_response_handshake_complete <= FALSE;
      
    elsif (rising_edge(S_AXI_ACLK)) then
      if (S_AXI_BVALID = '1' AND S_AXI_BREADY = '1') then
        write_response_handshake_complete <= TRUE;
        
      elsif (write_response_handshake_complete = TRUE) then
        if (S_AXI_BVALID = '1') then
          assert (FALSE) report "AXI4-Lite slave failed to de-assert bvalid after handshake."
          severity failure;
        end if;
        write_response_handshake_complete <= FALSE;

      end if;
    end if;
    
  end process check_bvalid_clear;
  
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
  
    procedure WriteAndRead is
    begin
      S_AXI_WVALID <= '1';
      S_AXI_AWVALID <= '1';
      S_AXI_BREADY <= '1';
      
      S_AXI_ARVALID <= '1';
      S_AXI_RREADY <= '1';
    
      wait until data_write_handshake_complete <= TRUE;
      S_AXI_WVALID <= '0';
      S_AXI_AWVALID <= '0';
      S_AXI_ARVALID <= '0';
      wait for 1ns;
    end procedure WriteAndRead;
  
  begin
  
    S_AXI_ARADDR <= x"0000_0000";
    S_AXI_ARVALID <= '0';
    S_AXI_RREADY <= '0';
    
    S_AXI_AWADDR <= x"0000_0000";
    S_AXI_AWVALID <= '0';
    S_AXI_WDATA <= x"FFFF_FFFF";
    S_AXI_WSTB <= "0000";
    S_AXI_WVALID <= '0';
    S_AXI_BREADY <= '0';
    
    ----- TEST CASE 1 -----
    -- Test address write entered in first before data write
    -- Test response when written to a non-existing address
    S_AXI_AWVALID <= '1';

    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    wait until S_AXI_ACLK <= '1';
    
    S_AXI_WVALID <= '1';
    S_AXI_WSTB <= "0001";
    
    wait until data_write_handshake_complete <= TRUE;
    S_AXI_WVALID <= '0';
    S_AXI_WSTB <= "1111";
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    wait until S_AXI_ACLK <= '1';

    S_AXI_BREADY <= '1';
    wait for 1ns;
    
    if ((S_AXI_BRESP /= "11") OR (WriteToReg /= x"FFFF_FFFF") OR (Strobe /= "0001") OR (SRR_En /= '0')
        OR (SPICR_En /= '0') OR (SPIDTR_En /= '0') OR (SPISSR_En /= '0') OR (DGIER_En /= '0') OR
        (IPISR_En /= '0') OR (IPIER_En /= '0')) then
      assert (FALSE) report "TEST CASE 1 FAILED"
      severity warning;
    
    end if;
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 2 -----
    -- Test data write entered in first before address write
    -- Test response when written to SRR
    S_AXI_AWADDR <= x"0000_0040";
    S_AXI_WSTB <= "0011";
    S_AXI_WVALID <= '1';

    wait until data_write_handshake_complete <= TRUE;
    S_AXI_WVALID <= '0';
    S_AXI_WSTB <= "1111";
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    wait until S_AXI_ACLK <= '1';
    
    S_AXI_AWVALID <= '1';
    
    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    wait until S_AXI_ACLK <= '1';

    S_AXI_BREADY <= '1';
    wait for 1ns;
    
    if ((S_AXI_BRESP /= "00") OR (WriteToReg /= x"FFFF_FFFF") OR (Strobe /= "0011") OR (SRR_En /= '1')
        OR (SPICR_En /= '0') OR (SPIDTR_En /= '0') OR (SPISSR_En /= '0') OR (DGIER_En /= '0') OR
        (IPISR_En /= '0') OR (IPIER_En /= '0')) then
      assert (FALSE) report "TEST CASE 2 FAILED"
      severity warning;
    
    end if;
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 3 -----
    -- Test data write entered in at same time as address write
    -- Test response when written to SPICR and when arready = 0 while temp_read_address = 0000_0000
    S_AXI_AWADDR <= x"0000_0060";
    S_AXI_WSTB <= "1111";
    S_AXI_WVALID <= '1';
    S_AXI_AWVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until data_write_handshake_complete <= TRUE;
    S_AXI_WVALID <= '0';
    S_AXI_AWVALID <= '0';
    S_AXI_WSTB <= "0011";
    S_AXI_WDATA <= x"0000_0000";
    wait for 1ns;
    
    if ((S_AXI_BRESP /= "00") OR (WriteToReg /= x"FFFF_FFFF") OR (Strobe /= "1111") OR (SRR_En /= '0')
        OR (SPICR_En /= '1') OR (SPIDTR_En /= '0') OR (SPISSR_En /= '0') OR (DGIER_En /= '0') OR
        (IPISR_En /= '0') OR (IPIER_En /= '0')) then
      assert (FALSE) report "TEST CASE 3 FAILED"
      severity warning;
      
    end if;
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 4 -----
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
    
    if ((S_AXI_RDATA /= x"0000_0000") OR (S_AXI_RRESP /= "11") OR (SPIDRR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 4 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 5 -----
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
    
    if ((S_AXI_RDATA /= x"0000_0000") OR (S_AXI_RRESP /= "01") OR (SPIDRR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 5 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 6 -----
    -- Test if RVALID goes high if RREADY and ARVALID go high at the same time
    -- Test read response and read data of SPICR
    S_AXI_ARADDR <= x"0000_0060";
    S_AXI_ARVALID <= '1';
    S_AXI_RREADY <= '1';
    
    wait until address_read_handshake_complete <= TRUE;
    S_AXI_ARVALID <= '0';
    
    wait for 1ns;
    
    if ((S_AXI_RDATA /= SPICR_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 6 FAILED"
      severity warning;
    end if;
    
    wait until read_response_handshake_complete <= TRUE;
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 7 -----
    -- Test write and read from non-existing address
    S_AXI_ARADDR <= x"0000_0000";
    
    S_AXI_AWADDR <= x"0000_0000";
    S_AXI_WDATA <= x"FFFF_FFFF";
    S_AXI_WSTB <= "0000";
    
    WriteAndRead;
    
    if ((S_AXI_BRESP /= "11") OR (WriteToReg /= x"FFFF_FFFF") OR (Strobe /= "0000") OR (SRR_En /= '0')
        OR (SPICR_En /= '0') OR (SPIDTR_En /= '0') OR (SPISSR_En /= '0') OR (DGIER_En /= '0') OR
        (IPISR_En /= '0') OR (IPIER_En /= '0')) then
      assert (FALSE) report "TEST CASE 7 WRITE FAILED"
      severity warning;
    
    end if;
    
    if ((S_AXI_RDATA /= x"0000_0000") OR (S_AXI_RRESP /= "11") OR (SPIDRR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 7 READ FAILED"
      severity warning;
    end if;
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 8 -----
    -- Test when both read and write take place at the SPICR register that can
    -- both be written and read from
    S_AXI_ARADDR <= x"0000_0060";
    
    S_AXI_AWADDR <= x"0000_0060";
    S_AXI_WDATA <= x"FFFF_FFFF";
    S_AXI_WSTB <= "0000";
    
    WriteAndRead;
    
    if ((S_AXI_BRESP /= "01") OR (WriteToReg /= x"FFFF_FFFF") OR (Strobe /= "0000") OR (SRR_En /= '0')
        OR (SPICR_En /= '0') OR (SPIDTR_En /= '0') OR (SPISSR_En /= '0') OR (DGIER_En /= '0') OR
        (IPISR_En /= '0') OR (IPIER_En /= '0')) then
      assert (FALSE) report "TEST CASE 8 WRITE FAILED"
      severity warning;
    
    end if;
    
    if ((S_AXI_RDATA /= SPICR_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '0')) then
      assert (FALSE) report "TEST CASE 8 READ FAILED"
      severity warning;
    end if;
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    ----- TEST CASE 9 -----
    -- Test when both read and write take place at different registers
    S_AXI_ARADDR <= x"0000_006C";
    
    S_AXI_AWADDR <= x"0000_0068";
    S_AXI_WDATA <= x"FFFF_FFFF";
    S_AXI_WSTB <= "0000";
    
    WriteAndRead;
    
    if ((S_AXI_BRESP /= "00") OR (WriteToReg /= x"FFFF_FFFF") OR (Strobe /= "0000") OR (SRR_En /= '0')
        OR (SPICR_En /= '0') OR (SPIDTR_En /= '1') OR (SPISSR_En /= '0') OR (DGIER_En /= '0') OR
        (IPISR_En /= '0') OR (IPIER_En /= '0')) then
      assert (FALSE) report "TEST CASE 9 WRITE FAILED"
      severity warning;
    
    end if;
    
    if ((S_AXI_RDATA /= SPIDRR_Read) OR (S_AXI_RRESP /= "00") OR (SPIDRR_Read_en /= '1')) then
      assert (FALSE) report "TEST CASE 9 READ FAILED"
      severity warning;
    end if;
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    S_AXI_RREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
  
    report "TEST COMPLETED";
    wait;
  end process tb;
 
end Behavioral;
