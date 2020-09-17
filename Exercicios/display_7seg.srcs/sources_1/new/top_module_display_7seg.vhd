----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 17.09.2020 01:09:29
-- Design Name: 
-- Module Name: top_module_display_7seg - Behavioral
-- Project Name: Semana Universitária FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este módulo faz parte do segundo exercício do curso de Modelagem de circuitos digitais
-- da Semana Universitária FGA 2020: exibir número em um display de 7 segmentos. 
-- 
-- Este arquivo implementa o top module (nível hierárquico mais alto) para conectar o
-- módulo display_7seg ao Virtual Input Output (VIO) IP core da Xilinx, que permite
-- emular virtualmente as entradas e saídas da FPGA para implementar o circuito usando
-- as FPGAs do laboratório remoto.
-- 
-- Dependencies: 
-- 
-- display_7seg.vhd
-- vio_0.vhd
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
entity top_module_display_7seg is
    Port ( 
            -- Entrada
            --
            -- Entrada de clock de 1-bit.
            -- Descrição: Entrada de clock que implementa a frequência de operação
            -- do VIO Core. O circuito 'display_7seg' é puramente combinacional,
            -- não necessita do clock, mas o VIO IP core sim.
            --    
            clk : in STD_LOGIC;
            
            -- Saídas
            --
            -- Saída an de 4-bits.
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
end top_module_display_7seg;

-- Seção Architecture: descrição de como funciona o módulo.
--
architecture Behavioral of top_module_display_7seg is

    -- Instanciação do componente display_7seg
    --
    component display_7seg is
        Port(
                data_in : in STD_LOGIC_VECTOR(3 DOWNTO 0);
                an : out STD_LOGIC_VECTOR(3 DOWNTO 0);
                seg : out STD_LOGIC_VECTOR(6 DOWNTO 0));
    end component;
    
    -- Instanciação do componente vio_0
    component vio_0 is
        Port(
                clk : in STD_LOGIC;
                probe_out0 : out STD_LOGIC_VECTOR(3 DOWNTO 0));
    end component;    
    
    -- Sinal de conexão entre a saída 'probe_out0' do VIO core e 
    -- a entrada 'data_in' do módulo display_7seg.
    --
    signal s_data_in : std_logic_vector(3 downto 0) := (others => '0');
    
begin

    -- Conexão dos pinos do módulo display_7seg a seus respectivos sinais, entradas e saídas
    --
    MODULO_DISPLAY_7SEG: display_7seg port map
    (
        data_in => s_data_in,
        an => an,
        seg => seg
    );
    
    -- Conexão dos pinos do módulo vio_0 a seus respectivos sinais, entradas e saídas.
    --
    VIO_CORE: vio_0 port map
    (
        clk => clk,
        probe_out0 => s_data_in
    );
    
end Behavioral;
