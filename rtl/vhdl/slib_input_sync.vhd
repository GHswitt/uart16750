--
-- Input synchronization
--
-- Author:   Sebastian Witt
-- Data:     27.01.2008
-- Version:  1.0
--
-- SPDX-License-Identifier: BSD-3-Clause
--

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity slib_input_sync is
    port (
        CLK         : in std_logic;     -- Clock
        RST         : in std_logic;     -- Reset
        D           : in std_logic;     -- Signal input
        Q           : out std_logic     -- Signal output
    );
end slib_input_sync;

architecture rtl of slib_input_sync is
    signal iD : std_logic_vector(1 downto 0);
begin
    IS_D: process (RST, CLK)
    begin
        if (RST  = '1') then
            iD <= (others => '0');
        elsif (CLK'event and CLK='1') then
            iD(0) <= D;
            iD(1) <= iD(0);
        end if;
    end process;

    -- Output ports
    Q <= iD(1);

end rtl;

