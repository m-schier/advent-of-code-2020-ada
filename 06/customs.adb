with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings;               use Ada.Strings;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

package body Customs is
    function Make_Group return Question_Person_Vectors.Vector is
        Result : Question_Person_Vectors.Vector;
    begin
        -- This is probably the most stupid way to create a new vector
        return Result;
    end Make_Group;

    function Parse_Question_Person(Item: Unbounded_String) return Question_Person is
        Result  : Question_Person := (others => False);
        C       : Character;
    begin
        for I in 1 .. Length(Item) loop
            C := Element(Item, I);
            Result(Question_Range(1 + Character'Pos(C) - Character'Pos('a'))) := True;
        end loop;
        return Result;
    end Parse_Question_Person;

    function Parse_Groups return Question_Group_Vectors.Vector is
        use Ada.Containers;

        Result          : Question_Group_Vectors.Vector;
        Current_Group   : Question_Person_Vectors.Vector;
        Current_Line    : Unbounded_String;
    begin
        while not End_Of_File loop
            Get_Line(Current_Line);
            if Length(Current_Line) = 0 then
                Result.Append(Current_Group);
                Current_Group := Make_Group;
            else
                Current_Group.Append(Parse_Question_Person(Current_Line));
            end if;
        end loop;

        if Current_Group.Length > 0 then
            Result.Append(Current_Group);
        end if;

        return Result;
    end Parse_Groups;

    function Group_Union_Count(Group: Question_Person_Vectors.Vector) return Natural is
        Union   : Question_Person := (others => False);
        Result  : Natural := 0;
    begin
        for P of Group loop
            Union := Union or P;
        end loop;

        for I of Union loop
            Result := Result + Boolean'Pos(I);
        end loop;
        return Result;
    end Group_Union_Count;

    function Group_Intersection_Count(Group: Question_Person_Vectors.Vector) return Natural is
        use Ada.Containers;

        Intersection    : Question_Person := (others => True);
        Result          : Natural := 0;
    begin
        -- Intersection of empty groups should still be 0
        if Group.Length = 0 then
            return 0;
        end if;

        for P of Group loop
            Intersection := Intersection and P;
        end loop;

        for I of Intersection loop
            Result := Result + Boolean'Pos(I);
        end loop;
        return Result;
    end Group_Intersection_Count;
end Customs;