with Customs;                   use Customs;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;

procedure Ex2 is
    Groups : Question_Group_Vectors.Vector;
    Result : Natural := 0;
begin
    Groups := Parse_Groups;

    for G of Groups loop
        Result := Result + Group_Intersection_Count(G);
    end loop;
    Put(Item => Result, Width => 0);
end Ex2;