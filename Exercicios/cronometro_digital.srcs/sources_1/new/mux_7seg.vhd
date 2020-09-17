----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 16.09.2020 16:23:23
-- Design Name: cronometro_digital
-- Module Name: mux_7seg - Behavioral
-- Project Name: Semana Universitária FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este módulo faz parte do projeto final do curso de Modelagem de circuitos digitais
-- da Semana Universitária FGA 2020: cronometro_digital. 
-- 
-- Este módulo recebe os digitos que serão exibidos nos displays de 7 segmentos da 
-- Basys 3, converte os mesmos para serem exibidos adequadamente nos displays. 
--
-- Há ainda processos que controlam os anodos, ou seja, habilitam e desabilitam os
-- displays, um por vez, para garantir que números diferentes sejam exibidos nos
-- displays do cronômetro, por meio da técnica de multiplexação de displays
--
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-- Seção Library: declarando as bibliotecas necessárias para o nosso módulo. Notar 
-- que NUMERIC_STD é necessária para realizar operações aritméticas
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Seção Entity: declarando as entradas e saídas do nosso módulo, bem como o tipo 
-- e a quantidade de bits de cada um.
--
entity mux_7seg is
    Port ( 
            -- Entradas:
            
            -- Pino de entrada do sinal de clk: 1-bit.
            -- Descrição: dita a frequência de operação do módulo.
            --
            clk : in STD_LOGIC;
            
            -- Pino de entrada de reset: 1-bit
            -- Descrição: reseta o sistema, fazendo com os sinais e saídas voltem
            -- a seus valores iniciais.
            --
            rst : in STD_LOGIC;
            
            -- Pino de entrada referente ao primeiro dígito: 4-bits
            -- Descrição: Primeiro dígito do cronômetro a ser exibido no display
            -- mais à direita (unidade dos décimos de segundo)
            --
            digit_1 : in STD_LOGIC_VECTOR (3 downto 0);
            
            -- Pino de entrada referente ao segundo dígito: 4-bits
            -- Descrição: Segundo dígito do cronômetro a ser exibido no segundo 
            -- display mais à direita (dezena dos décimos de segundo)
            --            
            digit_2 : in STD_LOGIC_VECTOR (3 downto 0);
            
            -- Pino de entrada referente ao primeiro dígito: 4-bits
            -- Descrição: Terceiro dígito do cronômetro a ser exibido no terceiro 
            -- display mais à direita (unidade dos segundos)
            --            
            digit_3 : in STD_LOGIC_VECTOR (3 downto 0);

            -- Pino de entrada referente ao primeiro dígito: 4-bits
            -- Descrição: Quarto dígito do cronômetro a ser exibido no display
            -- mais à esquerda (dezena dos segundos)
            --            
            digit_4 : in STD_LOGIC_VECTOR (3 downto 0);
            
            -- Saídas:
            
            -- Pino de saída referente aos anôdos dos displays de 7 segmentos da
            -- Basys 3: 4-bits
            -- Descrição: Cada bit dessa saída corresponde ao anôdo de um display
            -- da Basys 3: o bit menos significativo controla o anôdo do display
            -- mais à direita no kit e o bit mais significativo controla o anôdo
            -- mais à esquerda dno kit. Os anôdos habilitam seu respectivo display
            -- em '0', e desabilitam o mesmo em '1'.
            --
            an : out STD_LOGIC_VECTOR (3 downto 0);
            
            -- Pino de saída referente aos 7 segmentos dos displays da Basys 3: 7-bits
            -- Descrição: Cada bit dessa saída corresponde a um dos 7 segmentos dos
            -- displays da Basys 3 na ordem 'gfedcba'. Os segmentos são ligados em
            -- '0' e desligados em '1'.
            -- 
            seg : out STD_LOGIC_VECTOR (6 downto 0));
end mux_7seg;

-- Seção Architecture: descrição de como funciona o módulo.
--
architecture Behavioral of mux_7seg is

    -- Sinal s_count: armazena o valor de um contador de 2-bits que será usado para
    -- controlar qual o dígito a ser exibido e qual display deve ser habilitado.
    --
    signal s_count: std_logic_vector(1 downto 0) := (others => '0');
    
    -- Sinal s_display_1: armazena o valor dos segmentos que formam o número a ser
    -- exibido no primeiro display (mais à direita): 7-bits.
    --
    signal s_digit_1 : std_logic_vector(6 downto 0) := (others => '0');

    -- Sinal s_display_2: armazena o valor dos segmentos que formam o número a ser
    -- exibido no segundo display (segundo mais à direita): 7-bits.
    --    
    signal s_digit_2 : std_logic_vector(6 downto 0) := (others => '0');
    
    -- Sinal s_display_3: armazena o valor dos segmentos que formam o número a ser
    -- exibido no terceiro display (terceiro mais à direita): 7-bits.
    --    
    signal s_digit_3 : std_logic_vector(6 downto 0) := (others => '0');

    -- Sinal s_display_4: armazena o valor dos segmentos que formam o número a ser
    -- exibido no quarto display (mais à esquerda): 7-bits.
    --    
    signal s_digit_4 : std_logic_vector(6 downto 0) := (others => '0');
    
    -- Sinal s_an: sinal que armazena o valor a ser atribuido à saída an, que 
    -- controla quais os anôdos ativos e inativos a cada instante: 4-bits.
    --
    signal s_an : std_logic_vector(3 downto 0) := (others => '0');
    
    -- Sinal s_seg: sinal que armazena o valor a ser tribuído à saída seg, que
    -- controla quais os segentos dos displays ativos e inativos a cada instante:
    -- 7-bits.
    signal s_seg : std_logic_vector(6 downto 0) := (others => '0');
    
