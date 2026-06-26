--//============================================================================
--//  MSX1
--//  Keyboard matrix maping
--//  Copyright (C) 2021 molekula
--//
--//  This program is free software; you can redistribute it and/or modify it
--//  under the terms of the GNU General Public License as published by the Free
--//  Software Foundation; either version 2 of the License, or (at your option)
--//  any later version.
--//
--//  This program is distributed in the hope that it will be useful, but WITHOUT
--//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
--//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
--//  more details.
--//
--//  You should have received a copy of the GNU General Public License along
--//  with this program; if not, write to the Free Software Foundation, Inc.,
--//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
--//
--//============================================================================
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity keyboard is
	port (
		reset_n_i    : in  std_logic;
		clk_i        : in  std_logic;
		kb_scancode  : in  std_logic_vector(6 downto 0);
		kb_release   : in  std_logic;
		kb_addr_i    : in  std_logic_vector(3 downto 0);
		kb_data_o    : out std_logic_vector(7 downto 0)
	);
end keyboard;


architecture rtl of keyboard is
	type keyMatrixType is array(8 downto 0) of std_logic_vector(7 downto 0);
	signal keyMatrix : keyMatrixType := (others => (others => '1'));
	signal shift : std_logic_vector(1 downto 0) := (others => '1');
begin
	kb_data_o <= keyMatrix(to_integer(unsigned(kb_addr_i)))(7 downto 0)
				 when to_integer(unsigned(kb_addr_i)) < 9
				 else (others => '1');

	decode : process (clk_i)
    variable idx: integer;
	begin
		if rising_edge(clk_i) then
          idx := to_integer(unsigned(kb_scancode));
					case idx is
						-- 0
						when 35 => keyMatrix(0)(0) <= kb_release; -- 0
						when 56 => keyMatrix(0)(1) <= kb_release; -- 1
						when 59 => keyMatrix(0)(2) <= kb_release; -- 2
						when 8 => keyMatrix(0)(3) <= kb_release; -- 3
						when 11 => keyMatrix(0)(4) <= kb_release; -- 4
						when 16 => keyMatrix(0)(5) <= kb_release; -- 5
						when 19 => keyMatrix(0)(6) <= kb_release; -- 6
						when 24 => keyMatrix(0)(7) <= kb_release; -- 7
						-- 1
						when 27 => keyMatrix(1)(0) <= kb_release; -- 8
						when 32 => keyMatrix(1)(1) <= kb_release; -- 9
						when 43 => keyMatrix(1)(2) <= kb_release; -- -
						when 53 => keyMatrix(1)(3) <= kb_release; -- =
						when 45 => keyMatrix(1)(4) <= kb_release; -- \ -- colon on mega65
						when 46 => keyMatrix(1)(5) <= kb_release; -- [ -- @ on mega65
						when 49 => keyMatrix(1)(6) <= kb_release; -- ] -- * on mega65
						when 50 => keyMatrix(1)(7) <= kb_release; -- ;
						-- 2
						--when x"52" => keyMatrix(2)(0) <= kb_release; -- '
						--when x"0e" => keyMatrix(2)(1) <= kb_release; -- `
						when 47 => keyMatrix(2)(2) <= kb_release; -- ,
						when 44 => keyMatrix(2)(3) <= kb_release; -- .
						when 55 => keyMatrix(2)(4) <= kb_release; -- /
						--when x"01" => keyMatrix(2)(5) <= kb_release; -- F11 (DEAD KEY)
						when 10 => keyMatrix(2)(6) <= kb_release; -- A
						when 28 => keyMatrix(2)(7) <= kb_release; -- B
						-- 3
						when 20 => keyMatrix(3)(0) <= kb_release; -- C
						when 18 => keyMatrix(3)(1) <= kb_release; -- D
						when 14 => keyMatrix(3)(2) <= kb_release; -- E
						when 21 => keyMatrix(3)(3) <= kb_release; -- F
						when 26 => keyMatrix(3)(4) <= kb_release; -- G
						when 29 => keyMatrix(3)(5) <= kb_release; -- H
						when 33 => keyMatrix(3)(6) <= kb_release; -- I
						when 34 => keyMatrix(3)(7) <= kb_release; -- J
						-- 4
						when 37 => keyMatrix(4)(0) <= kb_release; -- K
						when 42 => keyMatrix(4)(1) <= kb_release; -- L
						when 36 => keyMatrix(4)(2) <= kb_release; -- M
						when 39 => keyMatrix(4)(3) <= kb_release; -- N
						when 38 => keyMatrix(4)(4) <= kb_release; -- O
						when 41 => keyMatrix(4)(5) <= kb_release; -- P
						when 62 => keyMatrix(4)(6) <= kb_release; -- Q
						when 17 => keyMatrix(4)(7) <= kb_release; -- R
						-- 5
						when 13 => keyMatrix(5)(0) <= kb_release; -- S
						when 22 => keyMatrix(5)(1) <= kb_release; -- T
						when 30 => keyMatrix(5)(2) <= kb_release; -- U
						when 31 => keyMatrix(5)(3) <= kb_release; -- V
						when 9 => keyMatrix(5)(4) <= kb_release; -- W
						when 23 => keyMatrix(5)(5) <= kb_release; -- X
						when 25 => keyMatrix(5)(6) <= kb_release; -- Y
						when 12 => keyMatrix(5)(7) <= kb_release; -- Z
						-- 6
						when 15 => shift(0) <= kb_release; -- LEFT SHIFT
						when 52 => shift(1) <= kb_release; -- RIGHT SHIFT
						when 58 => keyMatrix(6)(1) <= kb_release; -- LEFT CTRL
						when 66 => keyMatrix(6)(2) <= kb_release; -- RIGHT ALT (GRAPH)
						when 72 => keyMatrix(6)(3) <= kb_release; -- CAPS LOCK
						--when x"09" => keyMatrix(6)(4) <= kb_release; -- F10 (CODE)
						when 4 => keyMatrix(6)(5) <= kb_release; -- F1
						--when x"06" => keyMatrix(6)(6) <= kb_release; -- F2
						when 5 => keyMatrix(6)(7) <= kb_release; -- F3
						-- 7
						--when x"0c" => keyMatrix(7)(0) <= kb_release; -- F4
						when 6 => keyMatrix(7)(1) <= kb_release; -- F5
						when 71 => keyMatrix(7)(2) <= kb_release; -- ESC
						when 65 => keyMatrix(7)(3) <= kb_release; -- TAB
						when 63 => keyMatrix(7)(4) <= kb_release; -- pause/break (STOP)
						when 0 => keyMatrix(7)(5) <= kb_release; -- BACKSPACE
						when 69 => keyMatrix(7)(6) <= kb_release; -- F11 (SELECT)
						when 1 => keyMatrix(7)(7) <= kb_release; -- ENTER
						-- 8
						when 60 => keyMatrix(8)(0) <= kb_release; -- SPACE
						when 51 => keyMatrix(8)(1) <= kb_release; -- HOME
						--when x"70" => keyMatrix(8)(2) <= kb_release; -- INS
						--when x"71" => keyMatrix(8)(3) <= kb_release; -- DEL
						when 74 => keyMatrix(8)(4) <= kb_release; -- LEFT ARROW
						when 73 => keyMatrix(8)(5) <= kb_release; -- UP ARROW
						when 7 => keyMatrix(8)(6) <= kb_release; -- DOWN ARROW
						when 2 => keyMatrix(8)(7) <= kb_release; -- RIGH ARROW
						when others =>null;
					end case;
		end if;
		keyMatrix(6)(0) <= shift(0) and shift(1);
	end process;
end;
