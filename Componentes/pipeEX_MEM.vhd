library ieee;
use ieee.std_logic_1164.all;

-- Registro Pipeline EX - MEM

entity pipeEX_MEM is
    generic(W : integer);
    port (clk            : in std_logic;-- := '0';
          RegWriteE  	 : in std_logic;-- := '0';
          MemtoRegE 	    : in std_logic;-- := '0';
          MemWriteE      : in std_logic;-- := '0';
          ZeroE          : in std_logic;-- := '0';
          AluOutE        : in std_logic_vector(W-1 downto 0);-- := (others => '0');
          outBE		    : in std_logic_vector(W-1 downto 0);-- := (others => '0');
          WriteRegE      : in std_logic_vector(4 downto 0);--   := (others => '0');
          PcBranchE      : in std_logic_vector(W-1 downto 0);-- := (others => '0');
			 BranchEQE		 : in std_logic;-- := '0';
			 BranchNEE		 : in std_logic;-- := '0';
          RegWriteM  	 : out std_logic ;--:= '0';
          MemtoRegM 		 : out std_logic ;--:= '0';
          MemWriteM  	 : out std_logic ;--:= '0';
          ZeroM          : out std_logic ;--:= '0';
          AluOutM        : out std_logic_vector(W-1 downto 0);--:= (others => '0');
          WriteDataM     : out std_logic_vector(W-1 downto 0);--:= (others => '0');
          WriteRegM      : out std_logic_vector(4 downto 0);--  := (others => '0');
          PcBranchM      : out std_logic_vector(W-1 downto 0);--:= (others => '0');
			 BranchEQM 	 	 : out std_logic;-- := '0';
			 BranchNEM		 : out std_logic-- := '0'
			 );
end entity;

architecture comportamental of pipeEX_MEM is
    begin
        process(clk)
        begin
            if( rising_edge(clk)) then
					RegWriteM	 <= RegWriteE;
					MemtoRegM	 <= MemtoRegE;
					MemWriteM	 <= MemWriteE;
					ZeroM 		 <= ZeroE;
					AluOutM 		 <= AluOutE;
					WriteDataM 	 <= outBE;
					WriteRegM 	 <= WriteRegE;
					PcBranchM 	 <= PcBranchE;
					BranchEQM 	 <= BranchEQE;
					BranchNEM 	 <= BranchNEE;
				end if;
        end process;
end architecture;