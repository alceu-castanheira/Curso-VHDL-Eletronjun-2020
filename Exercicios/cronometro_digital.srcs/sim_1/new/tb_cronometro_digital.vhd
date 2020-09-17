----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 15.09.2020 00:45:56
-- Design Name: cronometro_digital
-- Module Name: tb_cronometro_digital - Behavioral
-- Project Name: Semana Universitária FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este módulo faz parte do projeto final do curso de Modelagem de circuitos digitais
-- da Semana Universitária FGA 2020: cronometro_digital. 
-- 
-- Este arquivo implementa um testbench que permite verificar o funcionamento do 
-- cronômetro digital por meio de uma simulação comportamental.
--
-- Dependencies: 
--
-- cronometro_digital.vhd 
-- clk_div_10Hz.vhd
-- counter_mod10.vhd
-- counter_mod6.vhd
-- clk_div_390Hz.vhd
-- mux_7seg.vhd
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
-- e a quantidade de bits de cada um. Para testbenches, a entidade geralmente é vazia.
--
entity tb_cronometro_digital is
end tb_cronometro_digital;

-- Seção Architecture: descrição do teste comportamental.
--
architecture Behavioral of tb_cronometro_digital is

-- Instanciando componente cronometro_digital:
--
component cronometro_digital is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end component cronometro_digital;

    -- Sinal de teste s_clk
    signal s_clk: std_logic := '0';
    
    -- Sinal de teste s_rst
    signal s_rst: std_logic := '0';
    
    -- Sinal de teste s_start
    signal s_start: std_logic := '0';
    
    -- Sinal de teste s_an
    signal s_an : std_logic_vector (3 downto 0) := (others => '0');
    
    -- Sinal de teste s_seg
    signal s_seg : std_logic_vector (6 downto 0) := (others => '0');

begin

    -- Conectando cada sinal de teste à sua respectiva entrada e saída
    -- do módulo cronometro_digital
    --
    uut: cronometro_digital port map(
        clk => s_clk,       
        rst => s_rst,       
        start => s_start,       
        an => s_an,
        seg => s_seg       
    );
    
    -- Estímulo do sinal de teste s_clk: sinal de clock com período de 10 ns
    s_clk <= not s_clk after 5 ns;
    
    -- Estímulo do sinal de teste s_rst: ativo em 10 ns, inativo a partir de 30 ns
    s_rst <= '1' after 10 ns, '0' after 30 ns;
    
    -- Estímulo do sinal de teste s_start: ativo em 20 ns, inativo em 100 ns e
    -- ativo novamente em 120 ns.
    s_start <= '1' after 20 ns, '0' after 100 ns, '1' after 120 ns;
    
end Behavioral;
