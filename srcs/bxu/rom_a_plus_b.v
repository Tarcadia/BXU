// 100E                     // s = 0
// 000E

// 001E                     // s = 1
// 000A                     // [s] = 0
// 000B                     // in >> [s]
// 2003                     // out << [s]
// 8302                     // [s] - '0'

// 002E                     // s = 2
// 000A                     // [s] = 0
// 000B                     // in >> [s]
// 2003                     // out << [s]
// 8302                     // [s] - '0'

// 003E                     // s = 3
// 000A                     // [s] = 0
// 000B                     // in >> [s]
// 2003                     // out << [s]
// 8302                     // [s] - '0'

//                          // read_return_0:
// 000E                     //     s = 0
// 000B                     //     in >> [s]
// 80D2                     //     [s] - '\r'
// 004D                     //     jz read_return_0_end
// 0032                     //     [s] + '\r' - '\n'
// 002D                     //     jz read_return_0_end
// 8061                     //     jmp read_return_0
//                          // read_return_0_end:

// 00D3                     // out << '\r'
// 00A3                     // out << '\n'
// 02B3                     // out << '+'

///////////////////////////////////////////////////////////////

// 004E                     // s = 4
// 000A                     // [s] = 0
// 000B                     // in >> [s]
// 2003                     // out << [s]
// 8302                     // [s] - '0'

// 005E                     // s = 5
// 000A                     // [s] = 0
// 000B                     // in >> [s]
// 2003                     // out << [s]
// 8302                     // [s] - '0'

// 006E                     // s = 6
// 000A                     // [s] = 0
// 000B                     // in >> [s]
// 2003                     // out << [s]
// 8302                     // [s] - '0'

//                          // read_return_1:
// 000E                     //     s = 0
// 000B                     //     in >> [s]
// 80D2                     //     [s] - '\r'
// 004D                     //     jz read_return_1_end
// 0032                     //     [s] + '\r' - '\n'
// 002D                     //     jz read_return_1_end
// 8061                     //     jmp read_return_1
//                          // read_return_1_end:

//////////////////////////////////////////////////////////////

// 00D3                     // out << '\r'
// 00A3                     // out << '\n'
// 03D3                     // out << '='

// 001E                     // s = 1
// 002E                     // s = 2
// 003E                     // s = 3
// 004E                     // s = 4
// 005E                     // s = 5
// 006E                     // s = 6

// 007E                     // s = 7 // 累加
// 000A                     // [s] = 0

// 008E                     // s = 8 // 进位
// 000A                     // [s] = 0

// 009E                     // s = 9 // 个位
// 000A                     // [s] = 0

// 00AE                     // s = 10 // 十位
// 000A                     // [s] = 0

// 00BE                     // s = 11 // 百位
// 000A                     // [s] = 0

//////////////////////////////////////////////////////////////

//                          // loop_add_00:
// 003E                     //     s = 3
// 00CD                     //     jz loop_add_01
// 8012                     //     [s] - 1
// 007E                     //     s = 7
// 0012                     //     [s] + 1

// 80A2                     //     [s] - 10
// 0055                     //     jnz next
// 008E                     //     s = 8
// 0012                     //     [s] + 1
// 007E                     //     s = 7
// 80A1                     //     jmp loop_add_00
//                          // next:
// 00A2                     //     [s] + 10
// 80C1                     //     jmp loop_add_00

//                          // loop_add_01:
// 006E                     //     s = 6
// 00CD                     //     jz loop_add_0_end
// 8012                     //     [s] - 1
// 007E                     //     s = 7
// 0012                     //     [s] + 1

// 80A2                     //     [s] - 10
// 0055                     //     jnz next
// 008E                     //     s = 8
// 0012                     //     [s] + 1
// 007E                     //     s = 7
// 80A1                     //     jmp loop_add_01
//                          // next:
// 00A2                     //     [s] + 10
// 80C1                     //     jmp loop_add_01

