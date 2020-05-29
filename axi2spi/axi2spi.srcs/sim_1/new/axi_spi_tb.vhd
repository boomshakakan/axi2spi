library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity axi_spi_tb is
end axi_spi_tb;

architecture Behavioral of axi_spi_tb is

  component axi_spi
    Generic (
      C_BASEADDR : STD_LOGIC_VECTOR; 
      C_HIGHADDR : STD_LOGIC_VECTOR;
      C_S_AXI_ADDR_WIDTH : INTEGER := 32;
      C_S_AXI_DATA_WIDTH : INTEGER := 32;
      C_FIFO_EXIST : INTEGER := 1;
      C_NUM_SS_BITS : INTEGER := 8
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
      MISO_I       : IN  STD_LOGIC;        ----- MISO_I in master mode
      MOSI_O       : OUT STD_LOGIC;        ----- MOSI_O out master mode
      MISO_O       : OUT STD_LOGIC;        ----- MISO_O out slave mode
      MOSI_I       : IN  STD_LOGIC;        ----- MOSI_I in slave mode
      MOSI_T       : OUT STD_LOGIC;        ----- MOSI_T enable
      MISO_T       : OUT STD_LOGIC;        ----- MISO_T enable
      SS_T         : OUT STD_LOGIC; 
      SS_O         : OUT STD_LOGIC_VECTOR(C_NUM_SS_BITS-1 DOWNTO 0); ----- skave select out
      SPISEL       : IN  STD_LOGIC        ----- SLAVE SELECT FROM OUTSIDE SPI MASTER
    );
  end component;  
  
  SIGNAL S_AXI_ACLK    : STD_LOGIC := '0';    -- Clock
  SIGNAL S_AXI_ARESETN : STD_LOGIC;    -- Reset Active Low
       
  SIGNAL S_AXI_AWADDR  : STD_LOGIC_VECTOR(31 DOWNTO 0); -- Write Address
  SIGNAL S_AXI_AWVALID : STD_LOGIC;                                         -- Write Address Valid
  SIGNAL S_AXI_AWREADY : STD_LOGIC;                                        -- Write Address Ready
    
  SIGNAL S_AXI_WDATA  : STD_LOGIC_VECTOR(31 DOWNTO 0); -- Write Data
  SIGNAL S_AXI_WSTB   : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Write Strobes
  SIGNAL S_AXI_WVALID : STD_LOGIC;                                         -- Write Valid
  SIGNAL S_AXI_WREADY : STD_LOGIC;                                        -- Write Ready
     
  SIGNAL S_AXI_BRESP  : STD_LOGIC_VECTOR(1 DOWNTO 0); -- Write Response
  SIGNAL S_AXI_BVALID : STD_LOGIC;                    -- Write Response Valid
  SIGNAL S_AXI_BREADY : STD_LOGIC;                     -- Write Response Ready
     
  SIGNAL S_AXI_ARADDR  : STD_LOGIC_VECTOR(31 DOWNTO 0); -- Read Address
  SIGNAL S_AXI_ARVALID : STD_LOGIC;                                         -- Read Address Valid
  SIGNAL S_AXI_ARREADY : STD_LOGIC;                                        -- Read Address Ready
  
  SIGNAL S_AXI_RDATA  : STD_LOGIC_VECTOR(31 DOWNTO 0); -- Read Data
  SIGNAL S_AXI_RRESP  : STD_LOGIC_VECTOR(1 DOWNTO 0);                      -- Read Response
  SIGNAL S_AXI_RVALID : STD_LOGIC;                                         -- Read Valid
  SIGNAL S_AXI_RREADY : STD_LOGIC;                                          -- Read Ready
    
  -- Interrupt Port
  SIGNAL IP2INTC_Irpt : STD_LOGIC;
    
  -- SPI Ports
  SIGNAL SCK_I        : STD_LOGIC;        ----- SCK INPUT FROM OUTSIDE SPI MASTER
  SIGNAL SCK_O        : STD_LOGIC;         ----- SCK OUTPUT TO OUTSIDE SPI SLAVE
  SIGNAL MISO_I       : STD_LOGIC;        ----- MISO_I in master mode
  SIGNAL MOSI_O       : STD_LOGIC;        ----- MOSI_O out master mode
  SIGNAL MISO_O       : STD_LOGIC;        ----- MISO_O out slave mode
  SIGNAL MOSI_I       :  STD_LOGIC;        ----- MOSI_I in slave mode
  SIGNAL MOSI_T       : STD_LOGIC;        ----- MOSI_T enable
  SIGNAL MISO_T       : STD_LOGIC;        ----- MISO_T enable
  SIGNAL SS_T         : STD_LOGIC; 
  SIGNAL SS_O         : STD_LOGIC_VECTOR(7 DOWNTO 0); ----- skave select out
  SIGNAL SPISEL       : STD_LOGIC;        ----- SLAVE SELECT FROM OUTSIDE SPI MASTER
  
  SIGNAL address_write_handshake_complete : BOOLEAN;
  SIGNAL data_write_handshake_complete : BOOLEAN;
  SIGNAL write_response_handshake_complete : BOOLEAN;
  SIGNAL address_read_handshake_complete : BOOLEAN;
  SIGNAL read_response_handshake_complete : BOOLEAN;

