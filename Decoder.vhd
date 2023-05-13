library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all; 

entity Decoder is
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
end Decoder;  

architecture Behavioral of Decoder is
begin
	process (Instruction(16 downto 13), Z, LT, EQ, OV, decode)
	begin
		if (decode = '1') then
			case Instruction(16 downto 13) is
				when "0001" => -- LD Reg, memory_address
					RegAddr1 <= Instruction(12 downto 10);
					RegAddr2 <= (others => '0');
					MemAddr  <= Instruction(9 downto 0);
					ALUOp    <= "000";
					Flag     <= '0';
				when "0010" => -- LD Reg1, Reg2
					RegAddr1 <= Instruction(12 downto 10);
					RegAddr2 <= Instruction(9 downto 7);
					MemAddr  <= (others => '0');
					ALUOp    <= "000";
					Flag     <= '0';
				when "0011" => -- LD Reg, PC
					RegAddr1 <= Instruction(12 downto 10);
					RegAddr2 <= (others => '0');
					MemAddr  <= Instruction(9 downto 0);
					ALUOp    <= "000";
					Flag     <= '0';
				when "0100" => -- LD PC, Reg
					RegAddr1 <= "000";
					MemAddr  <= Instruction(12 downto 3);
					RegAddr2 <= Instruction(2 downto 0);
					ALUOp    <= "000";
					Flag     <= '0';
				when "0101" => -- ADD Reg1, Reg2
					RegAddr1 <= Instruction(12 downto 10);
					RegAddr2 <= Instruction(9 downto 7);
					ALUOp    <= "001";
					Flag     <= '0';
				when "0110" => -- CMPE Reg1, Reg2
					RegAddr1 <= Instruction(12 downto 10);
					RegAddr2 <= Instruction(9 downto 7);
					ALUOp    <= "010";
					Flag     <= '0';
				when "0111" => -- CMPL Reg1, Reg2
					RegAddr1 <= Instruction(12 downto 10);
					RegAddr2 <= Instruction(9 downto 7);
					ALUOp    <= "011";
					Flag     <= '0';
				when "1000" => -- SHF Reg
					RegAddr1 <= Instruction(12 downto 10);
					RegAddr2 <= (others => '0');
					MemAddr  <= (others => '0');
					ALUOp    <= "100";
					Flag     <= '0';
				when "1001"         => -- BRZ address
					RegAddr1 <= (others => '0');
					RegAddr2 <= (others => '0');
					MemAddr  <= Instruction(12 downto 3);
					ALUOp    <= "000";
					Flag     <= Z;
				when "1010"         => -- BRE address
					RegAddr1 <= (others => '0');
					RegAddr2 <= (others => '0');
					MemAddr  <= Instruction(12 downto 3);
					ALUOp    <= "000";
					Flag     <= EQ;
				when "1011"         => -- BRL address
					RegAddr1 <= (others => '0');
					RegAddr2 <= (others => '0');
					MemAddr  <= Instruction(12 downto 3);
					ALUOp    <= "000";
					Flag     <= LT;
				when "1100"         => -- BROV address
					RegAddr1 <= (others => '0');
					RegAddr2 <= (others => '0');
					MemAddr  <= Instruction(12 downto 3);
					ALUOp    <= "000";
					Flag     <= OV;
				when "1101" => -- ST Reg, memory_address
					RegAddr1 <= Instruction(12 downto 10);
					RegAddr2 <= (others => '0');
					MemAddr  <= Instruction(9 downto 0);
					ALUOp    <= "000";
					Flag     <= '0';
				when others         =>
					RegAddr1 <= (others => '0');
					RegAddr2 <= (others => '0');
					MemAddr  <= (others => '0');
					ALUOp    <= "000";
					Flag     <= '0';
			end case;
		end if;
	end process;
end architecture Behavioral;