//                          // loop_add_0_end:

///////////////////////////////////////////////////////////////

//                          // loop_move_00:
// 007E                     //     s = 7
// 009D                     //     jz loop_move_01
// 8012                     //     [s] - 1
// 003E                     //     s = 3
// 0012                     //     [s] + 1
// 009E                     //     s = 9
// 0012                     //     [s] + 1
// 8091                     //     jmp loop_move_00

//                          // loop_move_01:
// 008E                     //     s = 8
// 005D                     //     jz loop_move_1_end
// 8012                     //     [s] - 1
// 007E                     //     s = 7
// 0012                     //     [s] + 1
// 8051                     //     jmp loop_move_01

//                          // loop_move_0_end:

/////////////////////////////////////////////////////////////////



//                          // loop_add_10:
// 002E                     //     s = 2
// 00CD                     //     jz loop_add_11
// 8012                     //     [s] - 1
// 007E                     //     s = 7
// 0012                     //     [s] + 1

// 80A2                     //     [s] - 10
// 0055                     //     jnz next
// 008E                     //     s = 8
// 0012                     //     [s] + 1
// 007E                     //     s = 7
// 80A1                     //     jmp loop_add_10
//                          // next:
// 00A2                     //     [s] + 10
// 80C1                     //     jmp loop_add_10

//                          // loop_add_11:
// 005E                     //     s = 5
// 00CD                     //     jz loop_add_1_end
// 8012                     //     [s] - 1
// 007E                     //     s = 7
// 0012                     //     [s] + 1

// 80A2                     //     [s] - 10
// 0055                     //     jnz next
// 008E                     //     s = 8
// 0012                     //     [s] + 1
// 007E                     //     s = 7
// 80A1                     //     jmp loop_add_11
//                          // next:
// 00A2                     //     [s] + 10
// 80C1                     //     jmp loop_add_11

//                          // loop_add_1_end:

//////////////////////////////////////////////////////////////////

//                          // loop_move_10:
// 007E                     //     s = 7
// 009D                     //     jz loop_move_11
// 8012                     //     [s] - 1
// 002E                     //     s = 2
// 0012                     //     [s] + 1
// 00AE                     //     s = 10
// 0012                     //     [s] + 1
// 8091                     //     jmp loop_move_10

//                          // loop_move_11:
// 008E                     //     s = 8
// 005D                     //     jz loop_move_1_end
// 8012                     //     [s] - 1
// 007E                     //     s = 7
// 0012                     //     [s] + 1
// 8051                     //     jmp loop_move_11

//                          // loop_move_1_end:

///////////////////////////////////////////////////////////////////

//                          // loop_add_20:
// 001E                     //     s = 1
// 00CD                     //     jz loop_add_21
// 8012                     //     [s] - 1
// 007E                     //     s = 7
// 0012                     //     [s] + 1

// 80A2                     //     [s] - 10
// 0055                     //     jnz next
// 008E                     //     s = 8
// 0012                     //     [s] + 1
// 007E                     //     s = 7
// 80A1                     //     jmp loop_add_20
//                          // next:
// 00A2                     //     [s] + 10
// 80C1                     //     jmp loop_add_20

//                          // loop_add_21:
// 004E                     //     s = 4
// 00CD                     //     jz loop_add_2_end
// 8012                     //     [s] - 1
// 007E                     //     s = 7
// 0012                     //     [s] + 1

// 80A2                     //     [s] - 10
// 0055                     //     jnz next
// 008E                     //     s = 8
// 0012                     //     [s] + 1
// 007E                     //     s = 7
// 80A1                     //     jmp loop_add_21
//                          // next:
// 00A2                     //     [s] + 10
// 80C1                     //     jmp loop_add_21

//                          // loop_add_2_end:

/////////////////////////////////////////////////////////////////////

