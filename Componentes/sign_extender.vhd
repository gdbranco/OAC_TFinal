library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utilidades.all;

entity sign_extender is
	generic(W: integer := 16);
	port( A:in std_logic_vector(W-1 downto 0);
			Y: out std_logic_vector(regWIDTH-1 downto 0)
	);
end entity;

architecture comportamental of sign_extender is
begin
	Y <= X"0000" & A when A(W-1) = '0' else X"FFFF" & A;
end architecture;