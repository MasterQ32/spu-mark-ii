-- VHDL netlist generated by SCUBA Diamond (64-bit) 3.11.2.446.3
-- Module  Version: 2.8
--/usr/local/diamond/3.11_x64/ispfpga/bin/lin64/scuba -w -n dist_boot_rom -lang vhdl -synth lse -bus_exp 7 -bb -arch xo3c00f -type rom -addr_width 10 -num_rows 1024 -data_width 16 -outdata UNREGISTERED -memfile /home/felix/projects/lowlevel/spu-mark-2/soc/hw/firmware.mem -memformat orca 

-- Tue May 12 01:03:19 2020

library IEEE;
use IEEE.std_logic_1164.all;
-- synopsys translate_off
library MACHXO3L;
use MACHXO3L.components.all;
-- synopsys translate_on

entity dist_boot_rom is
    port (
        Address: in  std_logic_vector(9 downto 0); 
        Q: out  std_logic_vector(15 downto 0));
end dist_boot_rom;

architecture Structure of dist_boot_rom is

    -- internal signal declarations
    signal mdL0_0_3: std_logic;
    signal mdL0_0_2: std_logic;
    signal mdL0_0_1: std_logic;
    signal mdL0_0_0: std_logic;
    signal mdL0_1_3: std_logic;
    signal mdL0_1_2: std_logic;
    signal mdL0_1_1: std_logic;
    signal mdL0_1_0: std_logic;
    signal mdL0_2_3: std_logic;
    signal mdL0_2_2: std_logic;
    signal mdL0_2_1: std_logic;
    signal mdL0_2_0: std_logic;
    signal mdL0_3_3: std_logic;
    signal mdL0_3_2: std_logic;
    signal mdL0_3_1: std_logic;
    signal mdL0_3_0: std_logic;
    signal mdL0_4_3: std_logic;
    signal mdL0_4_2: std_logic;
    signal mdL0_4_1: std_logic;
    signal mdL0_4_0: std_logic;
    signal mdL0_5_3: std_logic;
    signal mdL0_5_2: std_logic;
    signal mdL0_5_1: std_logic;
    signal mdL0_5_0: std_logic;
    signal mdL0_6_3: std_logic;
    signal mdL0_6_2: std_logic;
    signal mdL0_6_1: std_logic;
    signal mdL0_6_0: std_logic;
    signal mdL0_7_3: std_logic;
    signal mdL0_7_2: std_logic;
    signal mdL0_7_1: std_logic;
    signal mdL0_7_0: std_logic;
    signal mdL0_8_3: std_logic;
    signal mdL0_8_2: std_logic;
    signal mdL0_8_1: std_logic;
    signal mdL0_8_0: std_logic;
    signal mdL0_9_3: std_logic;
    signal mdL0_9_2: std_logic;
    signal mdL0_9_1: std_logic;
    signal mdL0_9_0: std_logic;
    signal mdL0_10_3: std_logic;
    signal mdL0_10_2: std_logic;
    signal mdL0_10_1: std_logic;
    signal mdL0_10_0: std_logic;
    signal mdL0_11_3: std_logic;
    signal mdL0_11_2: std_logic;
    signal mdL0_11_1: std_logic;
    signal mdL0_11_0: std_logic;
    signal mdL0_12_3: std_logic;
    signal mdL0_12_2: std_logic;
    signal mdL0_12_1: std_logic;
    signal mdL0_12_0: std_logic;
    signal mdL0_13_3: std_logic;
    signal mdL0_13_2: std_logic;
    signal mdL0_13_1: std_logic;
    signal mdL0_13_0: std_logic;
    signal mdL0_14_3: std_logic;
    signal mdL0_14_2: std_logic;
    signal mdL0_14_1: std_logic;
    signal mdL0_14_0: std_logic;
    signal mdL0_15_3: std_logic;
    signal mdL0_15_2: std_logic;
    signal mdL0_15_1: std_logic;
    signal mdL0_15_0: std_logic;

    -- local component declarations
    component MUX41
        port (D0: in  std_logic; D1: in  std_logic; D2: in  std_logic; 
            D3: in  std_logic; SD1: in  std_logic; SD2: in  std_logic; 
            Z: out  std_logic);
    end component;
    component ROM256X1A
        generic (INITVAL : in std_logic_vector(255 downto 0));
        port (AD7: in  std_logic; AD6: in  std_logic; AD5: in  std_logic; 
            AD4: in  std_logic; AD3: in  std_logic; AD2: in  std_logic; 
            AD1: in  std_logic; AD0: in  std_logic; DO0: out  std_logic);
    end component;
    attribute NGD_DRC_MASK : integer;
    attribute NGD_DRC_MASK of Structure : architecture is 1;

