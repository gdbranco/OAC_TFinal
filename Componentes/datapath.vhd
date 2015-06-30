library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utilidades.all;

entity datapath is
	port (
		set_pc						:     in       std_logic;
		f_clk, clk					: in std_logic;
		--reset	 				:		in			std_logic;
		pc_in							: 		in		 	std_logic_vector(31 downto 0);
		pc_out						: 		out		std_logic_vector(31 downto 0);
		--s_pcjump						: 		out		std_logic;--_vector(31 downto 0);
		s_mi							: 		out 		std_logic_vector(31 downto 0);
		--s_EregA, s_EregB        :     out      std_logic_vector(4 downto 0);
		s_regA, s_regB				:		out		std_logic_vector(31 downto 0);
		s_ULA							:		out		std_logic_vector(31 downto 0);
		--s_pcbranchE             :     out 		std_logic_vector(31 downto 0);
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
end;

architecture comportamental of datapath is

signal s_controlesE 																																				 : std_logic_vector(11 downto 0);
signal s_set_pc 																				 																	 : std_logic;
signal pc 																						 																	 : std_logic_vector(31 downto 0) := (others => '0');
signal pc_jump, pc_4, pc_4D, pc_4E, pc_4M, pc_branchE, pc_branchM, pcE, pcM, pc_next														 : std_logic_vector(31 downto 0);
signal ri, imm32, imm32E, mem_outM, mem_outWB, shamt32, shamt32E 																					 : std_logic_vector(31 downto 0);
signal riD, riE 																																						    : std_logic_vector (31 downto 0);
signal op, funct 																																					 : std_logic_vector(5 downto 0);
signal rs, rt, rd, shamt, rtE, rdE, addWE, addWM, addWWB 																							 : std_logic_vector(4 downto 0);
signal k16 																																							 : std_logic_vector(15 downto 0);
signal entrada1																																					 : std_logic_vector(31 downto 0);
signal outAD, outAE, outBD, outBE, wdata, wdataE, wdataM, wdataWB, entrada2, ula_outE, ula_outM, ula_outWB 							 : std_logic_vector(31 downto 0);
signal ULActrl 																																					 : std_logic_vector (3 downto 0);
signal ULAsrc : std_logic_vector(1 downto 0);
signal RegDst, MemToReg, RegWrite, MemWrite, Jump, BranchEQE, BranchNEE, BranchEQM, BranchNEM, zeroE, zeroM, over, vai 			 : std_logic;
--signal MemRead 																																					 : std_logic;
signal mem_to_regE, mem_to_regM, mem_to_regWB, reg_writeE, reg_writeM, reg_writeWB 															 : std_logic;
signal mem_writeE, mem_writeM 																																 : std_logic;
signal pcSrc 																																						 : std_logic_vector (1 downto 0);
signal dBranch 																																					 : std_logic;

begin

-- ** IF ** --
	process(clk) begin
		if(rising_edge(clk)) then
			pc <= pc_next;
		end if;
	end process;
	
	pc_4 <= std_logic_vector(unsigned (pc) + 4);
	pc_next <=  pc_in when pcSrc = "00" else
					pc_jump when pcSrc = "01" else
					pc_branchM when pcSrc = "10" else
					pc_4;
					
	pc_out <= pc;
	pcSrc <= "00" when set_pc = '1' else
				"01" when jump = '1' else
				"10" when dBranch = '1' else
				"11";
				
	mi : mi_rom port map (pc(9 downto 2), f_clk, ri);
	pipeIF_ID0 : pipeIF_ID generic map(regWIDTH) port map (ri, pc_4, clk, riD, pc_4D);
	
	s_mi <= ri;
	
-- ** ID ** --
	op <= riD(31 downto 26);
	rs <= riD(25 downto 21);
	rt <= riD(20 downto 16);
	rd <= riD(15 downto 11);
	shamt <= riD(10 downto 6);
	funct <= riD(5 downto 0);
	k16   <= riD(15 downto 0);
	breg0	: breg port map(rs, rt, addWWB, outAD, outBD, wdataWB, reg_writeWB, clk);
	sgn0 	: sign_extender port map(k16,imm32);
	shamt32 <= "000000000000000000000000000" & shamt;
	
	--s_Imm32 <= imm32;
	
	pipeID_EX0 : pipeID_EX generic map(regWIDTH) port map(
					clk, pc_4D, outAD, outBD, imm32, shamt32, riD, rt, rd, op, funct,
					RegDst, ULAsrc, MemToReg, RegWrite, --MemRead,
					MemWrite, BranchEQE, BranchNEE, jump, ULActrl, pc_4E,
					outAE, outBE, imm32E, rtE, rdE, shamt32E, riE, s_controlesE);
	--s_pcjump <= jump;--pc_jump when (jump = '1');
	--s_EregA <= rs;
	--s_EregB <= rt;
	s_RegA <= outAD;
	s_RegB <= outBD;
	s_controles <= s_controlesE;
	
	-- ** EX ** -- 
	--s_Ulasrc <= ULAsrc;
	
	entrada1 <= shamt32E when (ulasrc(0) = '1') else
					outAE;
	
	entrada2 <=  imm32E when (ulasrc(1) = '1') else
			       outBE;
	
	--entrada2 <= outBE when (ulasrc = "00") else
	--				shamt32E when (ulasrc = "01") else
	--				imm32E;
					
	addWE 	<= rtE when RegDst = '0' else
					rdE;
					
	pc_branchE <= std_logic_vector(unsigned(pc_4E) + (unsigned (imm32E) sll 2));
	--s_pcbranchE <= pc_branchE;
	pc_jump	<=	pc_4E(31 downto 28) & riE(25 downto 0) & "00";
	ula0 : ULA port map(entrada1, entrada2, ULActrl ,ula_outE, over, zeroE, vai);

	pipeEX_MEM0 : pipeEX_MEM generic map(regWIDTH) port map(
		clk, RegWrite, MemToReg, MemWrite, zeroE,	
		ula_outE, outBE, addWE, pc_branchE, BranchEQE,	
		BranchNEE, reg_writeM, mem_to_regM, mem_writeM, zeroM, ula_outM, 
		wdataM, addWM, pc_branchM, BranchEQM, BranchNEM
		);	
	s_ULA 	<= ula_outE;
	s_Zero 	<= zeroE;
	
	-- ** MEM ** --
		dBranch <= ((BranchEQM and ZeroM) or (BranchNEM and not(ZeroM))); -- criar mux do pc junto com o jump
	
		md	:	md_ram port map (ula_outM(9 downto 2), f_clk, wdataM, mem_writeM, mem_outM);
	
		pipeMEM_WB0 : pipeMEM_WB generic map(regWIDTH) port map(
			clk,
			reg_writeM, mem_to_regM, mem_outM, ula_outM,
			addWM, reg_writeWB, mem_to_regWB, mem_outWB,
			ula_outWB, addWWB
			);
		s_MEM <= mem_outM;
		
	S_WDmem <= wDataM;
	S_WRmem <= ula_outM(9 downto 2);
		
	-- ** WB ** --
	--s_ULAWB     <= ula_outWB;
	wdataWB		<= ula_outWB when mem_to_regWB = '0' else 
						mem_outWB; 	
	S_WDbreg			<= wdataWB;
	S_WRbreg			<= addWWB;
	--s_RegW 		<= reg_writeWB;
end;
	

