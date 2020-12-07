with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings;               use Ada.Strings;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

package body Customs is
    function Parse_Question_Person(Item: Unbounded_String) return Question_Person is
        Result  : Question_Person := (others => False);
        C       : Character;
    begin
        for I in 1 .. Length(Item) loop
            C := Element(Item, I);
            Result(Question_Range(Question_Person'First + Character'Pos(C) - Character'Pos('a'))) := True;
        end loop;
        return Result;
    end Parse_Question_Person;

    function Question_Count(Group: Question_Person) return Natural is
        Result : Natural := 0;
    begin
        for I of Group loop
            Result := Result + Boolean'Pos(I);
        end loop;
        return Result;
    end Question_Count;
end Customs;