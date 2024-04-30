--
-- UART Baudrate generator
--
-- Author:   Sebastian Witt
-- Date:     27.01.2008
-- Version:  1.1
--
-- SPDX-License-Identifier: BSD-3-Clause
--

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

-- Serial UART baudrate generator
entity uart_baudgen is
    port (
        CLK         : in std_logic;                                 -- Clock
        RST         : in std_logic;                                 -- Reset
        CE          : in std_logic;                                 -- Clock enable
        CLEAR       : in std_logic;                                 -- Reset generator (synchronization)
        DIVIDER     : in std_logic_vector(15 downto 0);             -- Clock divider
        BAUDTICK    : out std_logic                                 -- 16xBaudrate tick
    );
end uart_baudgen;

architecture rtl of uart_baudgen is
    -- Signals
    signal iCounter : unsigned(15 downto 0);
begin
    -- Baudrate counter
    BG_COUNT: process (CLK, RST)
    begin
        if (RST = '1') then
            iCounter <= (others => '0');
            BAUDTICK <= '0';
        elsif (CLK'event and CLK = '1') then
            if (CLEAR = '1') then
                iCounter <= (others => '0');
            elsif (CE = '1') then
                iCounter <= iCounter + 1;
            end if;

            BAUDTICK <= '0';
            if (iCounter = unsigned(DIVIDER)) then
                iCounter <= (others => '0');
                BAUDTICK <= '1';
            end if;
        end if;
    end process;

end rtl;


