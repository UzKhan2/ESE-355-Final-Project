library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity DFF is
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
end DFF;

architecture Behavioral of DFF is
begin
	process (clk, reset)
	begin
		if reset = '1' then
			Q <= (others => '0');
		elsif rising_edge(clk) then
			Q <= D;
		end if;
	end process;
end Behavioral;