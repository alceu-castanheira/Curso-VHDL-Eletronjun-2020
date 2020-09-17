----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 15.09.2020 00:40:47
-- Design Name: cronometro_digital
-- Module Name: cronometro_digital - Behavioral
-- Project Name: Semana Universitária FGA 2020 - Modelagem de circuitos digitais
-- Target Devices: Artix 7 - Basys 3
-- Tool Versions: Vivado 2018.3
-- Description: 
-- 
-- Este módulo faz parte do projeto final do curso de Modelagem de circuitos digitais
-- da Semana Universitária FGA 2020: cronometro_digital. 
-- 
-- Este arquivo implementa o top module, nível hierárquico mais alto, conectando
-- todos os componentes desenvolvidos para implementação do cronômetro digital.
--
--
-- Dependencies: 
-- 
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

-- Seção Library: declarando as bibliotecas necessárias para o nosso módulo. Notar 
-- que NUMERIC_STD é necessária para realizar operações aritméticas
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Seção Entity: declarando as entradas e saídas do nosso módulo, bem como o tipo 
-- e a quantidade de bits de cada um.
--
entity cronometro_digital is
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
            --rst : in STD_LOGIC;
            
            -- Pino de entrada de start: 1-bit
            -- Descrição: inicia o processo de contagem do cronômetro quando em
            -- '1'. Quando em '0', pausa o processo de contagem.
            --
            --start : in STD_LOGIC;
            
            -- Saídas
            --
            -- Pino de saída referente aos anôdos dos displays de 7 segmentos da
            -- Basys 3: 4-bits
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
end cronometro_digital;

-- Seção Architecture: descrição de como funciona o módulo.
--
architecture Behavioral of cronometro_digital is

-- Instanciando componente counter_mod10:
--
component counter_mod10 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           
           count_end : out STD_LOGIC;
           count_out : out STD_LOGIC_VECTOR (3 downto 0));
end component counter_mod10;

-- Instanciando componente counter_mod6:
--
component counter_mod6 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           
           count_end : out STD_LOGIC;
           count_out : out STD_LOGIC_VECTOR (3 downto 0));
end component counter_mod6;

-- Instanciando componente mux_7seg:
--
component mux_7seg is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           digit_1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit_2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit_3 : in STD_LOGIC_VECTOR (3 downto 0);
           digit_4 : in STD_LOGIC_VECTOR (3 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end component mux_7seg;

-- Instanciando componente clk_div_390Hz:
--
component clk_div_390Hz is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_390Hz : out STD_LOGIC);
end component clk_div_390Hz;

-- Instanciando componente clk_div_10Hz:
--
component clk_div_10Hz is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_10Hz : out STD_LOGIC);
end component clk_div_10Hz;

