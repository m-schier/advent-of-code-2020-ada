with Ada.Text_IO;   use Ada.Text_IO;
with Ada.Containers.Vectors;

package body Memory is
    package Natural_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Natural);
    use Natural_Vectors;

    function Find_Nth(N: Natural) return Natural is
        use Ada.Containers;

        Last_Occurrence : Natural_Vectors.Vector;
        Spoken          : Natural := 0;
        Last_Spoken     : Natural;
        Last_Time       : Natural;
        Can_Read        : Boolean := True;
    begin
        for I in 1 .. N loop
            Last_Spoken := Spoken;

            while Last_Occurrence.Last_Index < Last_Spoken loop
                Last_Occurrence.Append(0);
            end loop;

            -- Once we reach end of file no longer check, turns out to be a rather large improvement
            Can_Read := Can_Read and then not End_Of_File;
            if Can_Read then
                Spoken := Natural'Value(Get_Line);
            else
                Last_Time := Last_Occurrence.Element(Last_Spoken);

                if Last_Time = 0 then
                    -- Word was not spoken before
                    Spoken := 0;
                else
                    -- Word was spoken before
                    Spoken := I - 1 - Last_Time;
                end if;
            end if;

            if I > 1 then
                Last_Occurrence.Replace_Element(Last_Spoken, I - 1);
            end if;
        end loop;

        return Spoken;
    end Find_Nth;
end Memory;