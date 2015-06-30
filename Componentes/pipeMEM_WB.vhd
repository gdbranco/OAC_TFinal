library ieee;
use ieee.std_logic_1164.all;

-- Registro pipeline MEM - WB

entity pipeMEM_WB is
    generic(W : integer);
    port (clk           : in std_logic;-- := '0';
          RegWriteM   	: in std_logic;-- := '0';
          MemtoRegM   	: in std_logic;-- := '0';
          ReadDataM     : in std_logic_vector(W-1 downto 0);-- := (others => '0');
          AluOutM       : in std_logic_vector(W-1 downto 0);-- := (others => '0');
          WriteRegM     : in std_logic_vector(4 downto 0)   ;--:= (others => '0');
          RegWriteWB 	: out std_logic;-- := '0';
          MemtoRegWB 	: out std_logic;-- := '0';
          ReadDataWB   	: out std_logic_vector(W-1 downto 0);--:= (others => '0');
          AluOutWB     	: out std_logic_vector(W-1 downto 0);--:= (others => '0');
          WriteRegWB  	: out std_logic_vector(4 downto 0)-- := (others => '0')
			 );
end entity;

architecture comportamental of pipeMEM_WB is
begin
	  process(clk)
	  begin
			if(rising_edge(clk)) then
				RegWriteWB <= RegWriteM;
				MemtoRegWB <= MemtoRegM;
				AluOutWB <= AluOutM;
				ReadDataWB <= ReadDataM;
				WriteRegWB <= WriteRegM;
			end if;
	  end process;
end architecture;