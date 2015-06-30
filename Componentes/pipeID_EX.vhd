library ieee;
use ieee.std_logic_1164.all;
use work.utilidades.Controller;
-- Registro Pipeline ID - EX

entity pipeID_EX is
	generic(W : integer);
	port (clk 				: in std_logic;-- := '0';
			pc_4D 			: in std_logic_vector(31 downto 0);-- := (others => '0');
			outAD 			: in std_logic_vector(31 downto 0);-- := (others => '0');
			outBD, imm32D,shamt32D 	: in std_logic_vector(31 downto 0);-- := (others => '0');
			riD            : in std_logic_vector(31 downto 0);
			rtD, rdD			: in std_logic_vector(4 downto 0);--  := (others => '0');
			op					: in std_logic_vector(5 downto 0);--  := (others => '0');
			funct				: in std_logic_vector(5 downto 0);--  := (others => '0');
			regDstE 			: out std_logic;-- := '0';
			ulaSRCE			: out std_logic_vector(1 downto 0);-- := '0';
			memTOregE		: out std_logic ;--:= '0';
			regWriteE		: out std_logic;-- := '0';
			--memReadE			: out std_logic := '0';
			memWriteE		: out std_logic ;--:= '0';
			BranchEQE		: out std_logic ;--:= '0';
			BranchNEE		: out std_logic;-- := '0';
			JumpE				: out std_logic;-- := '0';
			ulaCTRLE			: out std_logic_vector(3 downto 0);-- := (others => '0');
			pc_4E				: out std_logic_vector(31 downto 0);-- := (others => '0');
			outAE, outBE	: out std_logic_vector(31 downto 0);-- := (others => '0');
			imm32E			: out std_logic_vector(31 downto 0);-- := (others => '0');
			rtE, rdE			: out std_logic_vector(4 downto 0);-- := (others => '0')
			shamt32E       : out std_logic_vector(31 downto 0);
			riE            : out std_logic_vector(31 downto 0);
			s_controlesE   : out std_logic_vector(11 downto 0) 
			);
end entity;

architecture comportamental of pipeID_EX is
	signal		RegDst	: std_logic;
	signal		ULAsrc	: std_logic_vector(1 downto 0);
	signal		MemToReg : std_logic;
	signal		RegWrite : std_logic;
	signal		MemWrite : std_logic;
	signal		Jump		: std_logic;
	signal		BranchEQ	: std_logic;
	signal		BranchNE : std_logic;
	signal		ULActrl	: std_logic_vector (3 downto 0);
	signal      s_controlesD  : std_logic_vector (11 downto 0);
	begin
		controle : Controller port map (
						op, funct, regDst, ulaSRC, memTOreg,
						regWrite, --memReadE,
						memWrite,Jump, BranchEQ, BranchNE,
						ulaCTRL,s_controlesD);
		process(clk)
			begin
				if(rising_edge(clk)) then
					pc_4E 	<= pc_4D;
					outAE 	<= outAD;
					outBE		<= outBD;
					imm32E 	<= imm32D;
					rtE		<= rtD;
					rdE		<= rdD;
					RegDstE	<= RegDst;	
					ULAsrcE  <= ULAsrc;	
					MemToRegE<= MemToReg; 
					RegWriteE<= RegWrite;
					MemWriteE<= MemWrite;
					JumpE    <= Jump;
					BranchEQE<= BranchEQ;	
					BranchNEE<= BranchNE;
					ULActrlE <= ULActrl;
					shamt32E <= shamt32D;
					riE      <= riD;
					s_controlesE <= s_controlesD;
				end if;
		end process;	
end architecture;