--
-- Majority voting filter
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


entity slib_mv_filter is
    generic (
        WIDTH       : natural := 4;
        THRESHOLD   : natural := 10
    );
    port (
        CLK         : in std_logic;                             -- Clock
        RST         : in std_logic;                             -- Reset
        SAMPLE      : in std_logic;                             -- Clock enable for sample process
        CLEAR       : in std_logic;                             -- Reset process
        D           : in std_logic;                             -- Signal input
        Q           : out std_logic                             -- Signal D was at least THRESHOLD samples high
    );
end slib_mv_filter;

architecture rtl of slib_mv_filter is

    -- Signals
    signal iCounter     : unsigned(WIDTH downto 0);             -- Sample counter
    signal iQ           : std_logic;                            -- Internal Q

begin
    -- Main process
    MV_PROC: process (RST, CLK)
    begin
        if (RST = '1') then
            iCounter  <= (others => '0');
            iQ        <= '0';
        elsif (CLK'event and CLK='1') then
            if (iCounter >= THRESHOLD) then                     -- Compare with threshold
                iQ <= '1';
            else
                if (SAMPLE = '1' and D = '1') then              -- Take sample
                    iCounter <= iCounter + 1;
                end if;
            end if;

            if (CLEAR = '1') then                               -- Reset logic
                iCounter  <= (others => '0');
                iQ        <= '0';
            end if;

        end if;
    end process;

    -- Output signals
    Q <= iQ;

end rtl;

