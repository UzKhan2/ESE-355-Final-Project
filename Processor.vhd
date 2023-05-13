library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Processor is
	port
	(
		clk   : in std_logic;
		reset : in std_logic
	);
end Processor;

architecture Behavioral of Processor is
	component Decoder
		port
		(
			decode      : in  std_logic;
			Instruction : in  std_logic_vector(16 downto 0);
			Z           : in  std_logic;
			EQ          : in  std_logic;
			LT          : in  std_logic;
			OV          : in  std_logic;
			RegAddr1    : out std_logic_vector(2 downto 0);
			RegAddr2    : out std_logic_vector(2 downto 0);
			MemAddr     : out std_logic_vector(9 downto 0);
			ALUOp       : out std_logic_vector(2 downto 0);
			Flag        : out std_logic
		);
	end component;

	component brancher
		port
		(
			Flag        : in  std_logic;
			branch_addr : in  std_logic_vector(9 downto 0);
			PCAddr      : in  std_logic_vector(9 downto 0);
			next_addr   : out std_logic_vector(9 downto 0)
		);
	end component;

	component ALU
		port
		(
			op        : in  std_logic;
			A         : in  std_logic_vector(7 downto 0);
			B         : in  std_logic_vector(7 downto 0);
			Operation : in  std_logic_vector(2 downto 0);
			Result    : out std_logic_vector(7 downto 0);
			OV        : out std_logic;
			Z         : out std_logic;
			EQ        : out std_logic;
			LT        : out std_logic
		);
	end component;

	component InstructionMemory
		port
		(
			clk  : in  std_logic;
			addr : in  std_logic_vector (9 downto 0);
			inst : out std_logic_vector (15 downto 0));
	end component;

	component DataMemory
		port
		(
			clk      : in  std_logic;
			addr     : in  std_logic_vector (9 downto 0);
			data_in  : in  std_logic_vector (7 downto 0);
			data_out : out std_logic_vector (7 downto 0);
			wr       : in  std_logic);
	end component;

	component DFF
		generic
		(
			n : integer
		);
		port
		(
			clk   : in  std_logic;
			reset : in  std_logic;
			D     : in  std_logic_vector (n downto 0);
			Q     : out std_logic_vector (n downto 0)
		);
	end component;

	component BranchController
		port
		(
			op          : in  std_logic;
			Flag        : in  std_logic;
			branch_addr : in  std_logic_vector(9 downto 0);
			PCAddr      : in  std_logic_vector(9 downto 0);
			next_addr   : out std_logic_vector(9 downto 0)
		);
	end component;

	component FSM
		port
		(
			clk       : in  std_logic;
			reset     : in  std_logic;
			fetch     : out std_logic;
			decode    : out std_logic;
			execute   : out std_logic;
			writeBack : out std_logic
		);
	end component;

	component PSR
		port
		(
			clk     : in  std_logic;
			reset   : in  std_logic;
			OV_curr : out std_logic;
			Z_curr  : out std_logic;
			EQ_curr : out std_logic;
			LT_curr : out std_logic;
			OV_next : in  std_logic;
			Z_next  : in  std_logic;
			EQ_next : in  std_logic;
			LT_next : in  std_logic
		);
	end component;

	component ResultReg
		port
		(
			op                : in  std_logic;
			clk               : in  std_logic;
			reset             : in  std_logic;
			data_to_be_stored : in  std_logic_vector(7 downto 0);
			reg_addr          : in  std_logic_vector (2 downto 0);
			data_out          : out std_logic_vector (7 downto 0);
			reg_store         : out std_logic_vector (2 downto 0)
		);
	end component;

	component InstructionRegister
		port
		(
			fetch : in  std_logic;
			clk   : in  std_logic;
			reset : in  std_logic;
			D     : in  std_logic_vector (16 downto 0);
			Q     : out std_logic_vector (16 downto 0)
		);
	end component;

	component RegisterFile is
		port
		(
			clk          : in  std_logic;
			RegA_addr    : in  std_logic_vector(2 downto 0);
			RegB_addr    : in  std_logic_vector(2 downto 0);
			Write_enable : in  std_logic;
			Write_addr   : in  std_logic_vector(2 downto 0);
			Write_data   : in  std_logic_vector(7 downto 0);
			RegA_data    : out std_logic_vector(7 downto 0);
			RegB_data    : out std_logic_vector(7 downto 0)
		);
	end component;

	-- Signals
	signal 
		RegAData, 		 ---register 1 for instruction 
		RegBData,        ---register 1 for instruction   
		Result_ALU,      ---result of ALU to be sent to Result Register  
		rfile_data :     ---data that will be sent to register file  
	std_logic_vector(7 downto 0);

	signal 
		currInput, 		  ---current Instruction 
		nextInput :       ---next Instruction 
	std_logic_vector(16 downto 0);

	signal 
		PCAddr_in, 		  ---current PC
		PCAddr_out,       ---next PC 
		memAddr,          ---memory Address for store and loads 
		WIR_addr :        ---address stored in WIR 
	std_logic_vector(9 downto 0);

	signal 
		currBranchFlag,              		---branch flag relevant for current BRANCH instruction 
		ov_out, z_out, lt_out, eq_out,      ---flags for current cycle 																		  	
		ov_in, z_in, lt_in, eq_in,          ---flags for next cycle 
		fetch, decode, execute, writeBack : ---FSM stages allowing every component to run only during the correct stage
	std_logic;

	signal 
		ALUOp,      		---stores operation for ALU 
		Decoded_output_reg, ---keeps track of which register we will store ALU operation in	 
		rfile_addr,         ---register file address 																		   	
		Decoded_RegA,       ---register A from decoded instruction 								   
		Decoded_RegB :      ---register B from decoded instruction 
	std_logic_vector(2 downto 0);