begin

    -- Processo que controla os segmentos para exibir o primeiro dígito.
    -- Lista de sensibilidade: digit_1.
    DIGIT_1_DISPLAY: process(digit_1)
    begin
    
        -- De acordo com o valor de digit_1, o sinal s_digit_1 recebe o
        -- valor adequado para exibir este dígito no primeiro display.
        -- Padrão: gfedcba
        -- 
        case digit_1 is
            when "0000" => s_digit_1 <= "1000000"; -- 0
            when "0001" => s_digit_1 <= "1111001"; -- 1
            when "0010" => s_digit_1 <= "0100100"; -- 2
            when "0011" => s_digit_1 <= "0110000"; -- 3
            when "0100" => s_digit_1 <= "0011001"; -- 4
            when "0101" => s_digit_1 <= "0010010"; -- 5
            when "0110" => s_digit_1 <= "0000010"; -- 6
            when "0111" => s_digit_1 <= "1111000"; -- 7
            when "1000" => s_digit_1 <= "0000000"; -- 8
            when "1001" => s_digit_1 <= "0011000"; -- 9
            
            -- Com 4 bits, é possível representar números até 15. Para
            -- o cronômetro não é necessário, mas caso quisessemos 
            -- representar os números de 10 a 15 em hexadecimal, poderiamos
            -- usar o trecho comentado abaixo.
--            when "1010" => s_digit_1 <= "0001000";
--            when "1011" => s_digit_1 <= "0000011";
--            when "1100" => s_digit_1 <= "1000110";
--            when "1101" => s_digit_1 <= "0100001";
--            when "1110" => s_digit_1 <= "0000110";
--            when "1111" => s_digit_1 <= "0001110";

            when others => s_digit_1 <= "1111111";
        end case;
    end process DIGIT_1_DISPLAY;

    DIGIT_2_DISPLAY: process(digit_2)
    begin
    
        -- De acordo com o valor de digit_2, o sinal s_digit_2 recebe o
        -- valor adequado para exibir este dígito no segundo display.
        -- Padrão: gfedcba 
        --    
        case digit_2 is       
            when "0000" => s_digit_2 <= "1000000"; -- 0
            when "0001" => s_digit_2 <= "1111001"; -- 1
            when "0010" => s_digit_2 <= "0100100"; -- 2
            when "0011" => s_digit_2 <= "0110000"; -- 3
            when "0100" => s_digit_2 <= "0011001"; -- 4
            when "0101" => s_digit_2 <= "0010010"; -- 5
            when "0110" => s_digit_2 <= "0000010"; -- 6
            when "0111" => s_digit_2 <= "1111000"; -- 7
            when "1000" => s_digit_2 <= "0000000"; -- 8
            when "1001" => s_digit_2 <= "0011000"; -- 9
            
            -- Com 4 bits, é possível representar números até 15. Para
            -- o cronômetro não é necessário, mas caso quisessemos 
            -- representar os números de 10 a 15 em hexadecimal, poderiamos
            -- usar o trecho comentado abaixo.            
--            when "1010" => s_digit_2 <= "0001000";
--            when "1011" => s_digit_2 <= "0000011";
--            when "1100" => s_digit_2 <= "1000110";
--            when "1101" => s_digit_2 <= "0100001";
--            when "1110" => s_digit_2 <= "0000110";
--            when "1111" => s_digit_2 <= "0001110";

            when others => s_digit_2 <= "1111111";
        end case;
    end process DIGIT_2_DISPLAY;
    
    DIGIT_3_DISPLAY: process(digit_3)
    begin
        
        -- De acordo com o valor de digit_3, o sinal s_digit_3 recebe o
        -- valor adequado para exibir este dígito no terceiro display.
        -- Padrão: gfedcba
        --     
        case digit_3 is      
            when "0000" => s_digit_3 <= "1000000";
            when "0001" => s_digit_3 <= "1111001";
            when "0010" => s_digit_3 <= "0100100";
            when "0011" => s_digit_3 <= "0110000";
            when "0100" => s_digit_3 <= "0011001";
            when "0101" => s_digit_3 <= "0010010";
            when "0110" => s_digit_3 <= "0000010";
            when "0111" => s_digit_3 <= "1111000";
            when "1000" => s_digit_3 <= "0000000";
            when "1001" => s_digit_3 <= "0011000";
            
            -- Com 4 bits, é possível representar números até 15. Para
            -- o cronômetro não é necessário, mas caso quisessemos 
            -- representar os números de 10 a 15 em hexadecimal, poderiamos
            -- usar o trecho comentado abaixo.            
