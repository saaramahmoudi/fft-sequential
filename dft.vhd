library ieee;
use ieee.std_logic_1164.all;
library work;
use work.fftpackage.all;


entity dft is
    generic (size : integer := SIZE /2);
    port (clk :in std_logic;
        input_array_real : in array_of_integer(size - 1 downto 0);
        input_array_imag : in array_of_integer(size-1 downto 0);
        output_real_array, output_imag_array : out array_of_integer(size - 1 downto 0)
    );
end entity dft;

architecture arch of dft is

    begin

        real_process : process( clk )
            variable prefix1, prefix2, degree, cos_value,sin_value, value: integer := 0;
            variable out_re : array_of_integer(size - 1 downto 0);
        begin
            if rising_edge(clk) then
                prefix1 := 360 / size;
                outer_loop : for k in 0 to size - 1 loop
                    out_re(k) := 0;
                    prefix2 := prefix1 * k;
                    inner_loop : for i in 0 to size - 1 loop
                        degree := prefix2 * i mod 360;
                        report " degree is " & integer'image(degree);
                        cos_value := cos_rom(degree);
                        sin_value := sin_rom(degree);
                        out_re(k) := out_re(k) + input_array_real(i) * cos_value + input_array_imag(i) * sin_value;
                        report " value is " & integer'image(value);
                    end loop inner_loop;
                end loop outer_loop;
            output_real_array <= out_re;
            end if;
        end process ; -- real_process

        imag_process : process( clk )
            variable prefix1, prefix2, degree,cos_value, sin_value, value: integer := 0;
        begin
            if rising_edge(clk) then
                prefix1 := 360 / size;
                outer_loop : for k in 0 to size - 1 loop
                    value := 0;
                    prefix2 := prefix1 * k;
                    inner_loop : for i in 0 to size - 1 loop
                        degree := prefix2 * i mod 360;
                        report " degree is " & integer'image(degree);
                        sin_value := sin_rom(degree);
                        cos_value := cos_rom(degree);
                        value := value - input_array_real(i) * sin_value + input_array_imag(i) * cos_value ;
                        report " value is " & integer'image(value);
                    end loop inner_loop;
                output_imag_array(k) <= value;
                end loop outer_loop;
            end if;
        end process ; -- imag_process
end architecture arch;