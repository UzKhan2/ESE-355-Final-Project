library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity FSM is
	port
	(
		clk       : in  std_logic;
		reset     : in  std_logic;
		fetch     : out std_logic;
		decode    : out std_logic;
		execute   : out std_logic;
		writeBack : out std_logic
	);
end FSM;

architecture Behavioral of FSM is
	signal currentState, nextState : std_logic_vector(1 downto 0);
begin

	process (clk, reset)
	begin
		if reset = '1' then
			currentState <= "00"; -- reset to Fetch state
		elsif rising_edge(clk) then
			currentState <= nextState;
		end if;
	end process;

	process (currentState)
	begin
		case currentState is
			when "00" => -- Fetch state	
				fetch     <= '1';
				decode    <= '0';
				execute   <= '0';
				writeBack <= '0';
				nextState <= "01";
			when "01" => -- Decode state 
				fetch     <= '0';
				decode    <= '1';
				execute   <= '0';
				writeBack <= '0';
				nextState <= "10";
			when "10" => -- Execute state 
				fetch     <= '0';
				decode    <= '0';
				execute   <= '1';
				writeBack <= '0';
				nextState <= "11";
			when "11" => -- Writeback state
				fetch     <= '0';
				decode    <= '0';
				execute   <= '0';
				writeBack <= '1';
				nextState <= "00";
			when others =>
				fetch     <= '0';
				decode    <= '0';
				execute   <= '0';
				writeBack <= '0';
				nextState <= currentState;
		end case;
	end process;
end Behavioral;