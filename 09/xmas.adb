with Ada.Text_IO; use Ada.Text_IO;

package body Xmas is
    function Parse return Integer_Vectors.Vector is
        Result : Integer_Vectors.Vector;
    begin
        while not End_Of_File loop
           Result.Append(UInt64'Value(Get_Line));
        end loop;

        return Result;
    end Parse;

    function Valid_For_Buffer(Input: Integer_Vectors.Vector; Index: Integer) return Boolean is
        X : UInt64;
    begin
        X := Input.Element(Index);

        for I in Index-25 .. Index-1 loop
            for J in I+1 .. Index-1 loop
                if Input.Element(I) + Input.Element(J) = X then
                    return True;
                end if;
            end loop;
        end loop;

        return False;
    end Valid_For_Buffer;

    function Find_Invalid(Input: Integer_Vectors.Vector) return UInt64 is
    begin
        for I in 25 .. Integer(Input.Length) - 1 loop
            if not Valid_For_Buffer(Input, I) then
                return Input.Element(I);
            end if;
        end loop;

        raise No_Solution_Error;
    end Find_Invalid;

    -- @Function: Find_Sum_Window
    -- @Description: Find the consecutive range on the vector whose sum equals target in linear time complexity
    function Find_Sum_Window(Input: Integer_Vectors.Vector; Target: UInt64; Low: out Integer; High: out Integer) return Boolean is
        Sum : UInt64 := 0;
    begin
        -- Initialize with empty window at first element
        Low  := 0;
        High := -1;

        while Low < Integer(Input.Length) loop
            -- While sum in window too small or window empty, increase window
            while Low > High or Sum < Target loop
                High := High + 1;

                if High >= Integer(Input.Length) then
                    -- Immediately abort if the sum is too small but we can't enlarge
                    return False;
                end if;

                Sum := Sum + Input.Element(High);
            end loop;

            -- While sum in window too large and able, shrink window
            while Sum > Target and Low <= High loop
                Sum := Sum - Input.Element(Low);
                Low := Low + 1;
            end loop;

            if Sum = Target then
                return True;
            end if;
        end loop;

        return False;
    end Find_Sum_Window;

    function Find_Range(Input: Integer_Vectors.Vector; Target: UInt64) return UInt64 is
        C, Min, Max : UInt64;
        Low, High   : Integer;
    begin
        if not Find_Sum_Window(Input, Target, Low, High) then
            raise No_Solution_Error;
        end if;

        Min := Input.Element(Low);
        Max := Min;

        for I in Low + 1 .. High loop
            C := Input.Element(I);

            if C < Min then
                Min := C;
            elsif C > Max then
                Max := C;
            end if;
        end loop;

        return Min + Max;
    end Find_Range;
end Xmas;