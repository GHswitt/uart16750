--
-- Package for UART testing
--
-- Author:  Sebastian Witt
-- Version: 1.0
-- Date:    31.01.2008
--
-- SPDX-License-Identifier: BSD-3-Clause
--

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use std.textio.all;

use work.txt_util.all;


package uart_package is
    constant CYCLE  : time := 30 ns;

    -- UART register addresses
    constant A_RBR  : std_logic_vector(2 downto 0) := "000";
    constant A_DLL  : std_logic_vector(2 downto 0) := "000";
    constant A_THR  : std_logic_vector(2 downto 0) := "000";
    constant A_DLM  : std_logic_vector(2 downto 0) := "001";
    constant A_IER  : std_logic_vector(2 downto 0) := "001";
    constant A_IIR  : std_logic_vector(2 downto 0) := "010";
    constant A_FCR  : std_logic_vector(2 downto 0) := "010";
    constant A_LCR  : std_logic_vector(2 downto 0) := "011";
    constant A_MCR  : std_logic_vector(2 downto 0) := "100";
    constant A_LSR  : std_logic_vector(2 downto 0) := "101";
    constant A_MSR  : std_logic_vector(2 downto 0) := "110";
    constant A_SCR  : std_logic_vector(2 downto 0) := "111";

    -- UART input interface
    type uart_interface is record
        CS      : std_logic;
        WR      : std_logic;
        RD      : std_logic;
        A       : std_logic_vector (2 downto 0);
        DATA    : std_logic_vector (7 downto 0);
    end record;

    -- Write to UART
    procedure uart_write (signal ui : inout uart_interface;
                          addr      : in std_logic_vector (2 downto 0);
                          data      : in std_logic_vector (7 downto 0);
                          file log  : TEXT
                         );

    -- Read from UART
    procedure uart_read  (signal ui : inout uart_interface;
                          addr      : in std_logic_vector(2 downto 0);
                          ret       : out std_logic_vector(7 downto 0);
                          file log  : TEXT
                         );

    -- Compare two std_logig_vectors (handles don't-care)
    function compare (d1 : std_logic_vector; d2 : std_logic_vector) return boolean;

end uart_package;

package body uart_package is
    -- Write to UART
    procedure uart_write (signal ui : inout uart_interface;
                          addr      : in std_logic_vector (2 downto 0);
                          data      : in std_logic_vector (7 downto 0);
                          file log  : TEXT
                         ) is
    begin
        print (log, "UART write: 0x" & hstr(addr) & " : 0x" & hstr(data));
        wait for cycle;
        assert ui.DATA = "ZZZZZZZZ" report "Data bus not tri-state" severity warning;
        ui.A     <= addr;
        ui.DATA  <= data;
        ui.CS    <= '1';
        wait for cycle;
        ui.WR   <= '1';
        wait for cycle;
        ui.WR   <= '0';
        ui.CS   <= '0';
        ui.DATA <= (others => 'Z');
    end uart_write;

    -- Read from UART
    procedure uart_read  (signal ui : inout uart_interface;
                          addr      : in std_logic_vector(2 downto 0);
                          ret       : out std_logic_vector(7 downto 0);
                          file log  : TEXT
                         ) is
        variable data : std_logic_vector(7 downto 0);
    begin
        wait for cycle;
        assert ui.DATA = "ZZZZZZZZ" report "Data bus not tri-state" severity warning;
        ui.A    <= addr;
        ui.CS   <= '1';
        wait for cycle;
        ui.RD   <= '1';
        wait for cycle;
        data    := ui.DATA;
        wait for cycle;
        ui.RD   <= '0';
        ui.CS   <= '0';
        print (log, "UART read:  0x" & hstr(addr) & " : 0x" & hstr(data));
        ret     := data;
    end uart_read;

    -- Compare two std_logig_vectors (handles don't-care)
    function compare (d1 : std_logic_vector; d2 : std_logic_vector) return boolean is
        variable i : natural;
    begin
        for i in d1'range loop
            if (not (d1(i)='-' or d2(i)='-')) then
                if (d1(i)/=d2(i)) then
                    return false;
                end if;
            end if;
        end loop;
        return true;
    end compare;

end uart_package;

