library ieee;
use ieee.std_logic_1164.all;

-- Registro Pipeline IF - ID

entity pipeIF_ID is
    generic(W : integer);
    Port (instruction : in std_logic_vector(W-1 downto 0);-- := (others => '0');
          pcplus4     : in std_logic_vector(W-1 downto 0) ;--:= (others => '0');
          clk         : in std_logic;-- := '0';
          instr_out   : out std_logic_vector(W-1 downto 0);--:= (others => '0');
          pc_out      : out std_logic_vector(W-1 downto 0)--:= (others => '0')
			 );
    end;

architecture comportamental of PipeIF_ID is
    begin
        process(clk)
        begin
            if( rising_edge(clk)) then
                instr_out <= instruction;
                pc_out <= pcplus4;
            end if;
        end process;
    end;