library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registers is
    
    port (
        -- SYSTEM INTERFACE
        clk_in      :   in std_logic;
        rst         :   in std_logic;
        -- input from AXI4 interface ???
        d_in        :   in std_logic_vector(31 downto 0);
        
        --------------------------------------------
        -- REGISTERS
        -- SRR : Software Reset Register
        -- individual reset for register when value is 0x0000_000A
        SRR      :  out std_logic_vector(31 downto 0); 
        
        
        -- SPICR : SPI Control Register
        -- control of various AXI SPI IP core
        -- *bits* |(31) ... (10) -> Reserved, (9) LSB, (8) Master Transaction inhibit,
        -- (7) Manual slave select assertion enable, (6) Rx FIFO Rst, (5) Tx FIFO Rst, (4) CPHA,
        -- (3) CPOL, (2) Master, (1) SPE, (0) LOOPS |
        SPICR    :  out std_logic_vector(31 downto 0);
        
        -- SPISR    : SPI Status Register
        -- gives programmer visibility of the status of some of the AXI SPI IP core
        -- *bits* |(31) ... (6) -> Reserved, (5) Slave_Mode_Select, (4) MODF,
        -- (3) Tx_Full, (2) Tx_Empty, (1) Rx_Full, (0) Rx_Empty |
        SPISR    :  out std_logic_vector(31 downto 0);
        
        -- SPIDTR : SPI Data Transmit Register
        -- written to with the data to be transmitted on the SPI bus
        -- *bits* |(N-1) ... (0) -> Tx Data((D(N-1) - D0)|
        -- N can be 8, 16 or 32 based on generic C_NUM_TRANSFER_BITS
        SPIDTR  :   out std_logic_vector(31 downto 0); -- size dependent on Tx
        
        -- SPIDRR   : SPI Data Receive Register
        -- used to read data that is received from SPI bus
        SPIDRR  :   out std_logic_vector(31 downto 0); -- size dependent on Rx
        
        -- SPISSR : SPI Slave Select Register
        -- contains active low, one-hot encoded slave select vector of length N,
        -- where N is the number of slaves set by param C_NUM_SS_BITS
        -- *bits* | (31) ... (N) -> Reserved, (N-1) ... 0 -> Selected Slave |
        SPISSR  :   out std_logic_vector(31 downto 0);
        
        -- INTERRUPTS 
        
        -- SPI Transmit FIFO Occupancy Register
        -- if transmit fifo not empty, contains a four-bit value that is one less than
        -- the number of elements in the FIFO 
        -- *bits* | (31) ... (4) -> Reserved, (3) ... (0) -> Occupancy minus 1
        Tx_FIFO_OCY :   out std_logic_vector(31 downto 0);
        
        -- SPI Receive FIFO Occupany Register
        -- contains similar occupancy minus 1 value for receive fifo
        Rx_FIFO_OCY :   out std_logic_vector(31 downto 0);
        
        -- DGIER : Device Global Interrupt Enable Register
        -- used to globally enable the final interrupt output from the interrupt controller
        -- *bits* | (31) -> Global Interrupt Enable, (30) ... (0) -> Reserved |
        DGIER       :   in std_logic_vector(31 downto 0);
        
        -- IPISR : IP Interrupt Status Register
        -- 9 unique interrupts
        -- *bits* | (31) ... (9) -> Reserved, (8) DRR_Not_Empty, (7) Slave Mode Select,
        -- (6) Tx FIFO Half Empty, (5) DRR Over-run, (4) DRR Full, (3) DTR Under-run, (2) DTR Empty,
        -- (1) Slave MODF, (0) MODF |
        IPISR       :   out std_logic_vector(31 downto 0);
        
        -- IPIER : IP Interrupt Enable Register
        -- *bits* | (31) ... (9) -> Reserved, (8) DRR_Not Empty, (7) Slave Mode Select, (6) Tx FIFO Half Empty,
        -- (5) DRR Over-run, (4) DRR Full, (3) DTR Under-run, (2) DTR Empty, (1) Slave MODF, (0) MODF |
        IPIER       :   out std_logic_vector(31 downto 0)
        
        
    );

end registers;

architecture Behavioral of registers is

begin


end Behavioral;