begin
    -- component instantiation statements
    mem_0_15: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000089240")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_0_0);

    mem_0_14: ROM256X1A
        generic map (initval=> X"444624924000003F7E00033FF763EFBB1762EC5D8DD800060000000000009240")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_1_0);

    mem_0_13: ROM256X1A
        generic map (initval=> X"000000000A3FFF4082FFFC3EFFE3FFFF0FE1FC3F8FF800024029249249249240")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_2_0);

    mem_0_12: ROM256X1A
        generic map (initval=> X"000112492A3FFE0E12FFFA864201C7101202400800800012402DB6DB6DB6DB60")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_3_0);

    mem_0_11: ROM256X1A
        generic map (initval=> X"0000100002FFFEA16BFFFFF1041620A0A41482D0510400120020000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_4_0);

    mem_0_10: ROM256X1A
        generic map (initval=> X"644512492AFFFFA553FFFC20F567E9AB2566ACD59D580130122492492492493C")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_5_0);

    mem_0_9: ROM256X1A
        generic map (initval=> X"1330400000000139000006EE461224B09610C218418404808802492480000001")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_6_0);

    mem_0_8: ROM256X1A
        generic map (initval=> X"0000900000FFFFA145FFFA9B3366891B23666CCD9CDA08374390000000000010")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_7_0);

    mem_0_7: ROM256X1A
        generic map (initval=> X"66449000000000000000000000000000000000000001F8094000000000010004")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_8_0);

    mem_0_6: ROM256X1A
        generic map (initval=> X"9999C000000000EFD800053EF7E7FFBF37E6FCDF9DF9C1009102480000010008")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_9_0);

    mem_0_5: ROM256X1A
        generic map (initval=> X"FFDC436D207FFE9025FFF83FEEC7DF760EC1D83B1BB3B9059006936924936928")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_10_0);

    mem_0_4: ROM256X1A
        generic map (initval=> X"4C448004003FFEC408FFFB1C79E0CBCF29E53C279E796A1F2009659640010410")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_11_0);

    mem_0_3: ROM256X1A
        generic map (initval=> X"B939DA4DABBFFFA243FFFF620C1E2460DC1983F06307A6BEABADB6492DB64927")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_12_0);

    mem_0_2: ROM256X1A
        generic map (initval=> X"A0804004807FFE8ED1FFF87E84941CA484909252512531001109009009009008")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_13_0);

    mem_0_1: ROM256X1A
        generic map (initval=> X"20A0000401C001414B0007227D6DC56B4D6FAD75AF594941150820820820820A")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_14_0);

    mem_0_0: ROM256X1A
        generic map (initval=> X"11900000807FFE6FD8FFFB68A65365B2B654CA99499400008112492480092480")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_15_0);

    mem_1_15: ROM256X1A
        generic map (initval=> X"FFF8000000000000000000002200800000000000020000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_0_1);

    mem_1_14: ROM256X1A
        generic map (initval=> X"FFF8124DE4980DF800048004A60080220408000C00203FF86EC83786E4F78000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_1_1);

    mem_1_13: ROM256X1A
        generic map (initval=> X"FFFB8209E4139FF800000000220080000008000000303DFF7FFDFFF7FEFF8000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_2_1);

    mem_1_12: ROM256X1A
        generic map (initval=> X"FFFB9103E2078008000240026200800004080002003002F80001D08440808000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_3_1);

    mem_1_11: ROM256X1A
        generic map (initval=> X"FFF93103E20534B4000000003300C0000400000200107204A64AA14825754000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_4_1);

    mem_1_10: ROM256X1A
        generic map (initval=> X"FFFB220A0416394801024042B21080222040820A90197E0C4ACA254201748480")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_5_1);

    mem_1_9: ROM256X1A
        generic map (initval=> X"FFFC0CB01960104D0C30033022C3B19983061860490422F08240138800D0D24B")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_6_1);

    mem_1_8: ROM256X1A
        generic map (initval=> X"FFF89BEBF7D5ADFA09400260A796C1112E5CB2821C4147746C422242A1B320B0")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_7_1);

    mem_1_7: ROM256X1A
        generic map (initval=> X"FFF80AA81550000208200200A280E02302041048080800000000000000002012")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_8_1);

    mem_1_6: ROM256X1A
        generic map (initval=> X"FFF83CB009200F78002000007202A1000400004080807FB27BC0BD27E0FF8401")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_9_1);

    mem_1_5: ROM256X1A
        generic map (initval=> X"FFF834D019E03FFA0002402AF60081220400001880806FFF7FFBFFF7FDFFA413")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_10_1);

    mem_1_4: ROM256X1A
        generic map (initval=> X"FFFF1349E6920222F8003E00E6808E33060C1019000014221103810141002856")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_11_1);

    mem_1_3: ROM256X1A
        generic map (initval=> X"FFFF375BEEB67B45FD5B7F5AF3D7DF99AF5EBABB55DDB302D864A40F93225AED")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_12_1);

    mem_1_2: ROM256X1A
        generic map (initval=> X"FFF8049019603C64080102082282811102041020880052B0E0603D2CB0AA4442")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_13_1);

    mem_1_1: ROM256X1A
        generic map (initval=> X"FFF848A0010074420A28028822A0A00142851450A08294002104342043142510")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_14_1);

    mem_1_0: ROM256X1A
        generic map (initval=> X"FFF800000000001C00010001080180C8000000000000799083A02D295079C001")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_15_1);

    mem_2_15: ROM256X1A
        generic map (initval=> X"0000000000000000000080040000000000800040000000000007FFC7FFC707FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_0_2);

    mem_2_14: ROM256X1A
        generic map (initval=> X"0000000000002488884588A42222401240124002491249200C07FFC7FFC707FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_1_2);

    mem_2_13: ROM256X1A
        generic map (initval=> X"0000000000E0000000008004000007000000000000000007003FFFC7FFC707FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_2_2);

    mem_2_12: ROM256X1A
        generic map (initval=> X"0000000000E8125000828404000027092009200124892497033FFFC7FFC707FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_3_2);

    mem_2_11: ROM256X1A
        generic map (initval=> X"00000000004200020010D00E0000220000000000000000020157FFFFFFFF87FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_4_2);

    mem_2_10: ROM256X1A
        generic map (initval=> X"0000000000C10000CC0082A53333240929092481248924964027FFF7FFF767FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_5_2);

    mem_2_9: ROM256X1A
        generic map (initval=> X"0000000001008000220081048888804004000200004000082007FFEFFFEF57FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_6_2);

    mem_2_8: ROM256X1A
        generic map (initval=> X"000000000023000AC455D22F11112B80014004A800000001095FFFC7FFC7FFFF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_7_2);

    mem_2_7: ROM256X1A
        generic map (initval=> X"0000000000000000080080842332208000000000000000000107FF8FFF8F07FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_8_2);

    mem_2_6: ROM256X1A
        generic map (initval=> X"0000000000000008004385841C00800008000000002412004207FF8FFF8F07FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_9_2);

    mem_2_5: ROM256X1A
        generic map (initval=> X"0000000000081A50888781A47F328089A8292015A48924904A07FF8FFF8F07FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_10_2);

    mem_2_4: ROM256X1A
        generic map (initval=> X"0000000001C90018CCC782A53627048090201C000044824EC927FF8FFF8F07FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_11_2);

    mem_2_3: ROM256X1A
        generic map (initval=> X"0000000001CBD35AE6D7D7AF8DCDAC6DB56DBAA936EDB6DEAA67FFFFFFFF87FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_12_2);

    mem_2_2: ROM256X1A
        generic map (initval=> X"0000000000000000000081049440800488208000820000000007FFEFFFEF67FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_13_2);

    mem_2_1: ROM256X1A
        generic map (initval=> X"00000000000500044420A315151500A00A240100102482402A87FFDFFFDF57FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_14_2);

    mem_2_0: ROM256X1A
        generic map (initval=> X"0000000000000001200880540CCC000400008000020482401007FFFFFFFF07FF")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_15_2);

    mem_3_15: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_0_3);

    mem_3_14: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_1_3);

    mem_3_13: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_2_3);

    mem_3_12: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_3_3);

    mem_3_11: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_4_3);

    mem_3_10: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_5_3);

    mem_3_9: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_6_3);

    mem_3_8: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_7_3);

    mem_3_7: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_8_3);

    mem_3_6: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_9_3);

    mem_3_5: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_10_3);

    mem_3_4: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_11_3);

    mem_3_3: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_12_3);

    mem_3_2: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_13_3);

    mem_3_1: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_14_3);

    mem_3_0: ROM256X1A
        generic map (initval=> X"0000000000000000000000000000000000000000000000000000000000000000")
        port map (AD7=>Address(7), AD6=>Address(6), AD5=>Address(5), 
            AD4=>Address(4), AD3=>Address(3), AD2=>Address(2), 
            AD1=>Address(1), AD0=>Address(0), DO0=>mdL0_15_3);

    mux_15: MUX41
        port map (D0=>mdL0_0_0, D1=>mdL0_0_1, D2=>mdL0_0_2, D3=>mdL0_0_3, 
            SD1=>Address(8), SD2=>Address(9), Z=>Q(15));

    mux_14: MUX41
        port map (D0=>mdL0_1_0, D1=>mdL0_1_1, D2=>mdL0_1_2, D3=>mdL0_1_3, 
            SD1=>Address(8), SD2=>Address(9), Z=>Q(14));

    mux_13: MUX41
        port map (D0=>mdL0_2_0, D1=>mdL0_2_1, D2=>mdL0_2_2, D3=>mdL0_2_3, 
            SD1=>Address(8), SD2=>Address(9), Z=>Q(13));

    mux_12: MUX41
        port map (D0=>mdL0_3_0, D1=>mdL0_3_1, D2=>mdL0_3_2, D3=>mdL0_3_3, 
            SD1=>Address(8), SD2=>Address(9), Z=>Q(12));

    mux_11: MUX41
        port map (D0=>mdL0_4_0, D1=>mdL0_4_1, D2=>mdL0_4_2, D3=>mdL0_4_3, 
            SD1=>Address(8), SD2=>Address(9), Z=>Q(11));

    mux_10: MUX41
        port map (D0=>mdL0_5_0, D1=>mdL0_5_1, D2=>mdL0_5_2, D3=>mdL0_5_3, 
            SD1=>Address(8), SD2=>Address(9), Z=>Q(10));

    mux_9: MUX41
        port map (D0=>mdL0_6_0, D1=>mdL0_6_1, D2=>mdL0_6_2, D3=>mdL0_6_3, 
            SD1=>Address(8), SD2=>Address(9), Z=>Q(9));

    mux_8: MUX41
        port map (D0=>mdL0_7_0, D1=>mdL0_7_1, D2=>mdL0_7_2, D3=>mdL0_7_3, 
            SD1=>Address(8), SD2=>Address(9), Z=>Q(8));

    mux_7: MUX41
        port map (D0=>mdL0_8_0, D1=>mdL0_8_1, D2=>mdL0_8_2, D3=>mdL0_8_3, 
            SD1=>Address(8), SD2=>Address(9), Z=>Q(7));

    mux_6: MUX41
        port map (D0=>mdL0_9_0, D1=>mdL0_9_1, D2=>mdL0_9_2, D3=>mdL0_9_3, 
            SD1=>Address(8), SD2=>Address(9), Z=>Q(6));

    mux_5: MUX41
        port map (D0=>mdL0_10_0, D1=>mdL0_10_1, D2=>mdL0_10_2, 
            D3=>mdL0_10_3, SD1=>Address(8), SD2=>Address(9), Z=>Q(5));

    mux_4: MUX41
        port map (D0=>mdL0_11_0, D1=>mdL0_11_1, D2=>mdL0_11_2, 
            D3=>mdL0_11_3, SD1=>Address(8), SD2=>Address(9), Z=>Q(4));

    mux_3: MUX41
        port map (D0=>mdL0_12_0, D1=>mdL0_12_1, D2=>mdL0_12_2, 
            D3=>mdL0_12_3, SD1=>Address(8), SD2=>Address(9), Z=>Q(3));

    mux_2: MUX41
        port map (D0=>mdL0_13_0, D1=>mdL0_13_1, D2=>mdL0_13_2, 
            D3=>mdL0_13_3, SD1=>Address(8), SD2=>Address(9), Z=>Q(2));

    mux_1: MUX41
        port map (D0=>mdL0_14_0, D1=>mdL0_14_1, D2=>mdL0_14_2, 
            D3=>mdL0_14_3, SD1=>Address(8), SD2=>Address(9), Z=>Q(1));

    mux_0: MUX41
        port map (D0=>mdL0_15_0, D1=>mdL0_15_1, D2=>mdL0_15_2, 
            D3=>mdL0_15_3, SD1=>Address(8), SD2=>Address(9), Z=>Q(0));

end Structure;

-- synopsys translate_off
library MACHXO3L;
configuration Structure_CON of dist_boot_rom is
    for Structure
        for all:MUX41 use entity MACHXO3L.MUX41(V); end for;
        for all:ROM256X1A use entity MACHXO3L.ROM256X1A(V); end for;
    end for;
end Structure_CON;

-- synopsys translate_on
