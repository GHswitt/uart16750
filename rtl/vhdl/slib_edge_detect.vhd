--
-- Signal edge detect
--
-- Author:   Sebastian Witt
-- Data:     27.01.2008
-- Version:  1.1
--
-- SPDX-License-Identifier: BSD-3-Clause
--

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity slib_edge_detect is
    port (
        CLK         : in std_logic;     -- Clock
        RST         : in std_logic;     -- Reset
        D           : in std_logic;     -- Signal input
        RE          : out std_logic;    -- Rising edge detected
        FE          : out std_logic     -- Falling edge detected
    );
end slib_edge_detect;

architecture rtl of slib_edge_detect is
    signal iDd : std_logic;             -- D register
begin
    -- Store D
    ED_D: process (RST, CLK)
    begin
        if (RST  = '1') then
            iDd <= '0';
        elsif (CLK'event and CLK='1') then
            iDd <= D;
        end if;
    end process;

    -- Output ports
    RE <= '1' when iDd = '0' and D = '1' else '0';
    FE <= '1' when iDd = '1' and D = '0' else '0';

end rtl;


