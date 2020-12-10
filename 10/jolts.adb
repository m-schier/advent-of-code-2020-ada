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

    type Optional_Natural (Has_Element : Boolean := False) is record
        case Has_Element is
            when False => Null;
            when True  => Element : UInt64;
        end case;
    end record;

    package ON_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Optional_Natural);
    use ON_Vectors;

    function Solutions_Find_Calculate(Input: Natural_Vectors.Vector; Index: Natural; Cache: in out ON_Vectors.Vector) return UInt64;

    function Solutions_Find_Cached(Input: Natural_Vectors.Vector; Index: Natural; Cache: in out ON_Vectors.Vector) return UInt64 is
        Cache_Value : Optional_Natural;
    begin
        Cache_Value := Cache.Element(Index);

        case Cache_Value.Has_Element is
            when True => return Cache_Value.Element;
            when False => 
                Cache_Value := Optional_Natural'(Has_Element => True, Element => Solutions_Find_Calculate(Input, Index, Cache)); 
                Cache.Replace_Element(Index, Cache_Value);
                return Cache_Value.Element;
        end case;
    end Solutions_Find_Cached;

    function Solutions_Find_Calculate(Input: Natural_Vectors.Vector; Index: Natural; Cache: in out ON_Vectors.Vector) return UInt64 is
        Current : Natural;
        Count   : UInt64 := 0;
    begin
        if Index = Input.Last_Index then
            return 1;
        end if;

        Current := Input.Element(Index);

        for I in Index + 1 .. Input.Last_Index loop
            if Input.Element(I) > Current + 3 then
                return Count;
            else
                Count := Count + Solutions_Find_Cached(Input, I, Cache);
            end if;
        end loop;

        return Count;
    end Solutions_Find_Calculate;

    function Solutions(Input: in out Natural_Vectors.Vector) return UInt64 is
        Cache : ON_Vectors.Vector;
    begin
        Preprocess(Input);
        
        for I in Input.First_Index .. Input.Last_Index loop
            Cache.Append(Optional_Natural'(Has_Element => False));
        end loop;

        return Solutions_Find_Cached(Input, 0, Cache);
    end Solutions;
end Jolts;