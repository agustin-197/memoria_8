library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.all;
use std.env.finish;

entity reg_32x32_tb is
end reg_32x32_tb;

architecture tb of reg_32x32_tb is
    --señales para el puerto de escritura
    signal clk    : std_logic;
    signal we     : std_logic;
    signal addr_w : std_logic_vector(4 downto 0);
    signal din    : std_logic_vector(31 downto 0);

    --señales para el puerto de lectura 1
    signal addr1  : std_logic_vector(4 downto 0);
    signal dout1  : std_logic_vector(31 downto 0); 
    
    --señales para el puerto de lectura 2
    signal addr2  : std_logic_vector(4 downto 0);
    signal dout2  : std_logic_vector(31 downto 0); 

    constant periodo : time := 10 ns;
    begin

    dut: entity reg_32x32
      generic map(
        init_file => "../src/reg_32x32_tb_contenido.txt"
      )
      port map(
      --puertos escritura
      clk => clk,
      we => we,
      addr_w => addr_w,
      din => din,
      --puertos lectura 1
      addr1 => addr1,
      dout1 => dout1,
      --puertos lectura 2
      addr2 => addr2,
      dout2 => dout2
      );

    reloj :process
    begin
      clk <= '0';
      wait for periodo/2;
      clk <= '1';
      wait for periodo/2;
    end process;

    estimulo_y_evaluacion : process
    begin
    
    --Estado inicial
    we <= '0';
    addr_w <= (others => '0');
    addr1  <= (others => '0');
    addr2  <= (others => '0');
    din    <= (others => '0');
    wait for periodo;

    --PRUEBA 1: Lectura de valores iniciales
    report "Prueba 1: Leyendo valores iniciales" severity note;
    addr1 <= "00001";
    addr2 <= "00010";

    wait for periodo/4;

    assert dout1 = x"AAAAAAAA"
      report "Valor inicial (addr 1) distinto al esperado (AAAAAAAA)" severity error;
    assert dout2 = x"BBBBBBBB"
      report "Valor inicial (addr 2) distinto al esperado (BBBBBBBB)";

    --PRUEBA 2: Escritura
    report "Prueba 2: Escribiendo 1111CAFE en addr 5" severity note;
    addr_w <="00101";
    we <= '1';
    din <= x"1111CAFE";
    
    wait until rising_edge(clk);
    wait until rising_edge(clk);

    we <= '0';
    wait for periodo/4;

    --PRUEBA 3: verificacion de la escritura
    report "Prueba 3: Verificando la escritura en addr 5" severity note; 
    addr1 <= "00101";
    wait for periodo/4;

    assert dout1 = x"1111CAFE";
    report "Valor leido (addr 5) es distinto al que se escribio (1111CAFE)" severity error;
    
    --PRUEBA 4: prueba de we=0 (escritura deshabilitada)
    report "Prueba 4: Intentando escribir en addr 5 con we=0" severity note;
    addr_w <= "00101";
    din <= x"FFFFFFFF";
    we <= '0';

    wait until rising_edge(clk);
    wait for periodo/4;

    assert dout1 = x"1111CAFE"
      report "El valor cambio aunque we=0. La escritura no se deshabilitó" severity error;
    
    --PRUEBA 5: operacion de 3 puertos 
    report "Prueba 5: Escribiendi en addr 7, leyendo de 1 y 2" severity note;
    addr_w <= "00111";
    din <= x"CAFECAFE";
    we <= '1';

    addr1 <= "00001";
    addr2 <= "00010";

    wait for periodo/4;
   
    assert dout1 = x"AAAAAAAA" 
    report "Fallo en la lectura (puerto 1)" severity error;
    assert dout2 = x"BBBBBBBB" 
    report "Fallo en la lectura (puerto 2)" severity error;

    wait until rising_edge(clk);
    we <= '0';
    wait for periodo/4;

    --verifico que la escritura se realizo
    addr1 <= "00111";
    wait for periodo/4;
    assert dout1 = x"CAFECAFE" report "No se escribio el valor de la prueba 5" severity error;

    --Fin del test
    report "Testbench de reg_32x32 completado exitosamente." severity note;
    
    finish;
    end process;

end architecture tb;

  

    

