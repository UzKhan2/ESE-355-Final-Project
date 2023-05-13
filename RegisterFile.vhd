library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity RegisterFile is
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
end RegisterFile;

architecture Behavioral of RegisterFile is
	type RegisterArray is array (0 to 7) of std_logic_vector(7 downto 0);
	signal RegFile : RegisterArray := (others => (others => '0'));
begin
	process (clk)
	begin
		if rising_edge(clk) then
			if Write_enable = '1' then
				RegFile(to_integer(unsigned(Write_addr))) <= Write_data;
			end if;
		end if;
	end process;

	RegA_data <= RegFile(to_integer(unsigned(RegA_addr)));
	RegB_data <= RegFile(to_integer(unsigned(RegB_addr)));
end Behavioral;