with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Containers.Vectors;
with Sleigh; use Sleigh;

procedure Ex1 is
    Lines : Unbounded_Vectors.Vector;
    Trees_Hit : Natural := 0;
begin
    while not End_Of_File loop
        Lines.Append(Get_Line);
    end loop;

    Trees_Hit := Check_Slope(Lines, Down => 1, Right => 3);

    Put(Item => Trees_Hit, Width => 0);
end Ex1;