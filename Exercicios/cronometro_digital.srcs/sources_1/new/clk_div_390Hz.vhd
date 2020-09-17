----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 16.09.2020 16:46:11
-- Design Name: cronometro_digital
-- Module Name: clk_div_390Hz - Behavioral
-- Project Name: Semana Universitária FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este módulo faz parte do projeto final do curso de Modelagem de circuitos digitais
-- da Semana Universitária FGA 2020: cronometro_digital. 
-- 
-- Este módulo implementa um divisor de clock de 100 MHz (clock da Basys 3) para 390 Hz. 
--
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
entity clk_div_390Hz is
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
            
            -- Pino de saída do clock de 390Hz: 1-bit
            -- Descrição: Saída com o sinal de clock com frequência dividida para
            -- 390 Hz, que será usado para a multiplexação dos displays do
            -- cronômetro.
            --
            clk_390Hz : out STD_LOGIC);
end clk_div_390Hz;

-- Seção Architecture: descrição de como funciona o módulo.
--
architecture Behavioral of clk_div_390Hz is

    -- Constante de preset: valor máximo de contagem para divisor de clock. Esse
    -- valor é calculado da seguinte forma:
    --
    -- preset = 0.5*(período de clk desejado)/(período de clk padrão) 
    -- 
    -- Para 390 Hz e clock padrão de 100 MHz: preset ~= (256410)/2 = 128205
    -- Dividimos por 2 porque durante o período o sinal de clock deve mudar 2 vezes:
    -- indo de '0' para '1' e indo de '1' para '0' (ou vice-versa).
    --
    constant C_PRESET : std_logic_vector(16 downto 0) := "11111010011001101";
    
    -- Sinal s_count que armazena a contagem: 17-bits.
    signal s_count : std_logic_vector (16 downto 0) := (others => '0');
    
    -- Sinal que armazena o clock dividido: 1-bit.
    signal s_div_clk : std_logic := '0';
    
begin

    -- Processo de geração de clock dividido com frequência de 390 Hz
    -- Lista de sensibilidade: clk, rst
    --
    CLK_390HZ_GEN: process(clk, rst)
    begin
        
        -- Caso reset esteja ativo em '1', s_count e s_div_clk
        -- retornam para os valores iniciais.
        if rst = '1' then
            s_count   <= (others => '0');
            s_div_clk <= '0';
            
        -- Caso contrário, na borda de subida do clock:
        elsif rising_edge(clk) then
        
            -- Se s_count chegar ao valor de preset, reinicie a contagem
            -- e s_div_clk inverte seu valor (vai de '0' para '1' ou de 
            -- '1' para '0').
            --
            if s_count = C_PRESET then
                s_count   <= (others => '0');
                s_div_clk <= not s_div_clk; 
            
            -- Caso contrário, s_count é incrementado em 1.    
            else
                s_count <= std_logic_vector(unsigned(s_count) + 1);
            end if;
        end if;
    end process;

    -- Saída clk_10Hz recebe s_div_clk.
    clk_390Hz <= s_div_clk;
    
end Behavioral;
