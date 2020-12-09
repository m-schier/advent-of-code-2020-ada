with Xmas;                  use Xmas;
with Ada.Text_IO;           use Ada.Text_IO;

procedure Ex2 is
    N : Integer_Vectors.Vector;
begin
    N := Parse;
    Put_Line(Find_Range(N, Find_Invalid(N))'Image);
end Ex2;