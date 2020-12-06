with Ada.Text_IO; use Ada.Text_IO;

package body Sleigh is
    function Check_Slope(Terrain: Unbounded_Vectors.Vector; Right: Natural; Down: Positive) return Natural is
        use Ada.Containers;

        RepeatLength    : Natural;
        X_Offset        : Natural := 0;
        Trees_Hit       : Natural := 0;
        Y_High          : Natural;
        Line            : Unbounded_String;
    begin
        RepeatLength := Length(Terrain.Element(1));

        Y_High := Natural(Terrain.Length - 1) / Down;
        
        for I in 0 .. Y_High loop
            Line := Terrain.Element(I * Down);
            if Element(Line, (X_Offset mod RepeatLength) + 1) = '#' then
                Trees_Hit := Trees_Hit + 1;
            end if;
            X_Offset := X_Offset + Right;
        end loop;

        return Trees_Hit;
    end Check_Slope;
end Sleigh;