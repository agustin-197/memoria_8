library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.all;

entity top is
  port (

    clk     :in std_logic;
    botones :in std_logic_vector(7 downto 0);
    deco_out:out std_logic_vector(6 downto 0);
    punto   :out std_logic

        );
end top;

architecture arch of top is
    signal pulso_6  : std_logic;
    signal addr_sig : std_logic_vector(3 downto 0);
    signal addr     : std_logic_vector(3 downto 0);
    signal we       : std_logic;
    signal dout     : std_logic_vector(3 downto 0);
    signal deco_in  : std_logic_vector(3 downto 0);

    begin

    det_flanco_1: entity det_flanco
        port map(
            clk     => clk,
            entrada => botones(6),
            pulso   => pulso_6
        );

    det_flanco_2: entity det_flanco
        port map(
            clk     => clk,
            entrada => botones(5),
            pulso   => we
        );
    
    decodificador: entity deco_hexa
        port map(
            entrada => deco_in,
            salida  => deco_out
        );

    ram: entity ram_16x4
        port map(
            clk   => clk,
            we    => we,
            addr  => addr,
            din   => botones(3 downto 0),
            dout  => dout
        );
        addr_sig <= botones(3 downto 0) when pulso_6 = '1' else addr;
        deco_in <= addr when botones(7) = '1' else dout;
        punto <= botones(7);

        process(clk)
        begin
            if rising_edge(clk) then
                addr <= addr_sig;
            end if ;
        end process;
            
end arch; 