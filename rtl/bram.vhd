--------------------------------------------------------------
-- Single port Block RAM
--------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY spram IS
	generic (
		addr_width    : integer := 8;
		data_width    : integer := 8;
		mem_init_file : string := " ";
		mem_preload   : boolean := false;
		mem_name      : string := "MEM" -- for InSystem Memory content editor.
	);
	PORT
	(
		clock   : in  STD_LOGIC;
		address : in  STD_LOGIC_VECTOR (addr_width-1 DOWNTO 0);
		data    : in  STD_LOGIC_VECTOR (data_width-1 DOWNTO 0) := (others => '0');
		enable  : in  STD_LOGIC := '1';
		wren    : in  STD_LOGIC := '0';
		q       : out STD_LOGIC_VECTOR (data_width-1 DOWNTO 0);
		cs      : in  std_logic := '1'
	);
END;

ARCHITECTURE mega65 OF spram IS
	signal q0 : std_logic_vector((data_width - 1) downto 0);

BEGIN
	q<= q0 when cs = '1' else (others => '1');

	raminit_component : entity work.ram_init
	GENERIC MAP (
		G_ROM_FILE => mem_init_file,
		G_ROM_PRELOAD => mem_preload,
		G_ROM_FILE_HEX => false,
		G_ADDR_WIDTH => addr_width,
		G_DATA_WIDTH => data_width
	)
	PORT MAP (
		address_i => address,
		clock_i => clock,
		data_i => data,
		wren_i => wren and cs,
		q_o => q0
	);

END;
