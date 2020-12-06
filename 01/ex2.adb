with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Containers.Vectors;

procedure Ex2 is
    package Integer_Vectors is new Ada.Containers.Vectors
        (Index_Type   => Natural,
         Element_Type => Integer);

    use Integer_Vectors;

    Number, Num1, Num2, Num3    : Integer;
    Numbers                     : Integer_Vectors.Vector;
begin
    while not End_Of_File loop
        Get(Number);
        Numbers.Append(Number);
    end loop;

    for Index1 in Numbers.First_Index .. Numbers.Last_Index loop
        for Index2 in Index1 + 1 .. Numbers.Last_Index loop
            for Index3 in Index2 + 1 .. Numbers.Last_Index loop
                Num1 := Numbers.Element(Index1);
                Num2 := Numbers.Element(Index2);
                Num3 := Numbers.Element(Index3);
                if Num1 + Num2 + Num3 = 2020 then
                    Put(Item => Num1 * Num2 * Num3, Width => 0);
                    return;
                end if;
            end loop;
       end loop;
    end loop;
end Ex2;