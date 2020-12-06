with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Containers.Vectors;
with Sleigh; use Sleigh;

procedure Ex2 is
    Lines : Unbounded_Vectors.Vector;
    Trees_Hit : Natural := 0;
begin
    while not End_Of_File loop
        Lines.Append(Get_Line);
    end loop;

    Trees_Hit := Check_Slope(Lines, Right => 1, Down => 1)
        * Check_Slope(Lines, Right => 3, Down => 1)
        * Check_Slope(Lines, Right => 5, Down => 1)
        * Check_Slope(Lines, Right => 7, Down => 1)
        * Check_Slope(Lines, Right => 1, Down => 2);

    Put(Item => Trees_Hit, Width => 0);
end Ex2;