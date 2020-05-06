library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package components_pkg is

    component registers is
        port (
            clk_in      :   in std_logic;
            rst         :   in std_logic;
            -- 
            d_in        :   in std_logic_vector(31 downto 0); -- input from AXI4?
        
            --  NOT SURE THESE ARE INPUT VECTORS
            SRR     :   out std_logic_vector(31 downto 0);
            SPICR   :   out std_logic_vector(31 downto 0);
            SPISR   :   out std_logic_vector(31 downto 0);
            SPIDTR  :   out std_logic_vector(31 downto 0);
            SPIDRR  :   out std_logic_vector(31 downto 0);
            SPISSR  :   out std_logic_vector(31 downto 0);
            
            Tx_FIFO_OCY :   out std_logic_vector(31 downto 0);
            Rx_FIFO_OCY :   out std_logic_vector(31 downto 0);
            DGIER       :   out std_logic_vector(31 downto 0);
            IPISR       :   out std_logic_vector(31 downto 0);
            IPIER       :   out std_logic_vector(31 downto 0)
        );
    
    end component;
    
    component load_register is
        port (
            clk     :   in std_logic;
            load    :   in std_logic;
            d_in    :   in std_logic_vector(31 downto 0);
            d_out   :   out std_logic_vector(31 downto 0)
        );
    end component;

end components_pkg;
