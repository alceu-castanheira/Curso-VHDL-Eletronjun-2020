-- Company: Universidade de Bras�lia
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 16.09.2020 22:31:15
-- Design Name: 
-- Module Name: voto_maioria - Behavioral
-- Project Name: Semana Universit�ria FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este m�dulo faz parte do primeiro exerc�cio do curso de Modelagem de circuitos digitais
-- da Semana Universit�ria FGA 2020: voto_maioria. 
-- 
-- Este arquivo implementa um circuito de decis�o pela maioria dos votos. Temos tr�s
-- entradas, representando tr�s votos (voto_1, voto_2, voto_3) de 1-bit cada. Quando
-- dois votos ou mais forem '1', a sa�da decis�o de 1-bit vai para '1' tamb�m.
-- Caso contr�rio, permanece em '0'.
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
entity voto_maioria is
    Port ( 
            -- Entradas
            --
            -- Entrada voto_1 de 1-bit.
            -- Descri��o: indica voto positivo quando em '1' e negativo quando em '0'
            --
            voto_1 : in STD_LOGIC;

            -- Entrada voto_2 de 1-bit.
            -- Descri��o: indica voto positivo quando em '1' e negativo quando em '0'
            --
            voto_2 : in STD_LOGIC;
            
            -- Entrada voto_3 de 1-bit.
            -- Descri��o: indica voto positivo quando em '1' e negativo quando em '0'
            --            
            voto_3 : in STD_LOGIC;
            
            -- Sa�da decisao de 1-bit.
            -- Descri��o: indica a decis�o da maioria dos votos: se dois ou mais votos
            -- forem '1', a sa�da � '1'; se dois ou mais votos forem '0', a sa�da � '0'.
            --           
            decisao : out STD_LOGIC);
end voto_maioria;

-- Se��o Architecture: descri��o de como funciona o m�dulo.
--
architecture Behavioral of voto_maioria is

    -- Implementaremos aqui quatro vers�es diferentes da arquitetura do circuito: 
    -- 
    -- Vers�o 1: sem utilizar mapa de Karnaugh para simplificar a express�o
    -- Vers�o 2: sem utilizar mapa de Karnaugh para simplificar a express�o, mas
    -- utilizando sinais para ajudar a construir a express�o
    -- Vers�o 3: utilizando mapa de Karnaugh para simplificar a express�o
    -- Vers�o 4: utilizando mapa de Karnaugh para simplificar a express�o e sinais
    -- para ajudar a construir a express�o.
    --
    
    -- Os sinais abaixo s�o necess�rios para implementar as vers�es 2 e 4. Cada sinal
    -- armazena um produto da equa��o booleana da sa�da decisao.
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

    -- OBS: Lembrar que somente uma das vers�es pode estar descomentada por vez.
    -- Mais de uma linha escrevendo na mesma sa�da ou sinal causa conflitos.
    --
-----------------------------------------------------------------------------------

    -- Vers�o 1: sem utilizar mapa de Karnaugh para simplificar a express�o
    --                     _      _      _
    -- Express�o booleana: abc + abc + abc + abc, em que a = voto_1; b = voto_2
    -- e c = voto_3
    --
    
    -- Para utilizar essa vers�o descomentar as pr�ximas 4 linhas:
    decisao <= ((not(voto_1) and voto_2) and voto_3) or 
               ((voto_1 and (not(voto_2))) and voto_3) or
               ((voto_1 and voto_2) and (not(voto_3))) or
               ((voto_1 and voto_2) and voto_3);

---------------------------------------------------------------------------------

    -- Vers�o 2: sem utilizar mapa de Karnaugh para simplificar a express�o, mas
    -- utilizando sinais para ajudar a construir a express�o:
    --                             _  
    -- Express�es booleanas: s_1 = abc
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

    -- Para utilizar essa vers�o, descomentar as pr�ximas 6 linhas
    -- s_1 <= ((not(voto_1) and voto_2) and voto_3);
    -- s_2 <= ((voto_1 and (not(voto_2))) and voto_3);
    -- s_3 <= ((voto_1 and voto_2) and (not(voto_3)));
    -- s_4 <= (voto_1 and voto_2) and voto_3;
      
--      decisao <= s_1 or s_2 or s_3 or s_4;    

----------------------------------------------------------------------------------    
    -- Vers�o 3: utilizando mapa de Karnaugh para simplificar a express�o
    -- Express�o booleana: ab + ac + bc, em que a = voto_1; b = voto_2 e c = voto_3
    --
    -- Para utilizar essa vers�o, descomentar a linha abaixo:
    -- decisao <= (voto_1 and voto_2) or (voto_1 and voto_3) or (voto_2 and voto_3);
    
-----------------------------------------------------------------------------------    
    -- Vers�o 4: utilizando mapa de Karnaugh para simplificar a express�o e sinais
    -- para ajudar a construir a express�o. 
    --
    -- Express�o booleana: s_1 = ab
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
