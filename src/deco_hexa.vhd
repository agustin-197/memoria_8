library ieee;
use ieee.std_logic_1164.all;

entity deco_hexa is
    port (
        entrada : in  std_logic_vector(3 downto 0); -- Entrada de 4 bits
        salida : out std_logic_vector(6 downto 0) -- Salida de 7 bits
    );
end deco_hexa;

architecture arch of deco_hexa is
begin

    deco: process(entrada)
    begin

        case entrada is
            -- (g,f,e,d,c,b,a)
            when "0000" => salida <= "0111111"; -- 0
            when "0001" => salida <= "0000110"; -- 1
            when "0010" => salida <= "1011011"; -- 2
            when "0011" => salida <= "1001111"; -- 3
            when "0100" => salida <= "1100110"; -- 4
            when "0101" => salida <= "1101101"; -- 5
            when "0110" => salida <= "1111101"; -- 6
            when "0111" => salida <= "0000111"; -- 7
            when "1000" => salida <= "1111111"; -- 8
            when "1001" => salida <= "1101111"; -- 9
            when "1010" => salida <= "1110111"; -- A
            when "1011" => salida <= "1111100"; -- b
            when "1100" => salida <= "0111001"; -- C
            when "1101" => salida <= "1011110"; -- d
            when "1110" => salida <= "1111001"; -- E
            when "1111" => salida <= "1110001"; -- F

            when others => salida <= "0000000"; -- Apagado
        
        end case;
    end process;
    
end arch;