-- Instanciando componente vio_0: Virtual Input Output IP core da
-- Xilinx, para geração de entradas virtuais e controle do FPGA no 
-- laboratório remoto.
--
COMPONENT vio_0
  PORT (
    clk : IN STD_LOGIC;
    probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;

    -- Sinal que conecta o reset do vio_0 ao rst de cada módulo do sistema
    -- Conexão: probe_out1 de VIO_CORE -> rst de CLK_10HZ, DISPLAY_1, DISPLAY_2,
    -- DISPLAY_3, DISPLAY_4, CLK_390HZ, DISPLAY_MUX.
    --
    signal s_rst : std_logic := '0';
    
    -- Sinal que conecta o start do vio_0 ao start do primeiro display para 
    -- iniciar a contagem do cronômetro.
    -- Conexão: probe_out2 de VIO_CORE -> enable de DISPLAY_1.
    --
    signal s_start : std_logic := '0';
    
    -- Sinal que habilita a contagem do segundo display com o segundo dígito
    -- Conexão: count_end de DISPLAY_1 -> enable de DISPLAY_2 
    --
    signal s_start_digit_2 : std_logic := '0';
    
    -- Sinal que habilita a contagem do terceiro display com o terceiro dígito
    -- Conexão: count_end de DISPLAY_2 -> enable de DISPLAY_3 
    --    
    signal s_start_digit_3 : std_logic := '0';

    -- Sinal que habilita a contagem do segundo quarto com o quarto dígito
    -- Conexão: count_end de DISPLAY_3 -> enable de DISPLAY_4 
    --    
    signal s_start_digit_4 : std_logic := '0';
    
    -- Sinal que conecta a saída do contador referente ao primeiro dígito
    -- (unidade dos décimos de segundo) ao módulo de multiplexação dos
    -- displays.
    -- Conexão: count_out de DISPLAY_1 -> digit_1 de DISPLAY_MUX.
    --
    signal s_digit_1 : std_logic_vector(3 downto 0) := (others => '0');

    -- Sinal que conecta a saída do contador referente ao segundo dígito
    -- (dezena dos décimos de segundo) ao módulo de multiplexação dos
    -- displays.
    -- Conexão: count_out de DISPLAY_2 -> digit_2 de DISPLAY_MUX.
    --
    signal s_digit_2 : std_logic_vector(3 downto 0) := (others => '0');

    -- Sinal que conecta a saída do contador referente ao terceiro dígito
    -- (unidade dos segundos) ao módulo de multiplexação dos
    -- displays.
    -- Conexão: count_out de DISPLAY_3 -> digit_3 de DISPLAY_MUX.
    --    
    signal s_digit_3 : std_logic_vector(3 downto 0) := (others => '0');
    
    -- Sinal que conecta a saída do contador referente ao quarto dígito
    -- (dezenas dos segundos) ao módulo de multiplexação dos
    -- displays.
    -- Conexão: count_out de DISPLAY_4 -> digit_4 de DISPLAY_MUX.
    --    
    signal s_digit_4 : std_logic_vector(3 downto 0) := (others => '0');
    
    -- Sinal que conecta o clock de 390 Hz do módulo clk_div_390Hz à
    -- entrada de clock do multiplexador de displays, para alternar entre
    -- os displays em uma frequência adequada ao olho humano, com a 
    -- impressão de que todos os displays estão acessos ao mesmo tempo.
    -- Conexão: clk_390Hz de CLK_390Hz -> clk de DISPLAY_MUX
    --
    signal s_clk_390Hz : std_logic := '0';
 
     -- Sinal que conecta o clock de 10 Hz do módulo clk_div_10Hz à
    -- entrada de clock dos contadores, para contarem os décimos de
    -- segundo adequadamente.
    -- Conexão: clk_10Hz de CLK_10Hz -> clk de DISPLAY_1, DISPLAY_2,
    -- DISPLAY_3 e DISPLAY_4.
    --
    signal s_clk_10Hz : std_logic := '0';
    
begin

    -- Realizando as conexões do módulo vio0
    --
    VIO_CORE: vio_0 port map
    (
        clk => clk,
        probe_out0(0) => s_rst,
        probe_out1(0) => s_start
    );
    
    -- Realizando as conexões do módulo clk_div_10Hz
    --
    CLK_10HZ: clk_div_10Hz port map
    (
        clk => clk,
        rst => s_rst,
        clk_10Hz => s_clk_10Hz
    );

    -- Realizando as conexões do primeiro módulo 
    -- counter_mod10 (unidade de décimo de segundo)
    --    
    DISPLAY_1: counter_mod10 port map
    (
        clk => s_clk_10Hz,
        rst => s_rst,
        enable => s_start,
        count_end => s_start_digit_2,
        count_out => s_digit_1
    );

    -- Realizando as conexões do segundo módulo 
    -- counter_mod10 (dezena de décimo de segundo)
    -- 
    DISPLAY_2: counter_mod10 port map
    (
        clk => s_clk_10Hz,
        rst => s_rst,
        enable => s_start_digit_2,
        count_end => s_start_digit_3,
        count_out => s_digit_2
    );

    -- Realizando as conexões do terceiro módulo 
    -- counter_mod10 (unidade de segundo)
    --     
    DISPLAY_3: counter_mod10 port map
    (
        clk => s_clk_10Hz,
        rst => s_rst,
        enable => s_start_digit_3,
        count_end => s_start_digit_4,
        count_out => s_digit_3
    );

    -- Realizando as conexões do módulo 
    -- counter_mod6 (dezena de segundo)
    --     
    DISPLAY_4: counter_mod6 port map
    (
        clk => s_clk_10Hz,
        rst => s_rst,
        enable => s_start_digit_4,
        count_end => open,
        count_out => s_digit_4
    );

    -- Realizando as conexões do módulo clk_div_390Hz
    --
    CLK_390HZ: clk_div_390Hz port map
    (
        clk => clk,
        rst => s_rst,
        clk_390Hz => s_clk_390Hz
    );
  
    -- Realizando conexões do módulo mux_7seg
    --                   
    DISPLAY_MUX: mux_7seg port map
    (
        clk => s_clk_390Hz,
        rst => s_rst,
        digit_1 => s_digit_1,
        digit_2 => s_digit_2,
        digit_3 => s_digit_3,
        digit_4 => s_digit_4,
        an => an,
        seg => seg
    );            
    
end Behavioral;