--            when "1010" => s_digit_3 <= "0001000";
--            when "1011" => s_digit_3 <= "0000011";
--            when "1100" => s_digit_3 <= "1000110";
--            when "1101" => s_digit_3 <= "0100001";
--            when "1110" => s_digit_3 <= "0000110";
--            when "1111" => s_digit_3 <= "0001110";

            when others => s_digit_3 <= "1111111";
        end case;
    end process DIGIT_3_DISPLAY;
    
    DIGIT_4_DISPLAY: process(digit_4)
    begin
    
        -- De acordo com o valor de digit_4, o sinal s_digit_4 recebe o
        -- valor adequado para exibir este dígito no quarto display.
        -- Padrão: gfedcba
        --     
        case digit_4 is
            when "0000" => s_digit_4 <= "1000000";
            when "0001" => s_digit_4 <= "1111001";
            when "0010" => s_digit_4 <= "0100100";
            when "0011" => s_digit_4 <= "0110000";
            when "0100" => s_digit_4 <= "0011001";
            when "0101" => s_digit_4 <= "0010010";
            when "0110" => s_digit_4 <= "0000010";
            when "0111" => s_digit_4 <= "1111000";
            when "1000" => s_digit_4 <= "0000000";
            when "1001" => s_digit_4 <= "0011000";
            
            -- Com 4 bits, é possível representar números até 15. Para
            -- o cronômetro não é necessário, mas caso quisessemos 
            -- representar os números de 10 a 15 em hexadecimal, poderiamos
            -- usar o trecho comentado abaixo.
--            when "1010" => s_digit_4 <= "0001000";
--            when "1011" => s_digit_4 <= "0000011";
--            when "1100" => s_digit_4 <= "1000110";
--            when "1101" => s_digit_4 <= "0100001";
--            when "1110" => s_digit_4 <= "0000110";
--            when "1111" => s_digit_4 <= "0001110";

            when others => s_digit_4 <= "1111111";
        end case;
    end process DIGIT_4_DISPLAY;
    
    -- Processo que controla a multiplexação dos displays: um contador de
    -- 2-bits. Cada valor de contagem é usado posteriormente para controlar
    -- 's_an' e 's_seg'.
    -- Lista de sensibilidade: clk, rst
    --
    MULTIPLEX_CONTROL : process(clk,rst)
    begin
    
        -- Caso o reset esteja ativo em '1', s_count retorna ao valor inicial.
        --
        if rst = '1' then
            s_count <= (others => '0');
        
        -- Caso contrário, na borda de subida do clock, s_count é incrementado
        -- em 1.
        --
        elsif rising_edge(clk) then
            s_count <= std_logic_vector(unsigned(s_count) + 1);
        end if;
    end process MULTIPLEX_CONTROL;             
    
    -- Processo de multiplexação de displays. De acordo com o valor de s_count no processo
    -- acima, os sinais 's_an' e 's_seg' recebem os valores adequados para exibir o
    -- dígito correto no display apropriado:
    --
    -- s_count = "00" => habilitar o primeiro display (s_an <= "1110") e exibir o digito 1
    -- (s_seg <= s_digit_1)  
    -- s_count = "01" => habilitar o segundo display (s_an <= "1101") e exibir o digito 2
    -- (s_seg <= s_digit_2) 
    -- s_count = "10" => habilitar o terceiro display (s_an <= "1011") e exibir o digito 3
    -- (s_seg <= s_digit_3) 
    -- s_count = "11" => habilitar o quarto display (s_an <= "0111") e exibir o digito 4
    -- (s_seg <= s_digit_4) 
    -- 
    DISPLAY_MULTIPLEX: process(s_count, s_digit_1, s_digit_2, s_digit_3, s_digit_4)
    begin
        case s_count is
            when "00" => 
                s_an  <= "1110";
                s_seg <= s_digit_1;
            when "01" => 
                s_an  <= "1101";
                s_seg <= s_digit_2;
            when "10" => 
                s_an  <= "1011";
                s_seg <= s_digit_3;
            when "11" => 
                s_an  <= "0111";
                s_seg <= s_digit_4;
                
            -- Em caso de erro ou comportamento inesperado, desabilite anôdos e os segmentos.    
            when others => 
                s_an  <= (others => '1'); 
                s_seg <= (others => '1');
        end case;
    end process DISPLAY_MULTIPLEX;
    
    -- Saídas an e seg recebm seus respectivos sinais.
    an <= s_an;
    seg <= s_seg;
    
end Behavioral;
