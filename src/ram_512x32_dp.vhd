library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity ram_512x32_dp is
    generic (
        constant init_file : string := ""
    );
    port (
        clk1     : in  std_logic; --puerto 1
        clk2    : in  std_logic; --puerto 2
        we      : in  std_logic; --habilita escritura
        addr1   : in  std_logic_vector(8 downto 0); --direccion 1
        addr2   : in  std_logic_vector(8 downto 0); --direccion 2
        din     : in  std_logic_vector(31 downto 0); --datos de entrada
        mask    : in  std_logic_vector(3 downto 0); --mascar de bytes
        dout    : out std_logic_vector(31 downto 0) --datos de salida
    );
end entity ram_512x32_dp;

architecture behavioral of ram_512x32_dp is
    type ram_type is array (511 downto 0) of std_logic_vector(31 downto 0);

    impure function init_ram return ram_type is
        file ram_file : text;
        variable ram_data : ram_type := (others => (others => '0'));
        variable line_content : line;
        variable addr1_index : integer := 0;
        variable valid : boolean;
        variable status : file_open_status;
    begin
        file_open(status, ram_file, init_file, read_mode);
        if status = open_ok then
            while not endfile(ram_file) loop
                readline(ram_file, line_content);
                hread(line_content, ram_data(addr1_index), valid);
                if valid then
                    addr1_index := addr1_index + 1;
                end if;
            end loop;
        end if;
        return ram_data;
    end function init_ram;

    signal ram : ram_type := init_ram;
begin

    --Puerto 1: ESCRITURA
    process(clk1)
    begin
        if rising_edge(clk1) then
            if we = '1' then
            
                --Logica de mascara de escritura por byte
                if mask(0) = '1' then
                    ram(to_integer(unsigned(addr1)))(7 downto 0) <= din(7 downto 0);
                end if ;

                if mask(1) = '1' then
                    ram(to_integer(unsigned(addr1)))(15 downto 8) <= din(15 downto 8);
                end if ;

                if mask(2) = '1' then
                    ram(to_integer(unsigned(addr1)))(23 downto 16) <= din(23 downto 16);                             
                end if ;

                if mask(3) = '1' then
                    ram(to_integer(unsigned(addr1)))(31 downto 24) <= din(31 downto 24);
                end if ;
                        
            end if;
        end if;
    end process;

    --Puerto 2: LECTURA
    process(clk2)
    begin
        if rising_edge(clk2) then
            dout <= ram(to_integer(unsigned(addr2)));
        end if;   
    end process;
end architecture behavioral;



    