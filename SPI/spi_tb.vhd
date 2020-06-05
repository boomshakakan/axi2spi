library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity spi_module_tb is
end;

architecture bench of spi_module_tb is

  component spi_module
    Generic (
      C_NUM_TRANSFER_BITS : INTEGER := 8;
      C_NUM_SS_BITS : INTEGER := 1;
      C_SCK_RATIO : INTEGER := 2
    );
    Port (
      S_AXI_ACLK : IN STD_LOGIC;
      rst_n : IN STD_LOGIC;
      spi_clk : OUT STD_LOGIC;
      SPISSR_Read : IN STD_LOGIC_VECTOR((C_NUM_SS_BITS-1) DOWNTO 0);
      tx_read : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      tx_read_enable : OUT STD_LOGIC;
      rx_write : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rx_enable : OUT STD_LOGIC;
      tx_empty : IN STD_LOGIC;
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
  end component;

  signal S_AXI_ACLK: STD_LOGIC;
  signal rst_n: STD_LOGIC;
  signal spi_clk: STD_LOGIC;
  signal SPISSR_Read: STD_LOGIC_VECTOR(0 DOWNTO 0);
  signal tx_read: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal tx_read_enable: STD_LOGIC;
  signal rx_write: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal rx_enable: STD_LOGIC;
  signal tx_empty: STD_LOGIC;
  signal lsb_first: STD_LOGIC;
  signal master_transaction_inhibit: STD_LOGIC;
  signal manual_slave_select_assertion_enable: STD_LOGIC;
  signal cpha: STD_LOGIC;
  signal cpol: STD_LOGIC;
  signal master_mode: STD_LOGIC;
  signal spe: STD_LOGIC;
  signal loopback: STD_LOGIC;
  signal slave_mode_select: STD_LOGIC;
  signal modf: STD_LOGIC;
  signal slave_modf: STD_LOGIC;
  signal MISO_O: STD_LOGIC;
  signal MOSI_O: STD_LOGIC;
  signal SCK_O: STD_LOGIC;
  signal SS_O: STD_LOGIC_VECTOR(0 DOWNTO 0);
  signal MISO_T: STD_LOGIC;
  signal MOSI_T: STD_LOGIC;
  signal SCK_T: STD_LOGIC;
  signal SS_T: STD_LOGIC;
  signal MISO_I: STD_LOGIC;
  signal MOSI_I: STD_LOGIC;
  signal SCK_I: STD_LOGIC;
  signal SS_I: STD_LOGIC_VECTOR(0 DOWNTO 0);
  signal SPISEL: STD_LOGIC ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin


  uut: spi_module generic map ( C_NUM_TRANSFER_BITS                  => 8,
                                C_NUM_SS_BITS                        => 1 ,
                                C_SCK_RATIO                          => 2)
                     port map ( S_AXI_ACLK                           => S_AXI_ACLK,
                                rst_n                                => rst_n,
                                spi_clk                              => spi_clk,
                                SPISSR_Read                          => SPISSR_Read,
                                tx_read                              => tx_read,
                                tx_read_enable                       => tx_read_enable,
                                rx_write                             => rx_write,
                                rx_enable                            => rx_enable,
                                tx_empty                             => tx_empty,
                                lsb_first                            => lsb_first,
                                master_transaction_inhibit           => master_transaction_inhibit,
                                manual_slave_select_assertion_enable => manual_slave_select_assertion_enable,
                                cpha                                 => cpha,
                                cpol                                 => cpol,
                                master_mode                          => master_mode,
                                spe                                  => spe,
                                loopback                             => loopback,
                                slave_mode_select                    => slave_mode_select,
                                modf                                 => modf,
                                slave_modf                           => slave_modf,
                                MISO_O                               => MISO_O,
                                MOSI_O                               => MOSI_O,
                                SCK_O                                => SCK_O,
                                SS_O                                 => SS_O,
                                MISO_T                               => MISO_T,
                                MOSI_T                               => MOSI_T,
                                SCK_T                                => SCK_T,
                                SS_T                                 => SS_T,
                                MISO_I                               => MISO_I,
                                MOSI_I                               => MOSI_I,
                                SCK_I                                => SCK_I,
                                SS_I                                 => SS_I,
                                SPISEL                               => SPISEL );


  --  report "message"; 
  stimulus: process
  begin
  --------------------------------------SPI Master Mode Test-------------------------------------------------
----------- SPE ='0' test -----------
    wait for 5 ns;
    miso_i<='0';
    MOSI_I<='0';
    sck_i<='0';
    ss_i<="1";
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 10 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='1';
  --  wait for 220 ns;
   ----------- SPE ='0' Test END----------- 
   
----------- SPE ='1' cpha='0' cpol ='0' test -----------
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='0';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='0';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait for 200 ns;
    spe<='0';
    rst_n<='0'; 
    SPISSR_Read<="1";
  
    wait for 500 ns;
  ----------- SPE ='1' cpha='0' cpol ='0' Test End-----------
  ----------- SPE ='1' cpol='0' cpha='1' test ----------- 
    miso_i<='0';
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='1';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 10 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='1';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='1';
    wait until sck_o<='1';
    miso_i<='0';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='0';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait for 200 ns;
    spe<='0';
    rst_n<='0'; 
    SPISSR_Read<="1";
    
    
      wait for 500 ns;
    ----------- SPE ='1' cpol='0' cpha='1' TEST END ----------- 
    
  ----------- SPE ='1' cpol='1' cpha='0' test ----------- 
    miso_i<='0';
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='0';                              
    cpol<='1';                               
    master_mode<='1';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 10 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='0';                              
    cpol<='1';                               
    master_mode<='1';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='1';
    wait until sck_o<='1';
    miso_i<='0';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='0';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait until sck_o<='0';
    wait until sck_o<='1';
    miso_i<='1';
    wait for 200 ns;
    spe<='0';
    rst_n<='0'; 
    SPISSR_Read<="1";
    
      ----------- SPE ='1' cpol='1' cpha='0' TEST END ----------- 
          wait for 500 ns;
  
  ----------- SPE ='1' cpol='1' cpha='1' Test ----------- 
    miso_i<='0';
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='1';                              
    cpol<='1';                               
    master_mode<='1';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 10 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='1';                              
    cpol<='1';                               
    master_mode<='1';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='0';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='0';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait for 200 ns;
    spe<='0';
    rst_n<='0'; 
    SPISSR_Read<="1";
    wait for 500 ns;
      ----------- SPE ='1' cpol='1' cpha='1' Test End----------- 
    
     ----------- LOOPABCK Test  ----------- 
    miso_i<='0';
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 10 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='1';                              
    loopback<='1';
    SPISEL<='1';
    wait for 1000 ns;
    spe<='0';
    rst_n<='0'; 
    SPISSR_Read<="1";
    
      ----------- LOOPABCK Test End----------- 
      wait for 500 ns;
      ----------- Master Transaction inhabit ----------- 
    miso_i<='0';
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 10 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='1';        
    manual_slave_select_assertion_enable <='0';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='1';
    wait for 200 ns;
    spe<='0';
    rst_n<='0'; 
    SPISSR_Read<="1";
  
      ----------- Master Transaction inhabit End----------- 
      
           ----------- MSB First Test ----------- 
    miso_i<='0';
    lsb_first<='0';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"fffffffe";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 10 ns;     
    rst_n<='1';               
    lsb_first<='0';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='0';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='0';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait for 200 ns;
    spe<='0';
    rst_n<='0'; 
    SPISSR_Read<="1";
           ----------- MSB First Test End----------- 
    wait for 500 ns;
             ----------- Auto Slave Test ----------- 
    miso_i<='0';
    lsb_first<='0';                           
    master_transaction_inhibit <='1';        
    manual_slave_select_assertion_enable <='1';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"fffffffe";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 10 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='1';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='0';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='0';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait until sck_o<='1';
    wait until sck_o<='0';
    miso_i<='1';
    wait for 200 ns;
    spe<='0';
    rst_n<='0'; 
 
                   ----------- Auto Slave Test End -----------  
                   
---------------------------- SPI Master Mode Test End------------------------------------
           
--------------------------------- Slave Mode Test-----------------------------------------

------------------ Slave Mode CPOL='0' CPHA='0'---------------------
    miso_i<='0';
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='0';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 200 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='0';                              
    cpol<='0';                               
    master_mode<='0';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='0';
    wait for 120 ns;
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
    MOSI_I<='0';
    wait for 120 ns;
     spe<='0';
    rst_n<='0';
    spisel<='1'; 
    
      ----------- Slave Mode CPOL='0' CPHA='0' End----------------
      
      
      
      ------------------ Slave Mode CPOL='0' CPHA='1'---------------------
    miso_i<='0';
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='1';                              
    cpol<='0';                               
    master_mode<='0';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 200 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='1';                              
    cpol<='0';                               
    master_mode<='0';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='0';
     wait for 80 ns;
      sck_i<='1';
     spe<='0';
    rst_n<='0';
    spisel<='1'; 
    
      ----------- Slave Mode CPOL='0' CPHA='1' End----------------
      
      
            
      ------------------ Slave Mode CPOL='1' CPHA='0'---------------------
    miso_i<='0';
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='0';                              
    cpol<='1';                               
    master_mode<='0';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 200 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='0';                              
    cpol<='1';                               
    master_mode<='0';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='0';
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
     wait for 120 ns;
     sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
     wait for 80 ns;
      
     spe<='0';
    rst_n<='0';
    spisel<='1'; 
    
      ----------- Slave Mode CPOL='1' CPHA='0'----------------
    
    ------------------ Slave Mode CPOL='1' CPHA='1'---------------------
    miso_i<='0';
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='1';                              
    cpol<='1';                               
    master_mode<='0';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 200 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='1';                              
    cpol<='1';                               
    master_mode<='0';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='0';
    wait for 120 ns;
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
     spe<='0';
    rst_n<='0';
    spisel<='1'; 
    wait for 500 ns;
      ----------- Slave Mode CPOL='1' CPHA='1' End----------------
      
      
          ------------------ Slave MODF---------------------
    miso_i<='0';
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='1';                              
    cpol<='1';                               
    master_mode<='0';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 200 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='1';                              
    cpol<='1';                               
    master_mode<='1';                         
    spe<='1';                              
    loopback<='0';
    SPISEL<='0';
    wait for 120 ns;
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    spe<='0';
    rst_n<='0';
    spisel<='1'; 
    
      ----------- Slave MODF End---------------
      
      ----------- Slave_Select MODF---------------
          miso_i<='0';
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='1';
    cpha<='1';                              
    cpol<='1';                               
    master_mode<='1';                         
    spe<='0';                              
    loopback<='1';
    SPISSR_Read<="0";
    tx_read<=x"ffffff7e";      
    tx_empty<='0';
    rst_n<='0'; 
    wait for 200 ns;     
    rst_n<='1';               
    lsb_first<='1';                           
    master_transaction_inhibit <='0';        
    manual_slave_select_assertion_enable <='0';
    cpha<='1';                              
    cpol<='1';                               
    master_mode<='0';                         
    spe<='0';                              
    loopback<='0';
    SPISEL<='0';
    wait for 120 ns;
    sck_i<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='1';
    wait for 120 ns;
    sck_i<='0';
    wait for 120 ns;
    sck_i<='1';
    MOSI_I<='0';
    wait for 120 ns;
    spe<='0';
    rst_n<='0';
    spisel<='1'; 
      ----------- Slave_Select MODF End---------------
      
    wait for 500 ns;
    --------------------------Slave Test End-----------------------------------
      
    wait for 1000 ns;

    -- Put test bench stimulus code here
    Report " Test Done";
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      S_AXI_ACLK <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;
  


end;