begin

  DUT : axi_spi
    Generic Map (
      C_BASEADDR => x"0000_0000", 
      C_HIGHADDR => x"0000_007F"
    )
    Port Map (
      S_AXI_ACLK    => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
       
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
   
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP  => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_RREADY => S_AXI_RREADY,
    
      IP2INTC_Irpt => IP2INTC_Irpt,
    
      SCK_I        => SCK_I,
      SCK_O        => SCK_O,
      MISO_I       => MISO_I,
      MOSI_O       => MOSI_O,
      MISO_O       => MISO_O,
      MOSI_I       => MOSI_I,
      MOSI_T       => MOSI_T,
      MISO_T       => MISO_T,
      SS_T         => SS_T,
      SS_O         => SS_O,
      SPISEL       => SPISEL
    );
  
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
    
  -- Clock generator and power-on-reset
  S_AXI_ACLK <= NOT S_AXI_ACLK after 10ns;
  S_AXI_ARESETN <= '0', '1' after 1us;
  Sck_I <= NOT S_AXI_ACLK after 10ns;
  tb : process
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
    
   -- SCK_I <= '0';
   -- MISO_I <= '0';
  --  MOSI_I <= '0';
    SPISEL <= '1';
    
    wait until S_AXI_ARESETN <= '0';
    wait until S_AXI_ARESETN <= '1';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- ENABLE GLOBAL INTERRUPT
    S_AXI_AWADDR <= x"0000_001C";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"8000_0000";
    S_AXI_WSTB <= "1000";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    S_AXI_WVALID <= '0';
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- ENABLE INTERRUPTS
    S_AXI_AWADDR <= x"0000_0028";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"0000_01FF";
    S_AXI_WSTB <= "0011";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    S_AXI_WVALID <= '0';
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- WRITE DATA TO TX FIFO
    S_AXI_AWADDR <= x"0000_0068";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"FAFA_FA7E";
    S_AXI_WSTB <= "1111";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    S_AXI_WVALID <= '0';
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    S_AXI_AWADDR <= x"0000_0068";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"FAFA_FA7E";
    S_AXI_WSTB <= "1111";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    S_AXI_WVALID <= '0';
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
       S_AXI_AWADDR <= x"0000_0068";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"FAFA_FA7E";
    S_AXI_WSTB <= "1111";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    S_AXI_WVALID <= '0';
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- WRITE TO CONTROL REGISTER
    S_AXI_AWADDR <= x"0000_0060";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"0000_0096";
    S_AXI_WSTB <= "0011";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
   
    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    S_AXI_WVALID <= '0';
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
 --   WAIT FOR 180 ns;
 --    SpiSEL<='1';
 
    wait until SS_T<='0';
    MISO_I <='1';
    WAIT FOR 80 NS;
     MISO_I <='0';
     WAIT FOR 40 NS;
      MISO_I <='0';
     WAIT FOR 40 NS;
      MISO_I <='0';
     WAIT FOR 40 NS;
     MISO_I <='0';
     WAIT FOR 40 NS;
     MISO_I <='0';
     WAIT FOR 40 NS;
      MISO_I <='0';
       WAIT FOR 40 NS;
       MISO_I <='0';
       
       WAIT FOR 40 NS;
      MISO_I <='1';
      WAIT FOR 40 NS;
       MISO_I <='0';
     WAIT FOR 40 NS;
      MISO_I <='0';
     WAIT FOR 40 NS;
      MISO_I <='0';
     WAIT FOR 40 NS;
     MISO_I <='0';
     WAIT FOR 40 NS;
     MISO_I <='0';
     
     
    S_AXI_AWADDR <= x"0000_0060";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"0000_0085";
    S_AXI_WSTB <= "0011";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
    SpiSEL<='1';
  
     WAIT FOR 40 NS;
      MISO_I <='0';
       WAIT FOR 40 NS;
      MISO_I <='1';
 
    
    
    wait for 200 ns;
    
    
    
    -- WRITE DATA TO TX FIFO
    S_AXI_AWADDR <= x"0000_0068";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"FAFA_FA7E";
    S_AXI_WSTB <= "1111";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    S_AXI_WVALID <= '0';
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    S_AXI_AWADDR <= x"0000_0068";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"FAFA_FA7E";
    S_AXI_WSTB <= "1111";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    S_AXI_WVALID <= '0';
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
       S_AXI_AWADDR <= x"0000_0068";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"FAFA_FA7E";
    S_AXI_WSTB <= "1111";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
    
    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    S_AXI_WVALID <= '0';
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    -- WRITE TO CONTROL REGISTER
    S_AXI_AWADDR <= x"0000_0060";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"0000_0086";
    S_AXI_WSTB <= "0011";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
    SpiSEL<='1';
    wait until address_write_handshake_complete <= TRUE;
    S_AXI_AWVALID <= '0';
    S_AXI_WVALID <= '0';
    
    wait until write_response_handshake_complete <= TRUE;
    S_AXI_BREADY <= '0';
    
    wait until S_AXI_ACLK <= '1';
    wait until S_AXI_ACLK <= '0';
    
    wait until SS_T<='0';
    MISO_I <='0';
    WAIT FOR 80 NS;
     MISO_I <='1';
     WAIT FOR 40 NS;
      MISO_I <='0';
     WAIT FOR 40 NS;
      MISO_I <='0';
     WAIT FOR 40 NS;
     MISO_I <='0';
     WAIT FOR 40 NS;
     MISO_I <='0';
     WAIT FOR 40 NS;
      MISO_I <='0';
       WAIT FOR 40 NS;
       MISO_I <='0';
       WAIT FOR 40 NS;
      MISO_I <='1';
      WAIT FOR 40 NS;
       MISO_I <='0';
     WAIT FOR 40 NS;
      MISO_I <='0';
     WAIT FOR 40 NS;
      MISO_I <='0';
     WAIT FOR 40 NS;
     MISO_I <='0';
     WAIT FOR 40 NS;
     MISO_I <='0';
     
       S_AXI_AWADDR <= x"0000_0060";
    S_AXI_AWVALID <= '1';
    S_AXI_WDATA <= x"0000_0085";
    S_AXI_WSTB <= "0011";
    S_AXI_WVALID <= '1';
    S_AXI_BREADY <= '1';
    SpiSEL<='1';
     WAIT FOR 40 NS;

   MISO_I <='0';
       WAIT FOR 40 NS;
      MISO_I <='1';
    
    
    report "TEST COMPLETE";
    wait;
  end process tb;

end Behavioral;