//                          // loop_move_20:
// 007E                     //     s = 7
// 009D                     //     jz loop_move_21
// 8012                     //     [s] - 1
// 001E                     //     s = 1
// 0012                     //     [s] + 1
// 00BE                     //     s = 11
// 0012                     //     [s] + 1
// 8091                     //     jmp loop_move_20

//                          // loop_move_21:
// 008E                     //     s = 8
// 005D                     //     jz loop_move_2_end
// 8012                     //     [s] - 1
// 007E                     //     s = 7
// 0012                     //     [s] + 1
// 8051                     //     jmp loop_move_21

//                          // loop_move_2_end:


///////////////////////////////////////////////////////////////////////

// 007E                     // s = 7
// 0302                     // [s] + '0'
// 2003                     // out << [s]

// 00BE                     // s = 11
// 0302                     // [s] + '0'
// 2003                     // out << [s]

// 00AE                     // s = 10
// 0302                     // [s] + '0'
// 2003                     // out << [s]

// 009E                     // s = 9
// 0302                     // [s] + '0'
// 2003                     // out << [s]


// 00D3                     // out << '\r'
// 00A3                     // out << '\n'


////////////////////////////////////////////////////////////////////////

// 000E                     // s = 0
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1
// 0016                     // s + 1

// 0009                     // jmp 0

////////////////////////////////////////////////////////////////////////









