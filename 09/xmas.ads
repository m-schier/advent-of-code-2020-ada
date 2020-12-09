with Ada.Containers.Vectors;

package Xmas is
    type UInt64 is mod 2**64;

    package Integer_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => UInt64);
    use Integer_Vectors;

    type Num_Array is array(Natural range <>) of UInt64;

    No_Solution_Error : exception;

    function Parse return Integer_Vectors.Vector;
    function Find_Invalid(Input: Integer_Vectors.Vector) return UInt64;
    function Find_Range(Input: Integer_Vectors.Vector; Target: UInt64) return UInt64;
end Xmas;