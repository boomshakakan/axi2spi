library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package components_pkg is

    component registers is
        port (
            clk_in      :   in std_logic;
            rst         :   in std_logic;
        
            SRR      :  in std_logic_vector(31 downto 0);
            SPICR    :  in std_logic_vector(31 downto 0);
            SPISR    :  in std_logic_vector(31 downto 0);
            SPIDTR  :   in std_logic_vector(31 downto 0);
            SPIDRR  :   in std_logic_vector(31 downto 0);
            SPISSR  :   in std_logic_vector(31 downto 0);
            
            Tx_FIFO_OCY :   in std_logic_vector(31 downto 0);
            Rx_FIFO_OCY :   in std_logic_vector(31 downto 0);
            DGIER       :   in std_logic_vector(31 downto 0);
            IPISR       :   in std_logic_vector(31 downto 0);
            IPIER       :   in std_logic_vector(31 downto 0)
        );
    
    end component;

end components_pkg;