`timescale 1ns / 1ps

module rom_a_plus_b
#(
    parameter DATA_BITWIDTH = 8,
    parameter ADDR_BITWIDTH = 16
)
(
    input   [ADDR_BITWIDTH-1:0] addr_rd,
    output  [DATA_BITWIDTH-1:0] data_rd
);

    wire [DATA_BITWIDTH-1:0] data [0:512];
    assign data_rd = data[addr_rd];

    // init
    assign data[16'H0000]   = 16'H_100E;    // s = 0
    assign data[16'H0001]   = 16'H_000E;    // s = 0
    assign data[16'H0002]   = 16'H_001E;    // s = 1
    assign data[16'H0003]   = 16'H_000A;    // [s] = 0
    assign data[16'H0004]   = 16'H_000B;    // in >> [s]
    assign data[16'H0005]   = 16'H_2003;    // out << [s]
    assign data[16'H0006]   = 16'H_8302;    // [s] - '0'
    assign data[16'H0007]   = 16'H_002E;    // s = 2
    assign data[16'H0008]   = 16'H_000A;    // [s] = 0
    assign data[16'H0009]   = 16'H_000B;    // in >> [s]
    assign data[16'H000A]   = 16'H_2003;    // out << [s]
    assign data[16'H000B]   = 16'H_8302;    // [s] - '0'
    assign data[16'H000C]   = 16'H_003E;    // s = 3
    assign data[16'H000D]   = 16'H_000A;    // [s] = 0
    assign data[16'H000E]   = 16'H_000B;    // in >> [s]
    assign data[16'H000F]   = 16'H_2003;    // out << [s]
    assign data[16'H0010]   = 16'H_8302;    // [s] - '0'
    // read_return_0:
    assign data[16'H0011]   = 16'H_000E;    // s = 0
    assign data[16'H0012]   = 16'H_000B;    // in >> [s]
    assign data[16'H0013]   = 16'H_80D2;    // [s] - '\r'
    assign data[16'H0014]   = 16'H_004D;    // jz read_return_0_end
    assign data[16'H0015]   = 16'H_0032;    // [s] + '\r' - '\n'
    assign data[16'H0016]   = 16'H_002D;    // jz read_return_0_end
    assign data[16'H0017]   = 16'H_8061;    // jmp read_return_0
    // read_return_0_end:

    assign data[16'H001A]   = 16'H_00D3;    // out << '\r'
    assign data[16'H001B]   = 16'H_00A3;    // out << '\n'
    assign data[16'H001C]   = 16'H_02B3;    // out << '+'

    ////////////////////////////////////////////////////////

    assign data[16'H0020]   = 16'H_004E;
    assign data[16'H0021]   = 16'H_000A;
    assign data[16'H0022]   = 16'H_000B;
    assign data[16'H0023]   = 16'H_2003;
    assign data[16'H0024]   = 16'H_8302;
    assign data[16'H0025]   = 16'H_005E;
    assign data[16'H0026]   = 16'H_000A;
    assign data[16'H0027]   = 16'H_000B;
    assign data[16'H0028]   = 16'H_2003;
    assign data[16'H0029]   = 16'H_8302;
    assign data[16'H002A]   = 16'H_006E;
    assign data[16'H002B]   = 16'H_000A;
    assign data[16'H002C]   = 16'H_000B;
    assign data[16'H002D]   = 16'H_2003;
    assign data[16'H002E]   = 16'H_8302;

    // read_return_1:
    assign data[16'H0030]   = 16'H_000E;
    assign data[16'H0031]   = 16'H_000B;
    assign data[16'H0032]   = 16'H_80D2;
    assign data[16'H0033]   = 16'H_004D;
    assign data[16'H0034]   = 16'H_0032;
    assign data[16'H0035]   = 16'H_002D;
    assign data[16'H0036]   = 16'H_8061;
    // read_return_1_end:

    ////////////////////////////////////////////////////////

    assign data[16'H0037]   = 16'H_00D3;
    assign data[16'H0038]   = 16'H_00A3;
    assign data[16'H0039]   = 16'H_03D3;

    assign data[16'H003A]   = 16'H_001E;
    assign data[16'H003B]   = 16'H_002E;
    assign data[16'H003C]   = 16'H_003E;
    assign data[16'H003D]   = 16'H_004E;
    assign data[16'H003E]   = 16'H_005E;
    assign data[16'H003F]   = 16'H_006E;

    assign data[16'H0040]   = 16'H_007E;
    assign data[16'H0041]   = 16'H_000A;
    assign data[16'H0042]   = 16'H_008E;
    assign data[16'H0043]   = 16'H_000A;
    assign data[16'H0044]   = 16'H_009E;
    assign data[16'H0045]   = 16'H_000A;
    assign data[16'H0046]   = 16'H_00AE;
    assign data[16'H0047]   = 16'H_000A;
    assign data[16'H0048]   = 16'H_00BE;
    assign data[16'H0049]   = 16'H_000A;

    ////////////////////////////////////////////////////////////
    // loop_add_00:
    assign data[16'H0050]   = 16'H_003E;
    assign data[16'H0051]   = 16'H_00CD;
    assign data[16'H0052]   = 16'H_8012;
    assign data[16'H0053]   = 16'H_007E;
    assign data[16'H0054]   = 16'H_0012;
    assign data[16'H0055]   = 16'H_80A2;
    assign data[16'H0056]   = 16'H_0055;
    assign data[16'H0057]   = 16'H_008E;
    assign data[16'H0058]   = 16'H_0012;
    assign data[16'H0059]   = 16'H_007E;
    assign data[16'H005A]   = 16'H_80A1;
    assign data[16'H005B]   = 16'H_00A2;
    assign data[16'H005C]   = 16'H_80C1;
    // loop_add_01:
    assign data[16'H0060]   = 16'H_006E;
    assign data[16'H0061]   = 16'H_00CD;
    assign data[16'H0062]   = 16'H_8012;
    assign data[16'H0063]   = 16'H_007E;
    assign data[16'H0064]   = 16'H_0012;
    assign data[16'H0065]   = 16'H_80A2;
    assign data[16'H0066]   = 16'H_0055;
    assign data[16'H0067]   = 16'H_008E;
    assign data[16'H0068]   = 16'H_0012;
    assign data[16'H0069]   = 16'H_007E;
    assign data[16'H006A]   = 16'H_80A1;
    assign data[16'H006B]   = 16'H_00A2;
    assign data[16'H006C]   = 16'H_80C1;
    // loop_add_0_end:

    ////////////////////////////////////////////////////////////

    // loop_move_00:
    assign data[16'H0070]   = 16'H_007E;
    assign data[16'H0071]   = 16'H_009D;
    assign data[16'H0072]   = 16'H_8012;
    assign data[16'H0075]   = 16'H_003E;
    assign data[16'H0076]   = 16'H_0012;
    assign data[16'H0077]   = 16'H_009E;
    assign data[16'H0078]   = 16'H_0012;
    assign data[16'H0079]   = 16'H_8091;
    
    // loop_move_01:
    assign data[16'H0080]   = 16'H_008E;
    assign data[16'H0081]   = 16'H_005D;
    assign data[16'H0082]   = 16'H_8012;
    assign data[16'H0083]   = 16'H_007E;
    assign data[16'H0084]   = 16'H_0012;
    assign data[16'H0085]   = 16'H_8051;
    // loop_move_0_end:

    //////////////////////////////////////////////////////////////


    // loop_add_10:
    assign data[16'H0090]   = 16'H_002E;
    assign data[16'H0091]   = 16'H_00CD;
    assign data[16'H0092]   = 16'H_8012;
    assign data[16'H0093]   = 16'H_007E;
    assign data[16'H0094]   = 16'H_0012;
    assign data[16'H0095]   = 16'H_80A2;
    assign data[16'H0096]   = 16'H_0055;
    assign data[16'H0097]   = 16'H_008E;
    assign data[16'H0098]   = 16'H_0012;
    assign data[16'H0099]   = 16'H_007E;
    assign data[16'H009A]   = 16'H_80A1;
    assign data[16'H009B]   = 16'H_00A2;
    assign data[16'H009C]   = 16'H_80C1;

    // loop_add_11:
    assign data[16'H00A0]   = 16'H_005E;
    assign data[16'H00A1]   = 16'H_00CD;
    assign data[16'H00A2]   = 16'H_8012;
    assign data[16'H00A3]   = 16'H_007E;
    assign data[16'H00A4]   = 16'H_0012;
    assign data[16'H00A5]   = 16'H_80A2;
    assign data[16'H00A6]   = 16'H_0055;
    assign data[16'H00A7]   = 16'H_008E;
    assign data[16'H00A8]   = 16'H_0012;
    assign data[16'H00A9]   = 16'H_007E;
    assign data[16'H00AA]   = 16'H_80A1;
    assign data[16'H00AB]   = 16'H_00A2;
    assign data[16'H00AC]   = 16'H_80C1;
    // loop_add_1_end:

    /////////////////////////////////////////////////////////////

    // loop_move_10:
    assign data[16'H00B0]   = 16'H_007E;
    assign data[16'H00B1]   = 16'H_009D;
    assign data[16'H00B2]   = 16'H_8012;
    assign data[16'H00B5]   = 16'H_002E;
    assign data[16'H00B6]   = 16'H_0012;
    assign data[16'H00B7]   = 16'H_00AE;
    assign data[16'H00B8]   = 16'H_0012;
    assign data[16'H00B9]   = 16'H_8091;
    
    // loop_move_11:
    assign data[16'H00C0]   = 16'H_008E;
    assign data[16'H00C1]   = 16'H_005D;
    assign data[16'H00C2]   = 16'H_8012;
    assign data[16'H00C3]   = 16'H_007E;
    assign data[16'H00C4]   = 16'H_0012;
    assign data[16'H00C5]   = 16'H_8051;
    
    // loop_move_1_end:

    //////////////////////////////////////////////////////////////

    // loop_add_20:
    assign data[16'H00D0]   = 16'H_001E;
    assign data[16'H00D1]   = 16'H_00CD;
    assign data[16'H00D2]   = 16'H_8012;
    assign data[16'H00D3]   = 16'H_007E;
    assign data[16'H00D4]   = 16'H_0012;
    assign data[16'H00D5]   = 16'H_80A2;
    assign data[16'H00D6]   = 16'H_0055;
    assign data[16'H00D7]   = 16'H_008E;
    assign data[16'H00D8]   = 16'H_0012;
    assign data[16'H00D9]   = 16'H_007E;
    assign data[16'H00DA]   = 16'H_80A1;
    assign data[16'H00DB]   = 16'H_00A2;
    assign data[16'H00DC]   = 16'H_80C1;
    
    // loop_add_21:
    assign data[16'H00E0]   = 16'H_004E;
    assign data[16'H00E1]   = 16'H_00CD;
    assign data[16'H00E2]   = 16'H_8012;
    assign data[16'H00E3]   = 16'H_007E;
    assign data[16'H00E4]   = 16'H_0012;
    assign data[16'H00E5]   = 16'H_80A2;
    assign data[16'H00E6]   = 16'H_0055;
    assign data[16'H00E7]   = 16'H_008E;
    assign data[16'H00E8]   = 16'H_0012;
    assign data[16'H00E9]   = 16'H_007E;
    assign data[16'H00EA]   = 16'H_80A1;
    assign data[16'H00EB]   = 16'H_00A2;
    assign data[16'H00EC]   = 16'H_80C1;
    // loop_add_2_end:

    //////////////////////////////////////////////////////////////////

    // loop_move_20:

    assign data[16'H00F0]   = 16'H_007E;
    assign data[16'H00F1]   = 16'H_009D;
    assign data[16'H00F2]   = 16'H_8012;
    assign data[16'H00F5]   = 16'H_001E;
    assign data[16'H00F6]   = 16'H_0012;
    assign data[16'H00F7]   = 16'H_00BE;
    assign data[16'H00F8]   = 16'H_0012;
    assign data[16'H00F9]   = 16'H_8091;

    // loop_move_21:

    assign data[16'H0100]   = 16'H_008E;
    assign data[16'H0101]   = 16'H_005D;
    assign data[16'H0102]   = 16'H_8012;
    assign data[16'H0103]   = 16'H_007E;
    assign data[16'H0104]   = 16'H_0012;
    assign data[16'H0105]   = 16'H_8051;

    // loop_move_2_end:

    /////////////////////////////////////////////////////////////////

    assign data[16'H0110]   = 16'H_007E;
    assign data[16'H0111]   = 16'H_0302;
    assign data[16'H0112]   = 16'H_2003;

    assign data[16'H0113]   = 16'H_00BE;
    assign data[16'H0114]   = 16'H_0302;
    assign data[16'H0115]   = 16'H_2003;

    assign data[16'H0116]   = 16'H_00AE;
    assign data[16'H0117]   = 16'H_0302;
    assign data[16'H0118]   = 16'H_2003;

    assign data[16'H0119]   = 16'H_009E;
    assign data[16'H011A]   = 16'H_0302;
    assign data[16'H011B]   = 16'H_2003;

    assign data[16'H011C]   = 16'H_00D3;
    assign data[16'H011D]   = 16'H_00A3;

    ////////////////////////////////////////////////////////////////
    
    assign data[16'H0120]   = 16'H_000E;
    assign data[16'H0121]   = 16'H_0016;
    assign data[16'H0122]   = 16'H_0016;
    assign data[16'H0123]   = 16'H_0016;
    assign data[16'H0124]   = 16'H_0016;
    assign data[16'H0125]   = 16'H_0016;
    assign data[16'H0126]   = 16'H_0016;
    assign data[16'H0127]   = 16'H_0016;
    assign data[16'H0128]   = 16'H_0016;
    assign data[16'H0129]   = 16'H_0016;
    assign data[16'H012A]   = 16'H_0016;
    assign data[16'H012B]   = 16'H_0016;
    assign data[16'H012C]   = 16'H_0016;
    assign data[16'H012D]   = 16'H_0016;
    assign data[16'H012E]   = 16'H_0009;
    assign data[16'H012F]   = 16'H_0009;

endmodule
