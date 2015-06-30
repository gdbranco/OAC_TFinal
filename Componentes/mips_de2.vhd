library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_signed.all;
use work.utilidades.all;

entity mips_de2 is
	port (
			f_clk		   : in std_logic;
			clk 			: in std_logic;			
			set_pc 		: in std_logic;
			--reset			: in std_logic;
			init_pc		: in std_logic_vector(7 downto 0);
			sel_out 		: in std_logic_vector(3 downto 0);
			hexas 		: out std_logic_vector(55 downto 0);
			led_zero		: out std_logic;
			led_clk	   : out std_logic;
			controles	: out std_logic_vector(11 downto 0)
			);
end;

architecture comportamental of mips_de2 is

		signal s_init_pc					:				std_logic_vector(31 downto 0);
		signal s_regA, s_regB			:				std_logic_vector(31 downto 0);
		signal s_ULA						:				std_logic_vector(31 downto 0);
		signal s_Zero						:				std_logic;
		signal s_MEM						:				std_logic_vector(31 downto 0);
		signal s_WDBreg					:				std_logic_vector(31 downto 0);
		signal s_WRBreg					:				std_logic_vector(4 downto 0);
		signal s_PC							:				std_logic_vector(31 downto 0);
		signal s_MI							:				std_logic_vector(31 downto 0);
		signal s_hexas 					: 				std_logic_vector(55 downto 0);
		signal s_display					:				std_logic_vector(31 downto 0);
		signal s_controles				:				std_logic_vector(11 downto 0);
		signal s_WDmem						:           std_logic_vector(31 downto 0);
		signal s_WRmem 					:				std_logic_vector(7 downto 0);
		signal s_pcbranchE            :           std_logic_vector(31 downto 0);
begin
	mips : datapath port map(set_pc, f_clk, clk, --reset,
	s_init_pc, s_PC, s_MI, s_regA, s_regB, s_Ula,s_pcbranchE, s_Zero, s_MEM, s_WDBreg, s_WRBreg,s_WDmem,s_WRmem,s_Controles);
	
	led_clk  <= clk;
	led_zero <= s_Zero;
	
	s_init_pc <= std_logic_vector(to_unsigned(0, 22)) &  init_pc & "00";
	
	s_display <= s_pc 	 when sel_out = "0000" else 
					 s_mi 	 when sel_out = "0001" else 
					 s_regA	 when sel_out = "0010" else 
					 s_regB	 when sel_out = "0011" else 
					 s_ULA	 when sel_out = "0100" else 
					 s_MEM	 when sel_out = "0101" else 
					 s_WDBreg when sel_out = "0110" else 
					 std_logic_vector(to_unsigned(0, 27)) & s_WRBreg when sel_out = "0111" else
					 s_WDmem  when sel_out = "1000" else
					 std_logic_vector(to_unsigned(0, 24)) & s_WRmem when (sel_out = "1001") else
					 s_pcbranchE;
					 
	controles <= s_controles;
	hex0 : hex_conv port map (s_display(3 downto 0), s_hexas(6 downto 0));
	hex1 : hex_conv port map (s_display(7 downto 4), s_hexas(13 downto 7));
	hex2 : hex_conv port map (s_display(11 downto 8), s_hexas(20 downto 14));
	hex3 : hex_conv port map (s_display(15 downto 12), s_hexas(27 downto 21));
	hex4 : hex_conv port map (s_display(19 downto 16), s_hexas(34 downto 28));
	hex5 : hex_conv port map (s_display(23 downto 20), s_hexas(41 downto 35));
	hex6 : hex_conv port map (s_display(27 downto 24), s_hexas(48 downto 42));
	hex7 : hex_conv port map (s_display(31 downto 28), s_hexas(55 downto 49));
	
	hexas <= s_hexas;
	
	
end;