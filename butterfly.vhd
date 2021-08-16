-- Butterfy hardware implmented in VHDL
library IEEE;
use IEEE.std_logic_1164.all;

-- ports for full adder
entity fa is 
port ( 
	x,y, Cin : in std_logic;
    s, Cout : out std_logic
    );
end fa;

-- Logic for a basic full adder component
architecture adder_logic of fa is
begin 
	s <= x xor y xor Cin; 
    Cout <= (x and y) or (Cin and x) or (Cin and y);
end adder_logic;

entity b8_adder is 
port ( 
	x1,x2,x3,x4 : in std_logic;
    x5,x6,x7,x8 : in std_logic;
  	y1,y2,y3,y4 : in std_logic;
    y5,y6,y7,y8 : in std_logic;
  	z1,z2,z3,z4 : out std_logic;
    z5,z6,z7,z8 : out std_logic;
    Cin : in std_logic;
    Cout : out std_logic
    );
end entity b8_adder;

architecture b8_adder_logic of b8_adder is

    -- setup carry values between full adders 
    signal c1, c2, c3, c4, c5, c6, c7 : std_logic;

    -- setup the adder compenent for this component
    component fa
    port (
        x, y, Cin : in std_logic;
        s, Cout : out std_logic
        );
    end component;

    -- the parts of the adder 
    begin 
        -- each full adder is 2 inputs, carry in, output and carry out
        FA1: fa port map (Cin, x1, y1, z1, c1);
        FA2: fa port map (c1, x2 , y2, z2, c2);
        FA3: fa port map (c2, x3 , y3, z3, c3);
        FA4: fa port map (c3, x4 , y4, z4, c4);
        FA5: fa port map (c4, x5 , y5, z5, c5);
        FA6: fa port map (c5, x6 , y6, z6, c6);
        FA7: fa port map (c6, x7 , y7, z7, c7);
        FA8: fa port map (c7, x8 , y8, z8, Cout);

end architecture b8_adder_logic;

-- structure for multiplier 
entity b8_multi is 
port ( 
	x1,x2,x3,x4 : in std_logic;
    x5,x6,x7,x8 : in std_logic;
  	y1,y2,y3,y4 : in std_logic;
    y5,y6,y7,y8 : in std_logic;
  	z1,z2,z3,z4 : out std_logic;
    z5,z6,z7,z8 : out std_logic;
    z9,z10,z11,z12, z13, z14 : out std_logic
    );
end b8_multi;

-- logic for multiplier 
architecture b8_multi_logic of b8_multi is
    -- setup interconnections 
    signal c1, c2, c3, c4, c5, c6 : std_logic; 

    signal s11, s12, s13, s14, s15, s16, s17, s18 : std_logic;
    signal s21, s22, s23, s24, s25, s26, s27, s28 : std_logic; 
    signal s31, s32, s33, s34, s35, s36, s37, s38 : std_logic;
    signal s41, s42, s43, s44, s45, s46, s47, s48 : std_logic;
    signal s51, s52, s53, s54, s55, s56, s57, s58 : std_logic;
    signal s61, s62, s63, s64, s65, s66, s67, s68 : std_logic;


    component b8_adder
    port (
        x1,x2,x3,x4 : in std_logic;
        x5,x6,x7,x8 : in std_logic;
        y1,y2,y3,y4 : in std_logic;
        y5,y6,y7,y8 : in std_logic;
        z1,z2,z3,z4 : out std_logic;
        z5,z6,z7,z8 : out std_logic
        );
    end component;

    -- do the multiplication circutry using wallace tree
    begin 
        BA1: b8_adder port map ((x2 and y1), (x3 and y1),(x4 and y1),(x5 and y1),(x6 and y1),(x7 and y1), 0, (x1 and y2), (x2 and y2), (x3 and y2),(x4 and y2),(x5 and y2),(x6 and y2),(x7 and y2), z1, s12, s13, s14, s15, s16, s17, s18);
        BA2: b8_adder port map (s12,s13,s14,s15,s16,s17,(x1 and y2), (x2 and y2), (x3 and y2),(x4 and y2),(x5 and y2),(x6 and y2),(x7 and y2), z2, s22, s23, s24, s25, s26, s27, s28);
        BA3: b8_adder port map (s22,s23,s24,s25,s26,s27,(x1 and y3), (x2 and y3), (x3 and y3),(x4 and y3),(x5 and y3),(x6 and y3),(x7 and y3), z3, s32, s33, s34, s35, s36, s37, s38);
        BA4: b8_adder port map (s32,s33,s34,s35,s36,s37,(x1 and y4), (x2 and y4), (x3 and y4),(x4 and y4),(x5 and y4),(x6 and y4),(x7 and y4), z4, s42, s43, s44, s45, s46, s47, s48);
        BA5: b8_adder port map (s42,s43,s44,s45,s46,s47,(x1 and y5), (x2 and y5), (x3 and y5),(x4 and y5),(x5 and y5),(x6 and y5),(x7 and y5), z5, s52, s53, s54, s55, s56, s57, s58);
        BA6: b8_adder port map (s52,s53,s54,s55,s56,s57,(x1 and y6), (x2 and y6), (x3 and y6),(x4 and y6),(x5 and y6),(x6 and y6),(x7 and y6), z6, s62, s63, s64, s65, s66, s67, s68);
        BA7: b8_adder port map (s62,s63,s64,s65,s66,s67,(x1 and y7), (x2 and y7), (x3 and y7),(x4 and y7),(x5 and y7),(x6 and y7),(x7 and y7), z7, z8, z9, z10, z11, z12, z13, z14);
