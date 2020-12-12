with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Jolts;                 use Jolts;

procedure Ex2 is
    package UInt64_TIO is new Ada.Text_IO.Modular_IO(UInt64);

    Input : Natural_Vectors.Vector;
begin
    Input := Parse;
    UInt64_TIO.Put(Solutions(Input), Width => 0);
end Ex2;