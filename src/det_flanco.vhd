library ieee;
use ieee.std_logic_1164.all;

entity det_flanco is
  port (
    clk     :in std_logic;--reloj
    entrada :in std_logic;--señal entrada
    pulso   :out std_logic--pulso salida
  ) ;
end det_flanco;

architecture arch of det_flanco is

signal entrada_antes:std_logic:='0';--almacena estado anterior

begin


registro_previo:process(clk)--guarda valor actual de entrada
begin
    if rising_edge(clk) then
        --guarda valor entrada para estar disponible en proximo ciclo
        entrada_antes <= entrada;
    end if;
    end process;

pulso <= (not entrada_antes) and entrada;

end arch ; -- arch