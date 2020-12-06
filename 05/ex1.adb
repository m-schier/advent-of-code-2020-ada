with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Decode_Binary;

procedure Ex1 is
    Current_Line                : Unbounded_String;
    Current_Row, Current_Column : Natural;
    Seat_ID                     : Natural;
    Seat_ID_Max                 : Natural := 0;
begin
    while not End_Of_File loop
        Get_Line(Current_Line);
        Current_Row := Decode_Binary(Item => Slice(Current_Line, 1, 7), High_Char => 'B');
        Current_Column := Decode_Binary(Item => Slice(Current_Line, 8, 10), High_Char => 'R');

        Seat_ID := Current_Row * 8 + Current_Column;

        if Seat_ID > Seat_ID_Max then
            Seat_ID_Max := Seat_ID;
        end if;
        -- Put_Line(Current_Line & " " & Current_Row'Image & ", " & Current_Column'Image);
    end loop;

    Put(Item => Seat_ID_Max, Width => 0);
end Ex1;