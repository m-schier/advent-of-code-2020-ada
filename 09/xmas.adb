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

    function Find_Range(Input: Integer_Vectors.Vector; Target: UInt64) return UInt64 is
        Sum, C, Min, Max    : UInt64;
        J                   : Integer;
    begin
        for I in 0 .. Integer(Input.Length) - 1 loop
            Sum := Input.Element(I);
            Min := Sum;
            Max := Sum;
            J := I + 1;

            while Sum < Target and J < Integer(Input.Length) loop
                C := Input.Element(J);
                Sum := Sum + C;

                if C < Min then
                    Min := C;
                elsif C > Max then
                    Max := C;
                end if;

                J := J + 1;
            end loop;

            if Sum = Target then
                return Min + Max;
            end if;
        end loop;

        raise No_Solution_Error;
    end Find_Range;
end Xmas;