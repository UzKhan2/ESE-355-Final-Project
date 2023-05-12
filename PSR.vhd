library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity PSR is
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
end PSR;

architecture Behavioral of PSR is
begin
	process (clk, reset)
	begin
		if reset = '1' then
			OV_curr <= '0';
			Z_curr  <= '0';
			EQ_curr <= '0';
			LT_curr <= '0';
		elsif rising_edge(clk) then
			OV_curr <= OV_next;
			Z_curr  <= Z_next;
			EQ_curr <= EQ_next;
			LT_curr <= LT_next;
		end if;
	end process;
end Behavioral;
