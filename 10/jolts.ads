with Ada.Containers.Vectors;

package Jolts is
    type UInt64 is mod 2**64;

    package Natural_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Natural);
    use Natural_Vectors;

    function Parse return Natural_Vectors.Vector;
    function Differences(Input: in out Natural_Vectors.Vector) return Natural;
    function Solutions(Input: in out Natural_Vectors.Vector) return UInt64;
end Jolts;