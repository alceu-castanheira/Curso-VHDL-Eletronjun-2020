----------------------------------------------------------------------------------
-- Company: Universidade de Bras�lia
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 16.09.2020 23:16:52
-- Design Name: 
-- Module Name: tb_voto_maioria - Behavioral
-- Project Name: Semana Universit�ria FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este m�dulo faz parte do primeiro exerc�cio do curso de Modelagem de circuitos digitais
-- da Semana Universit�ria FGA 2020: voto_maioria. 
-- 
-- Este arquivo implementa um testbench que permite verificar o funcionamento do 
-- circuito voto_maioria por meio de uma simula��o comportamental.
--
-- Dependencies: 
--
-- voto_maioria.vhd
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
-- e a quantidade de bits de cada um. Para testbenches, a entidade geralmente � vazia.
--
entity tb_voto_maioria is
end tb_voto_maioria;

-- Se��o Architecture: descri��o do teste comportamental.
--
architecture Behavioral of tb_voto_maioria is

    -- Instancia��o do componente voto_maioria para teste
    --
    component voto_maioria is
        Port (
            voto_1 : in std_logic;
            voto_2 : in std_logic;
            voto_3 : in std_logic;
            decisao : out std_logic);
    end component voto_maioria;

    -- Sinal de teste s_voto_1, inicializando com '0'.
    signal s_voto_1 : std_logic := '0';
    
    -- Sinal de teste s_voto_2, inicializando com '0'.
    signal s_voto_2 : std_logic := '0';
    
    -- Sinal de teste s_voto_3, inicializando com '0'.
    signal s_voto_3 : std_logic := '0';
    
    -- Sinal de teste s_decisao, inicializando com '0'.
    signal s_decisao : std_logic := '0';
    
begin

    -- Realizando a conex�o dos sinais de teste �s suas entradas e sa�das
    -- respectivas
    uut: voto_maioria port map
    (
        voto_1 => s_voto_1,
        voto_2 => s_voto_2,
        voto_3 => s_voto_3,
        decisao => s_decisao
    );
    
    -- A se��o ap�s a conex�o dos sinais de teste corresponde aos est�mulos, ou seja,
    -- fazer com que os sinais de teste assumam determinados valores durante a 
    -- simula��o comportamental. Associamos valores de teste �s entradas e verificamos
    -- nas sa�das o comportamento do circuito.
    --
    -- Os est�mulos abaixo buscam emular a tabela-verdade de um circuito combinacional
    -- de 3 entradas:
    --
    -- Est�mulo do sinal s_voto_1: atribuir um novo valor a cada 10 ns
    s_voto_1 <= '0', '0' after 10 ns, '0' after 20 ns, '0' after 30 ns, 
                '1' after 40 ns, '1' after 50 ns, '1' after 60 ns, '1' after 70 ns; 
                
    -- Est�mulo do sinal s_voto_2: atribuit um novo valor a cada 10 ns
    s_voto_2 <= '0', '0' after 10 ns, '1' after 20 ns, '1' after 30 ns, 
                '0' after 40 ns, '0' after 50 ns, '1' after 60 ns, '1' after 70 ns; 
    -- Est�mulo do sinal s_voto_3: atribuir um novo valor a cada 10 ns
    s_voto_3 <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns, 
                '0' after 40 ns, '1' after 50 ns, '0' after 60 ns, '1' after 70 ns; 
                    
end Behavioral;
