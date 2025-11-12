library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity reg_32x32 is
  generic(
    constant init_file : string :=""
  );

    port(
        --Puerto de escritura
        clk     :in std_logic;
        we      :in std_logic;
        addr_w  :in std_logic_vector(4 downto 0); --5 bits para 32 registros
        din     :in std_logic_vector(31 downto 0);

        --Puerto de lectura 1
        addr1  :in std_logic_vector(4 downto 0);
        dout1  :out std_logic_vector(31 downto 0);

        --Puerto de lectura 2
        addr2  :in std_logic_vector(4 downto 0);
        dout2  :out std_logic_vector(31 downto 0)

        );
end reg_32x32;

architecture behavioral of reg_32x32 is
    type reg_type is array (31 downto 0) of std_logic_vector(31 downto 0);
    
 ----------------------------------------------   
   impure function init_reg return reg_type is
        file reg_file : text;
        variable reg_data : reg_type := (others => (others => '0'));
        variable line_content : line;
        variable addr_index : integer := 0;
        variable valid : boolean;
        variable status : file_open_status;
    begin
        file_open(status, reg_file, init_file, read_mode);
        if status = open_ok then
            while not endfile(reg_file) loop
                readline(reg_file, line_content);
                hread(line_content, reg_data(addr_index), valid);
                if valid then
                    addr_index := addr_index + 1;
                end if;
            end loop;
        end if;
        return reg_data;
    end function init_reg;
    ---------------------------------------------------------------------- 
    
    signal registros : reg_type := init_reg; --señal para los registros
    
    --señales para las direcciones
    signal r_addr_w   : integer range 0 to 31;
    signal r_addr1    : integer range 0 to 31;
    signal r_addr2    : integer range 0 to 31;
    begin
    
    --conversion de direcciones
    r_addr_w <= to_integer(unsigned(addr_w));
    r_addr1  <= to_integer(unsigned(addr1));
    r_addr2  <= to_integer(unsigned(addr2));

    --logica de escritura
    process(clk)
    begin

      if rising_edge(clk) then
        if we = '1' then
          registros(r_addr_w) <= din;
        end if ;
      end if ;
    end process;

    --logica de Lectura 1
    dout1 <= registros(r_addr1);

    --logica de Lectura 2
    dout2 <= registros(r_addr2);

end behavioral;