library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bios_rom_init_pkg.all;

entity spram_bios_pkg is
  generic (
    addr_width : integer := 8;
    data_width : integer := 8
  );
  port (
    clock   : in  std_logic;
    address : in  std_logic_vector(addr_width-1 downto 0);
    data    : in  std_logic_vector(data_width-1 downto 0);
    enable  : in  std_logic := '1';
    wren    : in  std_logic := '0';
    cs      : in  std_logic := '1';
    q       : out std_logic_vector(data_width-1 downto 0)
  );
end;

architecture rtl of spram_bios_pkg is

  constant DEPTH : integer := 2**addr_width;

  type ram_type is array (0 to DEPTH-1) of std_logic_vector(data_width-1 downto 0);

  function init_ram return ram_type is
    variable tmp : ram_type := (others => (others => '0'));
  begin
    for i in ROM_INIT'range loop
      exit when i >= DEPTH;
      tmp(i) := ROM_INIT(i);
    end loop;
    return tmp;
  end function;

  signal ram : ram_type := init_ram;

  signal q_reg : std_logic_vector(data_width-1 downto 0);

  attribute ram_style : string; attribute ram_style of ram : signal is "block";
  attribute ramstyle : string; attribute ramstyle of ram : signal is "M10K";

begin

  process(clock)
    variable a : integer;
  begin
    if rising_edge(clock) then
      if enable='1' and cs='1' then
        a := to_integer( unsigned(address));
        if wren='1' then
          ram(a) <= data;
          q_reg <= data;
        else
          q_reg <= ram(a);
        end if;
      end if;
    end if;
  end process;

  q <= q_reg when cs='1' else (others=>'1');

end rtl;
