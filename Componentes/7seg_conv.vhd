library IEEE;
use IEEE.Std_Logic_1164.all;

entity hex_conv is 
	Port 
	( 
		data :in std_logic_vector(3 downto 0);
		saida:out std_logic_vector(6 downto 0)
	);
end entity;

architecture comportamental of hex_conv is
begin
	process(data) begin
		case data is
			when "0000" => saida <= "1000000";
			when "0001" => saida <= "1111001";
			when "0010" => saida <= "0100100";
			when "0011" => saida <= "0110000";
			when "0100" => saida <= "0011001";
			when "0101" => saida <= "0010010";
			when "0110" => saida <= "0000010";
			when "0111" => saida <= "1111000";
			when "1000" => saida <= "0000000";
			when "1001" => saida <= "0010000";
			when "1010" => saida <= "0001000";
			when "1011" => saida <= "0000011";
			when "1100" => saida <= "1000110";
			when "1101" => saida <= "0100001";
			when "1110" => saida <= "0000110";
			when "1111" => saida <= "0001110"; 
			when others => saida <= "1111111";
		end case;
	end process;
end;