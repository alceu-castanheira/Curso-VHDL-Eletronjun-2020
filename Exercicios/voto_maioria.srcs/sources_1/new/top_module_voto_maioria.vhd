----------------------------------------------------------------------------------
-- Company: Universidade de Brasília 
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 16.09.2020 23:34:08
-- Design Name: voto_maioria
-- Module Name: top_module_voto_maioria - Behavioral
-- Project Name: Semana Universitária FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este módulo faz parte do primeiro exercício do curso de Modelagem de circuitos digitais
-- da Semana Universitária FGA 2020: voto_maioria. 
-- 
-- Este arquivo implementa o top module (nível hierárquico mais alto) para conectar o
-- módulo voto_maioria ao Virtual Input Output (VIO) IP core da Xilinx, que permite
-- emular virtualmente as entradas e saídas da FPGA para implementar o circuito usando
-- as FPGAs do laboratório remoto.
-- 
-- Dependencies: 
-- 
-- voto_maioria.vhd
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
entity top_module_voto_maioria is
    Port ( 
            -- Entrada
            --
            -- Entrada de clock de 1-bit.
            -- Descrição: Entrada de clock que implementa a frequência de operação
            -- do VIO Core. O circuito 'voto_maioria' é puramente combinacional,
            -- não necessita do clock, mas o VIO IP core sim.
            --
            clk : in STD_LOGIC;
            
            -- Saída
            --
            -- Saída decisao de 1-bit
            -- Descrição: indica a decisão da maioria dos votos: se dois ou mais votos
            -- forem '1', a saída é '1'; se dois ou mais votos forem '0', a saída é '0'.
            --           
            decisao : out STD_LOGIC);
end top_module_voto_maioria;

-- Seção Architecture: descrição de como funciona o módulo.
--
architecture Behavioral of top_module_voto_maioria is

    -- Instanciação do componente voto_maioria
    component voto_maioria is
        Port (
                voto_1 : in STD_LOGIC;
                voto_2 : in STD_LOGIC;
                voto_3 : in STD_LOGIC;
                decisao : out STD_LOGIC);
    end component;
    
    -- Instanciação do componente vio_0
    component vio_0 is
        Port (
                clk : in STD_LOGIC;
                probe_out0 : out STD_LOGIC_VECTOR(0 DOWNTO 0);
                probe_out1 : out STD_LOGIC_VECTOR(0 DOWNTO 0);
                probe_out2 : out STD_LOGIC_VECTOR(0 DOWNTO 0));
    end component;
    
    -- Sinais de conexão entre os módulos voto_maioria e vio_0:
    --
    -- Sinal de conexão entre probe_out0 e voto_1
    signal s_voto_1 : std_logic := '0';

    -- Sinal de conexão entre probe_out1 e voto_2
    signal s_voto_2 : std_logic := '0';
    
    -- Sinal de conexão entre probe_out2 e voto_3
    signal s_voto_3 : std_logic := '0';
                
begin

    -- Conexão dos pinos do módulo voto_maioria aos seus respectivos sinais,
    -- entradas e saídas
    --
    VOTO_MAIORIA_MODULO: voto_maioria port map
    (
        voto_1 => s_voto_1,
        voto_2 => s_voto_2,
        voto_3 => s_voto_3,
        decisao => decisao
    ); 
    
    -- Conexão dos pinos do módulo vio_0 aos seus respectivos sinais, entradas e
    -- saídas
    --
    VIO_IP_CORE: vio_0 port map
    (
        clk => clk,
        probe_out0(0) => s_voto_1,
        probe_out1(0) => s_voto_2,
        probe_out2(0) => s_voto_3
    );
    
end Behavioral;
