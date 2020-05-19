library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity async_fifo is
    port (
        rst     :   in std_logic;
        -- write channel
        w_clk   :   in std_logic;
        w_en    :   in std_logic;
        full    :   out std_logic;
        w_data  :   in std_logic_vector(7 downto 0); -- check specification for data size
        -- read channel
        r_clk   :   in std_logic;
        r_en    :   in std_logic;
        empty   :   out std_logic;
        r_data  :   out std_logic_vector(7 downto 0);
        
        queue   :   out std_logic_vector(4 downto 0)
    );
end async_fifo;   

architecture Behavioral of async_fifo is

    -- figure out what the memory size should be?
    type ram_t is array(0 to 15) of std_logic_vector(7 downto 0);
    signal ram  :   ram_t;
    
    signal r_ptr        :   std_logic_vector(4 downto 0);
    signal r_ptr_tmp    :   std_logic_vector(4 downto 0);
    signal sync_r_ptr   :   std_logic_vector(4 downto 0);
    signal w_ptr        :   std_logic_vector(4 downto 0);
    signal w_ptr_tmp    :   std_logic_vector(4 downto 0);
    signal sync_w_ptr   :   std_logic_vector(4 downto 0);
    signal fifo_empty   :   std_logic;
    signal fifo_full    :   std_logic;
    signal r_addr       :   std_logic_vector(3 downto 0);
    signal w_addr       :   std_logic_vector(3 downto 0);
    signal w_logic_en   :   std_logic; 
    
begin

    -- READ LOGIC
    read_ptr_logic  :   process (r_clk, rst)
    begin
        if rst = '1' then
            r_ptr   <= "00000";
        elsif rising_edge(r_clk) then
            if ((r_en = '1') and (fifo_empty = '0')) then
                r_ptr   <= r_ptr + '1';
            end if;
        end if;
    end process read_ptr_logic;
    
    -- EMPTY LOGIC
    empty_flag_logic    :   process (sync_w_ptr, r_ptr)
    begin
        if sync_w_ptr = r_ptr then
            fifo_empty  <= '1';
        elsif sync_w_ptr(3 downto 0) = r_ptr(3 downto 0) then
            fifo_empty  <= '0';
        else
            fifo_empty  <= '0';
        end if;
    end process empty_flag_logic;
    
    r_addr  <= r_ptr(3 downto 0);
    empty   <= fifo_empty;
    
    -- WRITE LOGIC
    write_ptr_logic :   process (w_clk, rst)
    begin
        if rst = '1' then
            w_ptr   <= "00000";
        elsif rising_edge(w_clk) then
            if ((w_en = '1') and (fifo_full = '0')) then
                w_ptr   <= w_ptr + '1';
            end if;
        end if;
    end process write_ptr_logic;
    
    -- MEMORY LOGIC
    fifo_ram    :   process (w_clk)
    begin
        if rising_edge(w_clk) then
            if w_logic_en = '1' then
                ram(to_integer(unsigned(w_addr)))    <= w_data;
            end if;
        end if;
    end process fifo_ram;
    
    r_data  <= ram(to_integer(unsigned(r_addr)));
    
    w_logic_en  <= (NOT fifo_full) and (w_en);
    
    -- WRITE TO READ SYNCH
    w_ptr_sync0 :   process (r_clk, rst)
    begin
        if rst = '1' then
            w_ptr_tmp   <= "00000";
        elsif rising_edge(r_clk) then
            w_ptr_tmp   <= w_ptr;
        end if;
    end process w_ptr_sync0;
    
    w_ptr_sync1 :   process (r_clk, rst)
    begin
        if rst = '1' then
            sync_w_ptr  <= "00000";
        elsif rising_edge(r_clk) then
            sync_w_ptr  <= w_ptr_tmp;
        end if;
    end process w_ptr_sync1;

    r_ptr_sync0 :   process (w_clk, rst)
    begin
        if rst = '1' then
            r_ptr_tmp   <= "00000";
        elsif rising_edge(w_clk) then
            r_ptr_tmp   <= r_ptr;
        end if;
    end process r_ptr_sync0;
    
    r_ptr_sync1 :   process (w_clk, rst)
    begin
        if rst = '1' then
            sync_r_ptr  <= "00000";
        elsif rising_edge(w_clk) then
            sync_r_ptr  <= r_ptr_tmp;
        end if;
    end process r_ptr_sync1;
    
end Behavioral;
