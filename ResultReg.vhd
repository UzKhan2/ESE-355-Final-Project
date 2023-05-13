library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

entity ResultReg is
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
end ResultReg;

architecture reg of ResultReg is
begin
	process (clk, reset)
	begin
		if reset = '1' then
			data_out  <= (others => '0');
			reg_store <= (others => '0');
		elsif rising_edge(clk) then
			data_out  <= data_to_be_stored;
			reg_store <= reg_addr;
		end if;
	end process;
end reg;