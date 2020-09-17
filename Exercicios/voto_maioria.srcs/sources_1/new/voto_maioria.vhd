-- Company: Universidade de Brasília
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 16.09.2020 22:31:15
-- Design Name: 
-- Module Name: voto_maioria - Behavioral
-- Project Name: Semana Universitária FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este módulo faz parte do primeiro exercício do curso de Modelagem de circuitos digitais
-- da Semana Universitária FGA 2020: voto_maioria. 
-- 
-- Este arquivo implementa um circuito de decisão pela maioria dos votos. Temos três
-- entradas, representando três votos (voto_1, voto_2, voto_3) de 1-bit cada. Quando
-- dois votos ou mais forem '1', a saída decisão de 1-bit vai para '1' também.
-- Caso contrário, permanece em '0'.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-- Seção Library: declarando as bibliotecas necessárias para o nosso módulo.
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Seção Entity: declarando as entradas e saídas do nosso módulo, bem como o tipo 
-- e a quantidade de bits de cada um.
--
entity voto_maioria is
    Port ( 
            -- Entradas
            --
            -- Entrada voto_1 de 1-bit.
            -- Descrição: indica voto positivo quando em '1' e negativo quando em '0'
            --
            voto_1 : in STD_LOGIC;

            -- Entrada voto_2 de 1-bit.
            -- Descrição: indica voto positivo quando em '1' e negativo quando em '0'
            --
            voto_2 : in STD_LOGIC;
            
            -- Entrada voto_3 de 1-bit.
            -- Descrição: indica voto positivo quando em '1' e negativo quando em '0'
            --            
            voto_3 : in STD_LOGIC;
            
            -- Saída decisao de 1-bit.
            -- Descrição: indica a decisão da maioria dos votos: se dois ou mais votos
            -- forem '1', a saída é '1'; se dois ou mais votos forem '0', a saída é '0'.
            --           
            decisao : out STD_LOGIC);
end voto_maioria;

-- Seção Architecture: descrição de como funciona o módulo.
--
architecture Behavioral of voto_maioria is

    -- Implementaremos aqui quatro versões diferentes da arquitetura do circuito: 
    -- 
    -- Versão 1: sem utilizar mapa de Karnaugh para simplificar a expressão
    -- Versão 2: sem utilizar mapa de Karnaugh para simplificar a expressão, mas
    -- utilizando sinais para ajudar a construir a expressão
    -- Versão 3: utilizando mapa de Karnaugh para simplificar a expressão
    -- Versão 4: utilizando mapa de Karnaugh para simplificar a expressão e sinais
    -- para ajudar a construir a expressão.
    --
    
    -- Os sinais abaixo são necessários para implementar as versões 2 e 4. Cada sinal
    -- armazena um produto da equação booleana da saída decisao.
    --
    -- Sinal 1 do tipo sdt_logic, 1-bit    
    --
    signal s_1: std_logic;
    
    -- Sinal 2 do tipo sdt_logic, 1-bit    
    --
    signal s_2: std_logic;
    
    -- Sinal 3 do tipo sdt_logic, 1-bit    
    --
    signal s_3: std_logic;
    
    -- Sinal 4 do tipo sdt_logic, 1-bit    
    --
    signal s_4: std_logic;
    
begin

    -- OBS: Lembrar que somente uma das versões pode estar descomentada por vez.
    -- Mais de uma linha escrevendo na mesma saída ou sinal causa conflitos.
    --
-----------------------------------------------------------------------------------

    -- Versão 1: sem utilizar mapa de Karnaugh para simplificar a expressão
    --                     _      _      _
    -- Expressão booleana: abc + abc + abc + abc, em que a = voto_1; b = voto_2
    -- e c = voto_3
    --
    
    -- Para utilizar essa versão descomentar as próximas 4 linhas:
    decisao <= ((not(voto_1) and voto_2) and voto_3) or 
               ((voto_1 and (not(voto_2))) and voto_3) or
               ((voto_1 and voto_2) and (not(voto_3))) or
               ((voto_1 and voto_2) and voto_3);

---------------------------------------------------------------------------------

    -- Versão 2: sem utilizar mapa de Karnaugh para simplificar a expressão, mas
    -- utilizando sinais para ajudar a construir a expressão:
    --                             _  
    -- Expressões booleanas: s_1 = abc
    --                              _
    --                       s_2 = abc
    --                               _
    --                       s_3 = abc
    --
    --                       s_4 = abc
    --
    --                       decisao = s_1 + s_2 + s_3 + s_4 em que a = voto_1;
    --                       b = voto_2 e c = voto_3
    --

    -- Para utilizar essa versão, descomentar as próximas 6 linhas
    -- s_1 <= ((not(voto_1) and voto_2) and voto_3);
    -- s_2 <= ((voto_1 and (not(voto_2))) and voto_3);
    -- s_3 <= ((voto_1 and voto_2) and (not(voto_3)));
    -- s_4 <= (voto_1 and voto_2) and voto_3;
      
--      decisao <= s_1 or s_2 or s_3 or s_4;    

----------------------------------------------------------------------------------    
    -- Versão 3: utilizando mapa de Karnaugh para simplificar a expressão
    -- Expressão booleana: ab + ac + bc, em que a = voto_1; b = voto_2 e c = voto_3
    --
    -- Para utilizar essa versão, descomentar a linha abaixo:
    -- decisao <= (voto_1 and voto_2) or (voto_1 and voto_3) or (voto_2 and voto_3);
    
-----------------------------------------------------------------------------------    
    -- Versão 4: utilizando mapa de Karnaugh para simplificar a expressão e sinais
    -- para ajudar a construir a expressão. 
    --
    -- Expressão booleana: s_1 = ab
    --                     s_2 = ac
    --                     s_3 = bc
    --                     decisao = s_1 + s_2 + s_3, em que a = voto_1; b = voto_2;
    --                     c = voto_3.
    --
    --    s_1 <= voto_1 and voto_2;
    --    s_2 <= voto_1 and voto_3;
    --    s_3 <= voto_2 and voto_3;
        
    --    decisao <= s_1 or s_2 or s_3;
    ------------------------------------------------------------------------------------    
                                 
end Behavioral;
