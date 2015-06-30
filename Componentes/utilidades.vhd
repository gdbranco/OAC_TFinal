library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------
package utilidades is
	------Constantes----------------------------------------------
	constant regWIDTH : integer := 32;
	constant raddWIDTH : integer := 5;
	constant pcaddWIDTH : integer := 8;
	constant functWIDTH  : integer := 4;
	constant opWIDTH     : integer := 6;
	------7seg_conv----------------------------------------------
	component hex_conv is 
		port (data :in std_logic_vector(opWIDTH-3 downto 0);
				saida:out std_logic_vector(opWIDTH downto 0));
	end component;
	------sign_extender------------------------------------------
	component sign_extender is
		generic(W: integer := 16);
		port( A:in std_logic_vector(W-1 downto 0);
				Y: out std_logic_vector(regWIDTH-1 downto 0)
		);
	end component;
	------datapath-----------------------------------------------
	component datapath is
		port (
			set_pc						:     in       std_logic;
			f_clk, clk 					:		in			std_logic;
			--reset	 		:		in			std_logic;
			pc_in							: 		in		 	std_logic_vector(31 downto 0);
			pc_out						: 		out		std_logic_vector(31 downto 0);
			--s_pcjump						: 		out		std_logic;--_vector(31 downto 0);
			s_mi							: 		out 		std_logic_vector(31 downto 0);
			--s_EregA, s_EregB        :     out      std_logic_vector(4 downto 0);
			s_regA, s_regB				:		out		std_logic_vector(31 downto 0);
			s_ULA							:		out		std_logic_vector(31 downto 0);
			s_pcBranchE             : 		out 		std_logic_vector(31 downto 0);
			--s_ULAWB						:     out 		std_logic_vector(31 downto 0);
			s_Zero						:		out		std_logic;
			s_MEM							:		out		std_logic_vector(31 downto 0);
			S_WDbreg							:		out		std_logic_vector(31 downto 0);
			S_WRbreg							:		out		std_logic_vector(4 downto 0);
			S_WDmem							:		out 		std_logic_vector(31 downto 0);
			S_WRmem							:		out		std_logic_vector(7 downto 0);
			--s_regW						:		out		std_logic
			--s_Imm32						:     out      std_logic_vector(31 downto 0)
			--s_Ulasrc						:     out 		std_logic
			s_controles : out std_logic_vector (11 downto 0)
		);
	end component;
	------ULA----------------------------------------------------
	component ULA is
		port(A: in std_logic_vector (regWIDTH-1 downto 0);B: in std_logic_vector (regWIDTH-1 downto 0);
			  OP: in std_logic_vector (functWIDTH-1 downto 0);Z: out std_logic_vector (regWIDTH-1 downto 0);
			  OVER, ZERO, VAI: out std_logic);
	end component;
	------breg---------------------------------------------------
	component breg is
		port(addA, addB, addW:in std_logic_vector(raddWIDTH-1 downto 0);saidaA: out std_logic_vector(regWIDTH-1 downto 0);
			  saidaB: out std_logic_vector(regWIDTH-1 downto 0);wdata: in  std_logic_vector(regWIDTH-1 downto 0);
			  writeEnable,CLK: in  std_logic);
	end component;
	------mi_rom-------------------------------------------------
	component mi_rom is
		port(address: in STD_LOGIC_VECTOR (pcaddWIDTH-1 downto 0);clock: in STD_LOGIC;
			  q: out STD_LOGIC_VECTOR (regWIDTH-1 downto 0));
	end component;
	------md_ram-------------------------------------------------
	component md_ram is
		port(address: in STD_LOGIC_VECTOR (pcaddWIDTH-1 downto 0);clock	: in STD_LOGIC ;
			  data	: in STD_LOGIC_VECTOR (regWIDTH-1 downto 0);wren	: in STD_LOGIC ;
			  q		: out STD_LOGIC_VECTOR (regWIDTH-1 downto 0));
	end component;
	---controle_unico-------------------------------------------
	component Controller is
		port( op,funct : in std_logic_vector(5 downto 0);
				RegDst	: out std_logic;
				ULAsrc	: out std_logic_vector(1 downto 0);
				MemToReg : out std_logic;
				RegWrite : out std_logic;
				--MemRead 	: out std_logic;
				MemWrite : out std_logic;
				Jump		: out std_logic;
				BranchEQ	: out std_logic;
				BranchNE : out std_logic;
				ULActrl	: out std_logic_vector (3 downto 0);
				s_controles : out std_logic_vector (11 downto 0)
			 );
	end component;
	------controle_principal-------------------------------------
	component controle_principal is
		 port (op        : in std_logic_vector(opWIDTH-1 downto 0);
				 memtoreg  : out std_logic;
				 memwrite  : out std_logic;
				 branch    : buffer std_logic;
				 alusrc    : out std_logic;
				 regdst    : out std_logic;
				 regwrite : out std_logic;
				 jump      : out std_logic;
				 aluop     : buffer std_logic_vector(1 downto 0));
	end component;
	------controle_ula-------------------------------------------
	component controle_ula is
		 port (funct      : in std_logic_vector(opWIDTH-1 downto 0); aluop: in std_logic_vector(1 downto 0);
				 alucontrol : out std_logic_vector(functWIDTH-1 downto 0));
	end component;
	------registradores pipeline---------------------------------
		------if/id-----------------------------------------------
	component pipeIF_ID is
		 generic(W : integer);
		 port (instruction : in std_logic_vector(W-1 downto 0);
				 pcplus4     : in std_logic_vector(W-1 downto 0);
				 clk         : in std_logic;
				 instr_out   : out std_logic_vector(W-1 downto 0);
				 pc_out      : out std_logic_vector(W-1 downto 0));
   end component;
		------id/ex-----------------------------------------------
	component pipeID_EX is
		generic(W : integer);
		port (clk 				: in std_logic;
				pc_4D 			: in std_logic_vector(31 downto 0);
				outAD 			: in std_logic_vector(31 downto 0);
				outBD, imm32D,shamt32D 	: in std_logic_vector(31 downto 0);
				riD            : in std_logic_vector(31 downto 0);
				rtD, rdD			: in std_logic_vector(4 downto 0);
				op					: in std_logic_vector(5 downto 0);
				funct				: in std_logic_vector(5 downto 0);
				regDstE 			: out std_logic;
				ulaSRCE			: out std_logic_vector(1 downto 0);
				memTOregE		: out std_logic;
				regWriteE		: out std_logic;
				--memReadE			: out std_logic;
				memWriteE		: out std_logic;
				BranchEQE		: out std_logic;
				BranchNEE		: out std_logic;
				JumpE				: out std_logic;
				ulaCTRLE			: out std_logic_vector(3 downto 0);
				pc_4E				: out std_logic_vector(31 downto 0);
				outAE, outBE	: out std_logic_vector(31 downto 0);
				imm32E			: out std_logic_vector(31 downto 0);
				rtE, rdE			: out std_logic_vector(4 downto 0);
				shamt32E       : out std_logic_vector(31 downto 0);
				riE            : out std_logic_vector(31 downto 0);
				s_controlesE : out std_logic_vector (11 downto 0)
				);
	end component;
		------ex/mem----------------------------------------------
	component pipeEX_MEM is
		 generic(W : integer);
		 port (clk           : in std_logic;
				 RegWriteE   : in std_logic;
				 MemtoRegE   : in std_logic;
				 MemWriteE   : in std_logic;
				 ZeroE         : in std_logic;
				 AluOutE       : in std_logic_vector(W-1 downto 0);
				 outBE		   : in std_logic_vector(W-1 downto 0);
				 WriteRegE     : in std_logic_vector(4 downto 0);
				 PcBranchE     : in std_logic_vector(W-1 downto 0);
				 BranchEQE			: in std_logic;
				 BranchNEE			: in std_logic;
				 RegWriteM   : out std_logic;
				 MemtoRegM   : out std_logic;
				 MemWriteM   : out std_logic;
				 ZeroM         : out std_logic;
				 AluOutM       : out std_logic_vector(W-1 downto 0);
				 WriteDataM    : out std_logic_vector(W-1 downto 0);
				 WriteRegM     : out std_logic_vector(4 downto 0);
				 PcBranchM     : out std_logic_vector(W-1 downto 0);
				 BranchEQM		: out std_logic;
				 BranchNEM		: out std_logic);
   end component;
		------mem/wb----------------------------------------------
	component pipeMEM_WB is
		generic(W : integer);
		port (clk           : in std_logic;
				 RegWriteM   	: in std_logic;
				 MemtoRegM   	: in std_logic;
				 ReadDataM     : in std_logic_vector(W-1 downto 0);
				 AluOutM       : in std_logic_vector(W-1 downto 0);
				 WriteRegM     : in std_logic_vector(4 downto 0);
				 RegWriteWB 	: out std_logic;
				 MemtoRegWB 	: out std_logic;
				 ReadDataWB   	: out std_logic_vector(W-1 downto 0);
				 AluOutWB     	: out std_logic_vector(W-1 downto 0);
				 WriteRegWB  	: out std_logic_vector(4 downto 0));
	end component;
end package;
--------------------------------------------------------------------