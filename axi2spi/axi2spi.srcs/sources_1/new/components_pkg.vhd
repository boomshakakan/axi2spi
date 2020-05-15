library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package components_pkg is

    component registers is
        port (
            clk         :   in std_logic;
            rst_n       :   in std_logic;
            stb_in      :   in std_logic_vector(1 downto 0);
            wr_data     :   in std_logic_vector(31 downto 0); -- input to be written to register
            
            SRR_RST     :   out std_logic;
            INTERRUPT   :   out std_logic;
            
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
            
            SRR         :   out std_logic_vector(31 downto 0);
            SPICR       :   out std_logic_vector(31 downto 0);
            SPISR       :   out std_logic_vector(31 downto 0);
            SPIDTR      :   out std_logic_vector(31 downto 0);
            SPIDRR      :   out std_logic_vector(31 downto 0);
            SPISSR      :   out std_logic_vector(31 downto 0); 
            Tx_FIFO_OCY :   out std_logic_vector(31 downto 0);
            Rx_FIFO_OCY :   out std_logic_vector(31 downto 0);
            DGIER       :   out std_logic_vector(31 downto 0);
            IPISR       :   inout std_logic_vector(31 downto 0);
            IPIER       :   out std_logic_vector(31 downto 0)
        );
    
    end component;
    
    component load_register is
        port (
            clk     :   in std_logic;
            wr_en   :   in std_logic;
            load_en :   in std_logic;
            load    :   in std_logic_vector(31 downto 0);
            stb_in  :   in std_logic_vector(1 downto 0);
            d_in    :   in std_logic_vector(31 downto 0);
            d_out   :   out std_logic_vector(31 downto 0)
        );
    end component;
    
    component toggle_on_write is
        port (
            clk     :   in std_logic;
            wr_en   :   in std_logic;
            load_en :   in std_logic;
            load    :   in std_logic_vector(31 downto 0);
            d_in    :   in std_logic_vector(31 downto 0);
            d_out   :   inout std_logic_vector(31 downto 0)
        );
    end component;

end components_pkg;