begin

	-- Component Instantiation	  	
	Dec : Decoder
	port map
	(
		decode      => decode,
		Instruction => currInput,
		Z           => z_out,
		EQ          => eq_out,
		LT          => lt_out,
		OV          => ov_out,
		RegAddr1    => Decoded_RegA,
		RegAddr2    => Decoded_RegB,
		MemAddr     => memAddr,
		ALUOp       => ALUOp,
		Flag        => currBranchFlag
	);

	PC : DFF
	generic map (n => 9)
	port map (
		clk   => clk,
		reset => reset,
		d     => PCAddr_in,
		q     => PCAddr_out
	);

	WIR : DFF
	generic map (n => 9)
	port map (
		clk   => clk,
		reset => reset,
		d     => WIR_addr,
		q     => WIR_addr
	);

	BR : BranchController
	port map (
		op          => execute,
		Flag        => currBranchFlag,
		branch_addr => memAddr,
		PCAddr      => PCAddr_out,
		next_addr   => WIR_addr
	);

	ALU_comp : ALU
	port map (
		op        => execute,
		A         => RegAData,
		B         => RegBData,
		Operation => ALUOp,
		Result    => Result_ALU,
		OV        => ov_in,
		Z         => z_in,
		EQ        => eq_in,
		LT        => lt_in
	);

	PSR_comp : PSR
	port map (
		clk     => clk,
		reset   => reset,
		OV_curr => ov_out,
		Z_curr  => z_out,
		EQ_curr => eq_out,
		LT_curr => lt_out,
		OV_next => ov_in,
		Z_next  => z_in,
		EQ_next => eq_in,
		LT_next => lt_in
	);

	Result : ResultReg
	port map(
		op                => writeBack,
		clk               => clk,
		reset             => reset,
		data_to_be_stored => Result_ALU,
		reg_addr          => Decoded_output_reg,
		data_out          => rfile_data,
		reg_store         => rfile_addr
	);

	RFILE : RegisterFile
	port map (
		clk          => clk,
		RegA_addr    => Decoded_RegA,
		RegB_addr    => Decoded_RegB,
		Write_enable => writeBack,
		Write_addr   => rfile_addr,
		Write_data   => rfile_data,
		RegA_data    => RegAData,
		RegB_data    => RegBData
	);

	IR : InstructionRegister
	port map (
		clk   => clk,
		reset => reset,
		fetch => fetch,
		d     => nextInput,
		q     => currInput
	);

	States : FSM
	port map(
		clk       => clk,
		reset     => reset,
		fetch     => fetch,
		decode    => decode,
		execute   => execute,
		writeBack => writeBack
	);

end Behavioral;