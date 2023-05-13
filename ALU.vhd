library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity ALU is
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
end ALU;

architecture Behavioral of ALU is
begin
	process (A, B, Operation, op)
		variable temp_result                       : std_logic_vector(7 downto 0);
		variable temp_OV, temp_Z, temp_EQ, temp_LT : std_logic;
	begin
		temp_OV := '0';
		temp_Z  := '0';
		temp_EQ := '0';
		temp_LT := '0';
		if (op = '1') then
			case Operation is
				when "000" => -- ADD
					temp_result := A + B;
					temp_OV     := A(7) and B(7) and not temp_result(7);
					if (temp_result = "00000000")then
						temp_Z      := '1'; 
					else temp_Z      := '0';
					end if;
				when "001" => -- CMPE
					temp_result := A;
					if (A = B) then
						temp_EQ     := '1'; 
					else temp_EQ     := 	'0';
					end if;
				when "010" => -- CMPL
					temp_result := A;
					if (A < B) then
						temp_LT     := '1';
					else temp_LT     := '0';
					end if;
				when "011" => -- SHF (Shift Left)
					temp_result := A(7 downto 1) & '0';
				when others            =>
					temp_result := (others => '0');
			end case;
		end if;

		Result <= temp_result;
		OV     <= temp_OV;
		Z      <= temp_Z;
		EQ     <= temp_EQ;
		LT     <= temp_LT;
	end process;
end Behavioral;