library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;

entity ULA is
	port
	(
		A: in std_logic_vector (31 downto 0);
		B: in std_logic_vector (31 downto 0);
		OP: in std_logic_vector (3 downto 0);
		Z: out std_logic_vector (31 downto 0);
		OVER, ZERO, VAI: out std_logic
	);
end entity;

architecture Comportamental of ULA is
	signal sA,sB : std_logic_vector (31 downto 0);
	signal sZ : std_logic_vector (32 downto 0);
	signal sOP : std_logic_vector (3 downto 0);
	signal sZero, sOver : std_logic;
	signal sSub: std_logic_vector (32 downto 0);
	signal sAdd: std_logic_vector (32 downto 0);
	constant aux_zero : std_logic_vector(31 downto 0) := (others => '0');
	constant aux_X    : std_logic_vector(31 downto 0) := (others => '-');
	begin
	--Setar as entradas
	sA    <= A;
	sB    <= B;
	sOP   <= OP;
	sSub  <= std_logic_vector('0' & signed(sA) - signed('0' & sB));
	sAdd  <= std_logic_vector('0' & signed(sA) + signed ('0' & sB));
	sZero <= '1' when (sZ = ('0' & aux_zero)) else '0';
	sOver <= '1' when (
								((sA(31) = sB(31) and (sZ(31) /= sA(31)))
								or ((sA(31) /= sB(31)) and (sZ(31) /= sA(31))))
								and (sOP = "0000" or sOP = "0001")
							) else '0';
	--Setar as saidas
	VAI   <= sZ(32);
	Z     <= sZ(31 downto 0);
	ZERO  <= sZero;
	OVER  <= sOver;
	process(sA,sB,sOP,sSub,sAdd)
	begin
			case sOP is
				when "0000" => --RES = A + B
					sZ <= sAdd;
				when "0001" => --RES = A - B
					sZ <= sSub;
				when "0010" => --RES = A & B
					sZ <= '0' & (sA and sB);
				when "0011" => --RES = A | B
					sZ <= '0' & (sA or sB);
				when "0100" => --RES = !A
					sZ <= '0' & (not sA);
				when "0101" => --RES = A ^ B
					sZ <= '0' & (sA xor sB);
				when "0110" => --RES = A SLL B
					sZ <= '0' & (std_logic_vector(unsigned(sB) sll to_integer(unsigned(sA))));
				when "0111" => --RES = A SRL B
					sZ <= '0' & (std_logic_vector(unsigned(sB) srl to_integer(unsigned(sA))));
				when "1110" => --RES = A SRA B
					sZ <= '0' & (to_stdlogicvector(to_bitvector(sB) sra to_integer(unsigned(sA))));
				when "1111" => --RES = (a<b)?1:0
					if(signed(sA) < signed(sB)) then
						sZ <= std_logic_vector(to_unsigned(1,33)); 
					else
						sZ <= '0' & aux_zero;
					end if;
				when "1001" => -- RES = A nor B
					sZ <= '0' & (sA nor sB);
				when others => 
					sZ	   <= '-' & aux_X;--nada ocorreu
			end case;
	end process;
end architecture;
