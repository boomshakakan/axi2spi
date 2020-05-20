library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.components_pkg.all;

entity tb_registers is
end tb_registers;

architecture Behavioral of tb_registers is

    constant fifo_no_exist  :   std_logic := '1';
    signal clk_i    :   std_logic := '0';
    signal rst_i    :   std_logic;
    signal stb_i    :   std_logic_vector(3 downto 0);
    signal data_i   :   std_logic_vector(31 downto 0);
    -- signal data_o   :   std_logic_vector(31 downto 0);
    
    signal SRR_RST  :   std_logic;
    
    -- REGISTER ENABLES
    signal en_0, en_1, en_2, en_3, en_4, en_5, en_6, en_7, en_8, en_9, en_10   : std_logic;
    -- AXI & SPI REGISTERS
    signal SRR, SPICR, SPISR, SPIDTR, SPIDRR, SPISSR    : std_logic_vector(31 downto 0);
    -- INTERRUPTS
    signal Tx_FIFO_OCY, Rx_FIFO_OCY,DGIER, IPISR, IPIER : std_logic_vector(31 downto 0);
begin

    clk_i   <= not clk_i after 10ns;
    rst_i   <= '0', '1' after 50ns;
    
    data_i  <= x"0000000A";
    stb_i   <= "1111";
    
    process
    begin
        en_0    <= '1';
        wait for 100ns;
        en_0    <= '0';
        en_6    <= '1';
        wait for 50ns;
        en_6    <= '0';
        en_7    <= '1';
        wait for 50ns;
        en_7    <= '0';

    end process DUT;
    
    DUT :   registers
        generic map (FIFO_NOT_EXIST => fifo_no_exist)
        port map (
            clk             => clk_i,
            rst_n           => rst_i,
            wr_data         => data_i,
            stb_in          => stb_i,
            SRR_RST         => SRR_RST,
            SRR_en          => en_0,
            SPICR_en        => en_1,
            SPISR_en        => en_2,
            SPIDTR_en       => en_3,
            SPIDRR_en       => en_4,
            SPISSR_en       => en_5,
            Tx_FIFO_OCY_en  => en_6,
            Rx_FIFO_OCY_en  => en_7,
            DGIER_en        => en_8,
            IPISR_en        => en_9,
            IPIER_en        => en_10,
            SRR             => SRR,
            SPICR           => SPICR,
            SPISR           => SPISR,
            SPIDTR          => SPIDTR,
            SPIDRR          => SPIDRR,
            SPISSR          => SPISSR,
            Tx_FIFO_OCY     => Tx_FIFO_OCY,
            Rx_FIFO_OCY     => Rx_FIFO_OCY,
            DGIER           => DGIER,
            IPISR           => IPISR,
            IPIER           => IPIER
        );

end Behavioral;
