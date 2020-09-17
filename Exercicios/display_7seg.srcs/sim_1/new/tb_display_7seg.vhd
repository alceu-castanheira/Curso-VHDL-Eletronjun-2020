----------------------------------------------------------------------------------
-- Company: Universidade de Bras�lia
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 17.09.2020 00:22:32
-- Design Name: 
-- Module Name: tb_display_7seg - Behavioral
-- Project Name: Semana Universit�ria FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este m�dulo faz parte do segundo exerc�cio do curso de Modelagem de circuitos digitais
-- da Semana Universit�ria FGA 2020: exibir um n�mero no display de 7 segmentos. 
-- 
-- Este arquivo implementa um testbench que permite verificar o funcionamento do 
-- circuito display_7seg por meio de uma simula��o comportamental.
--
-- Dependencies: 
--
-- display_7seg.vhd
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
entity tb_display_7seg is
end tb_display_7seg;

-- Se��o Architecture: descri��o do teste comportamental.
--
architecture Behavioral of tb_display_7seg is

    -- Instanciando o componente display_7seg
    --
    component display_7seg is
        Port(
                data_in : in STD_LOGIC_VECTOR(3 DOWNTO 0);
                an : out STD_LOGIC_VECTOR(3 DOWNTO 0);
                seg : out STD_LOGIC_VECTOR(6 DOWNTO 0));
    end component;
    
    -- Sinais de teste do componente:
    --
    -- Sinal de teste s_data_in de 4-bits
    signal s_data_in : std_logic_vector(3 downto 0) := (others => '0');
    
    -- Sinal de teste s_an de 4-bits
    signal s_an : std_logic_vector(3 downto 0) := (others => '0');
    
    -- Sinal de teste s_seg de 7-bits
    signal s_seg : std_logic_vector(6 downto 0) := (others => '0');
    
begin

    -- Realizando as conex�es entre sinais de teste e suas respectivas entradas/sa�das.
    --
    uut: display_7seg port map
    (
        data_in => s_data_in,
        an => s_an,
        seg => s_seg
    );
    
    -- Criando est�mulos de teste para a entrada data_in: receber valores de 0 a 15 a
    -- cada 10 ns
    s_data_in <= "0000",
                 "0001" after 10 ns,
                 "0010" after 20 ns,
                 "0011" after 30 ns,
                 "0100" after 40 ns,
                 "0101" after 50 ns,
                 "0110" after 60 ns,
                 "0111" after 70 ns,
                 "1000" after 80 ns,
                 "1001" after 90 ns,
                 "1010" after 100 ns,
                 "1011" after 110 ns,
                 "1100" after 120 ns,
                 "1101" after 130 ns,
                 "1110" after 140 ns,
                 "1111" after 150 ns;
                 
end Behavioral;
