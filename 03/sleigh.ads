with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;

package Sleigh is
    use Ada.Strings.Unbounded;

    package Unbounded_Vectors is new Ada.Containers.Vectors
        (Index_Type   => Natural,
         Element_Type => Ada.Strings.Unbounded.Unbounded_String);

    use Unbounded_Vectors;

    function Check_Slope(Terrain: Unbounded_Vectors.Vector; Right: Natural; Down: Positive) return Natural;
end Sleigh;