end architecture b8_multi_logic;

-- now the actual logic for the butterfly 

entity butterfly is 
port(
    -- I'
    a1,a2,a3,a4 : in std_logic;
    a5,a6,a7,a8 : in std_logic;
    -- I''
    b1,b2,b3,b4 : in std_logic;
    b5,b6,b7,b8 : in std_logic;
    -- C' 
    c1,c2,c3,c4 : in std_logic;
    c5,c6,c7,c8 : in std_logic;
    --c''
    d1,d2,d3,d4 : in std_logic;
    d5,d6,d7,d8 : in std_logic;
    --O' 
    e1,e2,e3,e4 : in std_logic;
    e5,e6,e7,e8 : in std_logic;
    --O''
    f1,f2,f3,f4 : in std_logic;
    f5,f6,f7,f8 : in std_logic
);
end entity butterfly;

-- need to make two adders and two multipliers 
architecture bf_logic of butterfly is
    -- stage between add and multiply for O'
    signal s11, s12, s13, s14, s15, s16, s17, s18 : std_logic;
    -- stage between add and multiply for O''
    signal s21, s22, s23, s24, s25, s26, s27, s28 : std_logic;
    -- 8bit adder component 
    component b8_adder
    port (
        x1,x2,x3,x4 : in std_logic;
        x5,x6,x7,x8 : in std_logic;
        y1,y2,y3,y4 : in std_logic;
        y5,y6,y7,y8 : in std_logic;
        z1,z2,z3,z4 : out std_logic;
        z5,z6,z7,z8 : out std_logic
        );
    end component;
    -- 8bit multiplier component
    component b8_multi
    port (
        x1,x2,x3,x4 : in std_logic;
        x5,x6,x7,x8 : in std_logic;
        y1,y2,y3,y4 : in std_logic;
        y5,y6,y7,y8 : in std_logic;
        z1,z2,z3,z4 : out std_logic;
        z5,z6,z7,z8 : out std_logic
        );
    end component;
    -- pass through the two adders, then the multipliers 
    begin 
        -- input i' and i''
        BA1: ba_adder port map (a1,a2,a3,a4,a5,a6,a7,a8,b1,b2,b3,b4,b5,b6,b7,b8,s11, s12, s13, s14, s15, s16, s17, s18);
        -- input i' and -i''
        BA2: ba_adder port map (a1,a2,a3,a4,a5,a6,a7,a8,-b1,-b2,-b3,-b4,-b5,-b6,-b7,-b8,s21, s22, s23, s24, s25, s26, s27, s28);
        -- from adder 1 and c'
        BM1: ba_multi port map (s12, s13, s14, s15, s16, s17, s18, c1,c2,c3,c4,c5,c6,c7,c8, e1,e2,e3,e4,e5,e6,e7,e8);
        -- from adder 2 and c''
        BM2: ba_multi port map (s21, s22, s23, s24, s25, s26, s27, s28, d1,d2,d3,d4,d5,d6,d7,d8, f1,f2,f3,f4,f5,f6,f7,f8);
end architecture bf_logic;