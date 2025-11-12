library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;
use work.all;

entity ram_512x32_dp_tb is
end ram_512x32_dp_tb;

architecture tb of ram_512x32_dp_tb is
    signal clk     : std_logic;
    signal we      : std_logic;
    signal addr1   : std_logic_vector(8 downto 0);
    signal addr2   : std_logic_vector(8 downto 0);
    signal din     : std_logic_vector(31 downto 0);
    signal dout    : std_logic_vector(31 downto 0);
    signal mask    : std_logic_vector(3 downto 0);

    constant periodo :time := 10 ns;
begin
    
    dut : entity ram_512x32_dp generic map (
        init_file => "../src/ram_512x32_dp_tb_contenido.txt"
    ) port map(
        clk1 => clk,
        clk2 => clk,
        we => we,
        addr1 => addr1,
        addr2 => addr2,
        din => din,
        dout => dout,
        mask => mask
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
        --estado inicial
        we <= '0';
        mask <= (others => '0');
        addr1 <= (others => '0');
        addr2 <= (others => '0');
        din <= (others => '0');
        wait for periodo;

        --PRUEBA 1(lectura de valor inicial)
        report "Prueba 1: Leyendo valor inicial de addr 8" severity note;
        addr2 <= "000001000"-, --addr8
        wait until rising_edge(clk);

        wait until rising_edge(clk);

        assert dout = x"12345678"
        report "Valor inicial (addr 8) distinto al esperado" severity error;

        --PRUEBA 2 (escritura completa y lectura simultanea)
        report "Prueba 2: Escribiendo 'AAAAAAAA' en addr 9, leyendo de addr 8" severity note;
        we <= '1';
        mask <= "1111";
        addr1 <= "000001001";
        din <= x"AAAAAAAA";

        --leer addr 8
        addr2 <= "000001000";
        wait until rising_edge(clk);

        --mostrar valor de addr 8
        assert dout = x"12345678"
            report "Lectura de addr 8 fallo durante escritura en addr 9" severity error;

        --PRUEBA 3 (lectura del valor recien escrito)
        report "Prueba 3: Verificando escritura en addr 9" severity note;

        --detener escritura
        we <= '0';
        mask <= "0000";

        --mover puerto de lectura a addr 9
        assert dout = x"AAAAAAAA"
            report "Valor leido (addr 9) es distinto al que se escribió" severity error;

        --PRUEBA 4: escritura con mascara
        report "Prueba 4: Escribiendo 'BBBBDDDD' en addr 9 con mascara '1100'";
        we <= '1';
        mask <= "1100";
        addr1 <= "000001001";
        din <= x"BBBBDDDD";

        wait until rising_edge(clk);

        --PRUEBA 5: verificacion de mascara
        report "Prueba 5: verificando escritura con mascara en addr 9" severity note;

        --detener escritura
        we <= '0';
        addr2 <= "000001001";

        wait until rising_edge(clk);

        assert dout = x"BBBBAAAA"
            report "Valor leido (addr 9) tras escritura con mascara es incorrecto" severity error;

            --fin testbench
            report "Testbench de ram_512x32_dp completado exitosamente" severity note;

        finish;
    end process;

end tb ; -- tb