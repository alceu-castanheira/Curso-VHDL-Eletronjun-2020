----------------------------------------------------------------------------------
-- Company: Universidade de Bras�lia 
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 16.09.2020 23:34:08
-- Design Name: voto_maioria
-- Module Name: top_module_voto_maioria - Behavioral
-- Project Name: Semana Universit�ria FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este m�dulo faz parte do primeiro exerc�cio do curso de Modelagem de circuitos digitais
-- da Semana Universit�ria FGA 2020: voto_maioria. 
-- 
-- Este arquivo implementa o top module (n�vel hier�rquico mais alto) para conectar o
-- m�dulo voto_maioria ao Virtual Input Output (VIO) IP core da Xilinx, que permite
-- emular virtualmente as entradas e sa�das da FPGA para implementar o circuito usando
-- as FPGAs do laborat�rio remoto.
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

-- Se��o Library: declarando as bibliotecas necess�rias para o nosso m�dulo.
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Se��o Entity: declarando as entradas e sa�das do nosso m�dulo, bem como o tipo 
-- e a quantidade de bits de cada um.
--
entity top_module_voto_maioria is
    Port ( 
            -- Entrada
            --
            -- Entrada de clock de 1-bit.
            -- Descri��o: Entrada de clock que implementa a frequ�ncia de opera��o
            -- do VIO Core. O circuito 'voto_maioria' � puramente combinacional,
            -- n�o necessita do clock, mas o VIO IP core sim.
            --
            clk : in STD_LOGIC;
            
            -- Sa�da
            --
            -- Sa�da decisao de 1-bit
            -- Descri��o: indica a decis�o da maioria dos votos: se dois ou mais votos
            -- forem '1', a sa�da � '1'; se dois ou mais votos forem '0', a sa�da � '0'.
            --           
            decisao : out STD_LOGIC);
end top_module_voto_maioria;

-- Se��o Architecture: descri��o de como funciona o m�dulo.
--
architecture Behavioral of top_module_voto_maioria is

    -- Instancia��o do componente voto_maioria
    component voto_maioria is
        Port (
                voto_1 : in STD_LOGIC;
                voto_2 : in STD_LOGIC;
                voto_3 : in STD_LOGIC;
                decisao : out STD_LOGIC);
    end component;
    
    -- Instancia��o do componente vio_0
    component vio_0 is
        Port (
                clk : in STD_LOGIC;
                probe_out0 : out STD_LOGIC_VECTOR(0 DOWNTO 0);
                probe_out1 : out STD_LOGIC_VECTOR(0 DOWNTO 0);
                probe_out2 : out STD_LOGIC_VECTOR(0 DOWNTO 0));
    end component;
    
    -- Sinais de conex�o entre os m�dulos voto_maioria e vio_0:
    --
    -- Sinal de conex�o entre probe_out0 e voto_1
    signal s_voto_1 : std_logic := '0';

    -- Sinal de conex�o entre probe_out1 e voto_2
    signal s_voto_2 : std_logic := '0';
    
    -- Sinal de conex�o entre probe_out2 e voto_3
    signal s_voto_3 : std_logic := '0';
                
begin

    -- Conex�o dos pinos do m�dulo voto_maioria aos seus respectivos sinais,
    -- entradas e sa�das
    --
    VOTO_MAIORIA_MODULO: voto_maioria port map
    (
        voto_1 => s_voto_1,
        voto_2 => s_voto_2,
        voto_3 => s_voto_3,
        decisao => decisao
    ); 
    
    -- Conex�o dos pinos do m�dulo vio_0 aos seus respectivos sinais, entradas e
    -- sa�das
    --
    VIO_IP_CORE: vio_0 port map
    (
        clk => clk,
        probe_out0(0) => s_voto_1,
        probe_out1(0) => s_voto_2,
        probe_out2(0) => s_voto_3
    );
    
end Behavioral;
