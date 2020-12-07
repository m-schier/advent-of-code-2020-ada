with Customs;                   use Customs;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

procedure Ex2 is
    Result          : Natural := 0;
    Current_Line    : Unbounded_String;
    Current_Group   : Question_Person := (others => True);
begin
    while not End_Of_File loop
        Get_Line(Current_Line);

        if Length(Current_Line) /= 0 then
            Current_Group := Current_Group and Parse_Question_Person(Current_Line);
        end if;

        if Length(Current_Line) = 0 or End_Of_File then
            Result := Result + Question_Count(Current_Group);
            Current_Group := (others => True);
        end if;

    end loop;

    Put(Item => Result, Width => 0);
end Ex2;