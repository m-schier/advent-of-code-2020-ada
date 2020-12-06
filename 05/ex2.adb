with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Decode_Binary;

procedure Ex2 is
    type Seat_Range is range 0 .. 2**10 - 1;

    Current_Line                : Unbounded_String;
    Current_Row, Current_Column : Natural;

    Seats_Taken                 : Array(Seat_Range) of Boolean := (others => False);
    Encountered_Seat_Start      : Boolean := False;
begin
    while not End_Of_File loop
        Get_Line(Current_Line);
        Current_Row := Decode_Binary(Item => Slice(Current_Line, 1, 7), High_Char => 'B');
        Current_Column := Decode_Binary(Item => Slice(Current_Line, 8, 10), High_Char => 'R');

        Seats_Taken(Seat_Range(Current_Row * 8 + Current_Column)) := True;
    end loop;

    for Seat in Seat_Range loop
        if Seats_Taken(Seat) then
            Encountered_Seat_Start := True;
        else
            if Encountered_Seat_Start then 
                Put(Item => Integer(Seat), Width => 0);
                return;
            end if;
        end if;
    end loop;
end Ex2;