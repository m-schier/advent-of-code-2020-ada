package Docking is
    Parse_Error : exception;

    type UInt36 is mod 2**36;
    type UInt64 is mod 2**64;

    function Run return UInt64;
    function Run_V2 return UInt64;
end Docking;