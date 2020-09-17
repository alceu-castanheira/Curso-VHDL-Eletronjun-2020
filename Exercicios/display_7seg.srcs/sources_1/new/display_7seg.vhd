----------------------------------------------------------------------------------
-- Company: Universidade de Bras�lia 
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 17.09.2020 00:08:41
-- Design Name: 
-- Module Name: display_7seg - Behavioral
-- Project Name: Semana Universit�ria FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este m�dulo faz parte do segundo exerc�cio do curso de Modelagem de circuitos digitais
-- da Semana Universit�ria FGA 2020: exibir um n�mero no display de 7 segmentos. 
-- 
-- Este arquivo implementa um circuito que recebe um n�mero de 0 a 15 pela entrada 'data_in'
-- e exibe o mesmo em formato hexadecimal em um �nico display de 7 segmentos da Basys 3. 
--
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-- Se��o Library: declarando as bibliotecas necess�rias para o nosso m�dulo.
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Se��o Entity: declarando as entradas e sa�das do nosso m�dulo, bem como o tipo 
-- e a quantidade de bits de cada um.
--
entity display_7seg is
    Port ( 
            -- Entrada
            --
            -- Entrada data_in de 4-bits
            -- Descri��o: recebe um n�mero de 0 a 15 para ser exibido em um dos
            -- displays de 7 segmentos da Basys 3.
            --
            data_in : in STD_LOGIC_VECTOR (3 downto 0);
            
            -- Sa�das
            --
            -- Sa�da an de 4-bits.
            -- Descri��o: Cada bit dessa sa�da corresponde ao an�do de um display
            -- da Basys 3: o bit menos significativo controla o an�do do display
            -- mais � direita no kit e o bit mais significativo controla o an�do
            -- mais � esquerda dno kit. Os an�dos habilitam seu respectivo display
            -- em '0', e desabilitam o mesmo em '1'.
            --
            an : out STD_LOGIC_VECTOR (3 downto 0);
            
            -- Pino de sa�da referente aos 7 segmentos dos displays da Basys 3: 7-bits
            -- Descri��o: Cada bit dessa sa�da corresponde a um dos 7 segmentos dos
            -- displays da Basys 3 na ordem 'gfedcba'. Os segmentos s�o ligados em
            -- '0' e desligados em '1'.
            --            
            seg : out STD_LOGIC_VECTOR (6 downto 0));
end display_7seg;

-- Se��o Architecture: descri��o de como funciona o m�dulo.
--
architecture Behavioral of display_7seg is

    -- Sinal que armazena o valor de cada segmento do display que exibir� o n�mero
    --
    signal s_seg: std_logic_vector(6 downto 0) := (others => '0');
    
begin

    -- Processo que controla os segmentos para exibir o n�mero no display da Basys3.
    -- Lista de sensibilidade: digit_1.
    EXIBIR_NUM_DISPLAY: process(data_in)
    begin
    
        -- De acordo com o valor de data_in, o sinal s_seg recebe o
        -- valor adequado para exibir este n�mero no primeiro display.
        -- Padr�o: gfedcba
        -- 
        case data_in is
            when "0000" => s_seg <= "1000000"; -- 0
            when "0001" => s_seg <= "1111001"; -- 1
            when "0010" => s_seg <= "0100100"; -- 2
            when "0011" => s_seg <= "0110000"; -- 3
            when "0100" => s_seg <= "0011001"; -- 4
            when "0101" => s_seg <= "0010010"; -- 5
            when "0110" => s_seg <= "0000010"; -- 6
            when "0111" => s_seg <= "1111000"; -- 7
            when "1000" => s_seg <= "0000000"; -- 8
            when "1001" => s_seg <= "0011000"; -- 9
            when "1010" => s_seg <= "0001000"; -- a
            when "1011" => s_seg <= "0000011"; -- b
            when "1100" => s_seg <= "1000110"; -- c
            when "1101" => s_seg <= "0100001"; -- d
            when "1110" => s_seg <= "0000110"; -- e
            when "1111" => s_seg <= "0001110"; -- f

            -- Caso aconte�a alguma outra condi��o indesjada, apagar todos
            -- os segmentos do display.
            --
            when others => s_seg <= "1111111";
        end case;
    end process EXIBIR_NUM_DISPLAY;
    
    -- Manter somente o primeiro display habilitado (an�do do primeiro display em '0'),
    -- desbailitando os demais (an�dos dos demais displays em '1').
    an <= "1110";
    
    -- Atribuindo o sinal s_seg � sa�da seg
    seg <= s_seg;
        
end Behavioral;
