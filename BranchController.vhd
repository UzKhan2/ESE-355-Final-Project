library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity BranchController is
	port
	(
		op          : in  std_logic;
		Flag        : in  std_logic;
		branch_addr : in  std_logic_vector(9 downto 0);
		PCAddr      : in  std_logic_vector(9 downto 0);
		next_addr   : out std_logic_vector(9 downto 0)
	);
end BranchController;

architecture controller of BranchController is
begin
	process (Flag, op)
	begin
		if (op = '1') then
			if (Flag = '1') then
				next_addr <= branch_addr;
			else
				next_addr <= (PCAddr + 1);
			end if;
		end if;
	end process;
end controller;