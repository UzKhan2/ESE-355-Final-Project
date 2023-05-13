library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity InstructionRegister is
	port
	(
		fetch : in  std_logic;
		clk   : in  std_logic;
		reset : in  std_logic;
		D     : in  std_logic_vector (16 downto 0);
		Q     : out std_logic_vector (16 downto 0)
	);
end InstructionRegister;

architecture Behavioral of InstructionRegister is
begin
	process (clk, reset, fetch)
	begin
		if reset = '1' then
			Q <= (others => '0');
		elsif rising_edge(clk) and fetch = '1' then
			Q <= D;
		end if;
	end process;
end Behavioral;