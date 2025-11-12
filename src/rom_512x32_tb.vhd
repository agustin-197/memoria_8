library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;
use work.all;

entity rom_512x32_tb is
end entity rom_512x32_tb;

architecture tb of rom_512x32_tb is

   signal clk : std_logic;
   signal addr: std_logic_vector(8 downto 0);
   signal dout: std_logic_vector(31 downto 0);
   constant periodo : time:= 10 ns;
begin

    dut: entity rom_512x32
        generic map(
            init_file => "../src/rom_512x32_tb_contenido.txt"
        )
        port map(
            clk => clk,
            addr => addr,
            dout => dout
        );

        reloj : process
        begin
            clk <= '0';
            wait for periodo/2;
            clk <= '1';
            wait for periodo/2;
        end process;

        estimulo_y_evaluacion : process
        begin

        --Estado inicial
        addr <= (others => '0');
        wait until rising_edge(clk);

        --PRUEBA 1: leer direccion 0
        report "Prueba 1: Leyendo direccion 0" severity note;
        addr <= "000000000";
        wait until rising_edge(clk);
        
        wait until rising_edge(clk);
        assert dout = x"CAFE0001"
            report "Dato en addr 0 (CAFE0001) no coincide" severity error;

        --PRUEBA 2: leer la direccion 3
        report "Prueba 2: Leyendo direccion 3" severity note;
        addr <= "000000011";
        wait until rising_edge(clk);

        wait until rising_edge(clk);
        assert dout = x"1111CAFE"
            report "Dato en addr 3 (1111CAFE) no coincide" severity error;

        --PRUEBA 3: Leer direccion no inicializada
        report "Prueba 3: Leyendo direccion 100" severity note;
        addr <= "001100100";
        wait until rising_edge(clk);
        
        wait until rising_edge(clk);
        assert dout = x"00000000"
            report "Dato en addr 100 (00000000) no coincide" severity error;

        --Fin del test
        report "Testbench de rom512x32 completado exitosamente." severity note;

        finish;
        
        end process;

end tb ;