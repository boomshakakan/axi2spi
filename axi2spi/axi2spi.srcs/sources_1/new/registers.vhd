library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.components_pkg.load_register;
use work.components_pkg.toggle_on_write;

entity registers is
    
    port (
        -- SYSTEM INTERFACE
        clk         :   in std_logic;
        rst_n       :   in std_logic;
        stb_in      :   in std_logic_vector(1 downto 0);  -- strobe signal for byte to be written 
        wr_data     :   in std_logic_vector(31 downto 0); -- data to be written
        
        -- SYSTEM RESET OUTPUT FROM SRR & SYSTEM INTERRUPT
        SRR_RST     :   out std_logic;
        -- INTERRUPT   :   out std_logic;
        
        -- REGISTER ENABLES
        SRR_en          :   in std_logic;
        SPICR_en        :   in std_logic;
        SPISR_en        :   in std_logic;
        SPIDTR_en       :   in std_logic;
        SPIDRR_en       :   in std_logic;
        SPISSR_en       :   in std_logic;
        Tx_FIFO_OCY_en  :   in std_logic;
        Rx_FIFO_OCY_en  :   in std_logic;
        DGIER_en        :   in std_logic;
        IPISR_en        :   in std_logic;
        IPIER_en        :   in std_logic;
        
        -- REGISTERS
        
        -- SRR : Software Reset Register (W)
        -- individual reset for register when value is 0x0000_000A
        SRR         :   out std_logic_vector(31 downto 0); 
        
        -- SPICR : SPI Control Register (R/W)
        -- control of various AXI SPI IP core
        -- *bits* |(31) ... (10) -> Reserved, (9) LSB, (8) Master Transaction inhibit,
        -- (7) Manual slave select assertion enable, (6) Rx FIFO Rst, (5) Tx FIFO Rst, (4) CPHA,
        -- (3) CPOL, (2) Master, (1) SPE, (0) LOOPS |
        SPICR       :   out std_logic_vector(31 downto 0);
        
        -- SPISR    : SPI Status Register (R)    
        -- gives programmer visibility of the status of some of the AXI SPI IP core
        -- *bits* |(31) ... (6) -> Reserved, (5) Slave_Mode_Select, (4) MODF,
        -- (3) Tx_Full, (2) Tx_Empty, (1) Rx_Full, (0) Rx_Empty |
        SPISR       :   out std_logic_vector(31 downto 0);
        
        -- SPIDTR : SPI Data Transmit Register (W)
        -- written to with the data to be transmitted on the SPI bus
        -- *bits* |(N-1) ... (0) -> Tx Data((D(N-1) - D0)|
        -- N can be 8, 16 or 32 based on generic C_NUM_TRANSFER_BITS
        SPIDTR      :   out std_logic_vector(31 downto 0);
        
        -- SPIDRR   : SPI Data Receive Register (R)
        -- used to read data that is received from SPI bus
        SPIDRR      :   out std_logic_vector(31 downto 0);
        
        -- SPISSR : SPI Slave Select Register (R/W)
        -- contains active low, one-hot encoded slave select vector of length N,
        -- where N is the number of slaves set by param C_NUM_SS_BITS
        -- *bits* | (31) ... (N) -> Reserved, (N-1) ... 0 -> Selected Slave |
        SPISSR      :   out std_logic_vector(31 downto 0);
        
        -- INTERRUPTS *INCLUDE ENABLES WITH INTERRUPTS???*
        
        -- SPI Transmit FIFO Occupancy Register
        -- if transmit fifo not empty, contains a four-bit value that is one less than
        -- the number of elements in the FIFO 
        -- *bits* | (31) ... (4) -> Reserved, (3) ... (0) -> Occupancy minus 1
        Tx_FIFO_OCY :   out std_logic_vector(31 downto 0);
        
        -- SPI Receive FIFO Occupany Register
        -- contains similar occupancy minus 1 value for receive fifo
        Rx_FIFO_OCY :   out std_logic_vector(31 downto 0);
        
        -- DGIER : Device Global Interrupt Enable Register (R/W)
        -- used to globally enable the final interrupt output from the interrupt controller
        -- *bits* | (31) -> Global Interrupt Enable, (30) ... (0) -> Reserved |
        DGIER       :   out std_logic_vector(31 downto 0);
        
        -- IPISR : IP Interrupt Status Register (R/TOW)
        -- 9 unique interrupts that toggle output of interrupt bit
        -- *bits* | (31) ... (9) -> Reserved, (8) DRR_Not_Empty, (7) Slave Mode Select,
        -- (6) Tx FIFO Half Empty, (5) DRR Over-run, (4) DRR Full, (3) DTR Under-run, (2) DTR Empty,
        -- (1) Slave MODF, (0) MODF |
        IPISR       :   inout std_logic_vector(31 downto 0);
        
        -- IPIER : IP Interrupt Enable Register (R/W)
        -- *bits* | (31) ... (9) -> Reserved, (8) DRR_Not Empty, (7) Slave Mode Select, (6) Tx FIFO Half Empty,
        -- (5) DRR Over-run, (4) DRR Full, (3) DTR Under-run, (2) DTR Empty, (1) Slave MODF, (0) MODF |
        IPIER       :   out std_logic_vector(31 downto 0)
        
    );

end registers;

architecture Behavioral of registers is

    signal wr_enable    :   std_logic;
    signal load_enable  :   std_logic;
    signal load_default :   std_logic_vector(31 downto 0);
    signal strobe       :   std_logic_vector(1 downto 0);
    signal en_1, en_2   :   std_logic;
    signal tmp_flag     :   std_logic;

begin

    process (clk, rst_n)
    begin
        -- consider reset conditions
        if rst_n =  '0' then
            load_enable <= '1'; -- initiates loading of all registers to default values
        elsif rising_edge(clk) then
            load_enable <= '0';
            -- if IPISR_en = '1' then
                -- INTERRUPT   <= NOT INTERRUPT;
            
        end if;
    end process;
    
    SRR_reg    :   load_register
        port map (
            clk     => clk,
            wr_en   => SRR_en,
            load_en => load_enable,
            load    => load_default,
            stb_in  => stb_in,
            d_in    => wr_data,
            d_out   => SRR
        );
        
    SPICR_reg   :   load_register
        port map (
            clk     => clk,
            wr_en   => SPICR_en,
            load_en => load_enable,
            load    => x"00000180",
            stb_in  => stb_in,
            d_in    => wr_data,
            d_out   => SPICR
        );
        
    SPISR_reg   :   load_register
        port map (
            clk     => clk,
            wr_en   => SPISR_en,
            load_en => load_enable,
            load    => x"00000025",
            stb_in  => stb_in,
            d_in    => wr_data,
            d_out   => SPISR
        );
        
    SPIDTR_reg  :   load_register
        port map (
            clk     => clk,
            wr_en   => SPIDTR_en,
            load_en => load_enable,
            load    => x"00000000",
            stb_in  => stb_in,
            d_in    => wr_data,
            d_out   => SPIDTR
        );
    
    --  IF REGISTER IS READ ONLY IS THIS NECESARRY OR NO?
    SPIDRR_reg  :   load_register
        port map (
            clk     => clk,
            wr_en   => SPIDRR_en,
            load_en => load_enable,
            load    => load_default,
            stb_in  => stb_in,
            d_in    => wr_data,
            d_out   => SPIDRR
        );
        
    SPISSR_reg  :   load_register
        port map (
            clk     => clk,
            wr_en   => SPISSR_en,
            load_en => load_enable,
            load    => load_default,
            stb_in  => stb_in,
            d_in    => wr_data,
            d_out   => SPISSR
        );
        
    Tx_FIFO_OCY_reg :   load_register
        port map (
            clk     => clk,
            wr_en   => Tx_FIFO_OCY_en,
            load_en => load_enable,
            load    => x"00000000",
            stb_in  => stb_in,
            d_in    => wr_data,
            d_out   => Tx_FIFO_OCY
        );
        
    Rx_FIFO_OCY_reg :   load_register
        port map (
            clk     => clk,
            wr_en   => Rx_FIFO_OCY_en,
            load_en => load_enable,
            load    => x"00000000",
            stb_in  => stb_in,
            d_in    => wr_data,
            d_out   => Rx_FIFO_OCY
        );
        
    DGIER_reg   :   load_register
        port map (
            clk     => clk,
            wr_en   => DGIER_en,
            load_en => load_enable,
            load    => x"00000000",
            stb_in  => stb_in,
            d_in    => wr_data,
            d_out   => Rx_FIFO_OCY
        );
    
    IPISR_reg   :   toggle_on_write
        port map (
            clk     => clk,
            wr_en   => IPISR_en,
            load_en => load_enable,
            load    => x"00000000",
            d_in    => wr_data,
            d_out   => IPISR
        );
        
    IPIER_reg   :   load_register
        port map (
            clk     => clk,
            wr_en   => IPIER_en,
            load_en => load_enable,
            load    => x"00000000",
            stb_in  => stb_in,
            d_in    => wr_data,
            d_out   => IPIER
        );

end Behavioral;
