----------------------------------------------------------------------------------
-- Company: Universidade de Bras�lia
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 17.09.2020 01:09:29
-- Design Name: 
-- Module Name: top_module_display_7seg - Behavioral
-- Project Name: Semana Universit�ria FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este m�dulo faz parte do segundo exerc�cio do curso de Modelagem de circuitos digitais
-- da Semana Universit�ria FGA 2020: exibir n�mero em um display de 7 segmentos. 
-- 
-- Este arquivo implementa o top module (n�vel hier�rquico mais alto) para conectar o
-- m�dulo display_7seg ao Virtual Input Output (VIO) IP core da Xilinx, que permite
-- emular virtualmente as entradas e sa�das da FPGA para implementar o circuito usando
-- as FPGAs do laborat�rio remoto.
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

-- Se��o Library: declarando as bibliotecas necess�rias para o nosso m�dulo.
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Se��o Entity: declarando as entradas e sa�das do nosso m�dulo, bem como o tipo 
-- e a quantidade de bits de cada um.
--
entity top_module_display_7seg is
    Port ( 
            -- Entrada
            --
            -- Entrada de clock de 1-bit.
            -- Descri��o: Entrada de clock que implementa a frequ�ncia de opera��o
            -- do VIO Core. O circuito 'display_7seg' � puramente combinacional,
            -- n�o necessita do clock, mas o VIO IP core sim.
            --    
            clk : in STD_LOGIC;
            
            -- Sa�das
            --
            -- Sa�da an de 4-bits.
            -- Descri��o: Cada bit dessa sa�da corresponde ao an�do de um display
            -- da Basys 3: o bit menos significativo controla o an�do do display
            -- mais � direita no kit e o bit mais significativo controla o an�do
            -- mais � esquerda dno kit. Os an�dos habilitam seu respectivo display
            -- em '0', e desabilitam o mesmo em '1'.
            --            
            an : out STD_LOGIC_VECTOR (3 downto 0);
            
            -- Pino de sa�da referente aos 7 segmentos dos displays da Basys 3: 7-bits
            -- Descri��o: Cada bit dessa sa�da corresponde a um dos 7 segmentos dos
            -- displays da Basys 3 na ordem 'gfedcba'. Os segmentos s�o ligados em
            -- '0' e desligados em '1'.
            --             
            seg : out STD_LOGIC_VECTOR (6 downto 0));
end top_module_display_7seg;

-- Se��o Architecture: descri��o de como funciona o m�dulo.
--
architecture Behavioral of top_module_display_7seg is

    -- Instancia��o do componente display_7seg
    --
    component display_7seg is
        Port(
                data_in : in STD_LOGIC_VECTOR(3 DOWNTO 0);
                an : out STD_LOGIC_VECTOR(3 DOWNTO 0);
                seg : out STD_LOGIC_VECTOR(6 DOWNTO 0));
    end component;
    
    -- Instancia��o do componente vio_0
    component vio_0 is
        Port(
                clk : in STD_LOGIC;
                probe_out0 : out STD_LOGIC_VECTOR(3 DOWNTO 0));
    end component;    
    
    -- Sinal de conex�o entre a sa�da 'probe_out0' do VIO core e 
    -- a entrada 'data_in' do m�dulo display_7seg.
    --
    signal s_data_in : std_logic_vector(3 downto 0) := (others => '0');
    
begin

    -- Conex�o dos pinos do m�dulo display_7seg a seus respectivos sinais, entradas e sa�das
    --
    MODULO_DISPLAY_7SEG: display_7seg port map
    (
        data_in => s_data_in,
        an => an,
        seg => seg
    );
    
    -- Conex�o dos pinos do m�dulo vio_0 a seus respectivos sinais, entradas e sa�das.
    --
    VIO_CORE: vio_0 port map
    (
        clk => clk,
        probe_out0 => s_data_in
    );
    
end Behavioral;
