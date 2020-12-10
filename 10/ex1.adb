with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Jolts;                 use Jolts;

procedure Ex1 is
    Input : Natural_Vectors.Vector;
begin
    Input := Parse;
    Put(Item => Differences(Input), Width => 0);
end Ex1;