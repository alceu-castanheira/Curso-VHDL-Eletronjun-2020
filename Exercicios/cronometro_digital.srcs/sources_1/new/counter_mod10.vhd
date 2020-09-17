----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias 
-- 
-- Create Date: 15.09.2020 00:31:08
-- Design Name: cronometro_digital
-- Module Name: counter_mod10 - Behavioral
-- Project Name: Semana Universitária FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este módulo faz parte do projeto final do curso de Modelagem de circuitos digitais
-- da Semana Universitária FGA 2020: cronometro_digital. 
-- 
-- Este módulo implementa um contador de módulo 10, contando de 0 a 9 para exibir 
-- os dígitos do cronômetro.
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
entity counter_mod10 is
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
            
            -- Pino de entrada de enable: 1-bit
            -- Descrição: habilita o processo de contagem em '1' e pausa a mesma 
            -- em '0'.
            --
            enable : in STD_LOGIC;
            
            -- Pino de saída count_end: 1-bit
            -- Descrição: indica quando ocorre o fim da contagem.
            --
            count_end : out STD_LOGIC;
            
            -- Pino de saída count_out: 4-bits
            -- Descrição: saída que armazena o valor de contagem de 0 a 9.
            --
            count_out : out STD_LOGIC_VECTOR (3 downto 0));
end counter_mod10;

-- Seção Architecture: descrição de como funciona o módulo.
--
architecture Behavioral of counter_mod10 is

    -- Sinal s_count que armazena o valor de contagem para ser atribuído 
    -- à saída count_out: 4-bits.
    --
    signal s_count : std_logic_vector(3 downto 0) := (others => '0');
    
begin
    
    -- Processo de contagem de módulo 10: realiza contagem de 0 a 9 a 
    -- cada pulso de subida do clock, reiniciando o processo automaticamente.
    --
    COUNT_MOD10_PROC: process(clk,rst)
    begin
        
        -- Caso reset esteja ativo em '1', s_count reinicia.
        --
        if rst = '1' then
            s_count <= (others => '0');
        
        -- Caso contrário, na borda de subida do clock:
        --    
        elsif rising_edge(clk) then
            
            -- Se enable estiver habilitado em '1' e a contagem chegar
            -- no seu valor limite (9), reiniciar contagem e indicar
            -- que a mesma terminou.
            --
            if s_count = "1001" and enable = '1' then
                s_count <= (others => '0');
                count_end <= '1';
                
            -- Caso contrário, se enable estiver habilitado em '1',
            -- incrementar o contador em 1. Contagem não terminou ainda.
            --
            elsif enable = '1' then
                s_count <= std_logic_vector(unsigned(s_count) + 1);
                count_end <= '0';
                
            -- Por fim, se nenhuma condição for atendida, mantenha o valor
            -- atual de contagem e indicar que a contagem não terminou.
            else
                s_count <= s_count;
                count_end <= '0';  
            end if;
        end if;
    end process; 
    
    -- Saída count_out recebe o sinal s_count.
    count_out <= s_count;
    
end Behavioral;
