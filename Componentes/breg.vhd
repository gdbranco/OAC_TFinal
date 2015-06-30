library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity breg is
  port(
	 addA, addB, addW      					: in  std_logic_vector(4 downto 0);
    saidaA				  	 		         : out std_logic_vector(31 downto 0);
    saidaB       					         : out std_logic_vector(31 downto 0);
    wdata      				            : in  std_logic_vector(31 downto 0);
    writeEnable,CLK 				         : in  std_logic
    );
end entity;

architecture comportalmental of breg is
  type sub_breg is array(0 to 31) of std_logic_vector(31 downto 0);
  signal registradores : sub_breg := (others => (others => '0'));
begin
  process (CLK,addA,addB,registradores)
  begin
		-- Escreve
		if (rising_edge(CLK)) then
			if (writeEnable = '1') then --Se selecionado para escrita
				if(addW = std_logic_vector(to_unsigned(0,5))) then --Se selecionado for 0 devolve 0
					NULL;
				else
					registradores(to_integer(unsigned(addW))) <= wdata;  -- Escreve no selecionado para escrita
				end if;
			end if;
		end if;
		--Leia A e B
		saidaA <= registradores(to_integer(unsigned(addA)));
		saidaB <= registradores(to_integer(unsigned(addB)));
  end process;
end;