-- VHDL module instantiation generated by SCUBA Diamond (64-bit) 3.11.2.446.3
-- Module  Version: 2.8
-- Tue May 12 01:03:19 2020

-- parameterized module component declaration
component dist_boot_rom
    port (Address: in  std_logic_vector(9 downto 0); 
        Q: out  std_logic_vector(15 downto 0));
end component;

-- parameterized module component instance
__ : dist_boot_rom
    port map (Address(9 downto 0)=>__, Q(15 downto 0)=>__);
