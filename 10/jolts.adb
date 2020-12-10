with Ada.Text_IO; use Ada.Text_IO;

package body Jolts is
    function Parse return Natural_Vectors.Vector is
        Result : Natural_Vectors.Vector;
    begin
        while not End_Of_File loop
            Result.Append(Natural'Value(Get_Line));
        end loop;

        return Result;
    end Parse;

    procedure Preprocess(Input: in out Natural_Vectors.Vector) is
        package IV_Sorting is new Natural_Vectors.Generic_Sorting;
    begin
        -- 0 Jolts output implicit
        Input.Append(0);

        IV_Sorting.Sort(Input);

        -- Device implicitly 3 above highest adapter
        Input.Append(Input.Element(Input.Last_Index) + 3);
    end Preprocess;

    function Differences(Input: in out Natural_Vectors.Vector) return Natural is
        Ones    : Natural := 0;
        Threes  : Natural := 0;
        Diff    : Natural;
    begin
        Preprocess(Input);

        for I in Input.First_Index .. Input.Last_Index - 1 loop
            Diff := Input.Element(I + 1) - Input.Element(I);

            if Diff = 1 then
                Ones := Ones + 1;
            elsif Diff = 3 then
                Threes := Threes + 1;
            end if;
        end loop;

        return Ones * Threes;
    end Differences;

    package UInt64_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => UInt64);
    use UInt64_Vectors;

    function Solutions(Input: in out Natural_Vectors.Vector) return UInt64 is
        Cache : UInt64_Vectors.Vector;
        Count : UInt64;
    begin
        Preprocess(Input);
        
        Cache.Reserve_Capacity(Input.Length);

        -- For alle entries before output, combinations unknown
        for I in Input.First_Index .. Input.Last_Index - 1 loop
            Cache.Append(0);
        end loop;

        -- Output entry always has 1 solution
        Cache.Append(1);

        -- Loop entries before output in reverse
        for I in reverse Input.First_Index .. Input.Last_Index - 1 loop
            Count := 0;

            for J in I + 1 .. Input.Last_Index loop
                exit when Input.Element(I) + 3 < Input.Element(J);
                Count := Count + Cache.Element(J);
            end loop;
            Cache.Replace_Element(I, Count);
        end loop;

        return Cache.Element(0);
    end Solutions;
end Jolts;