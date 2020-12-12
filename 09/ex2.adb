with Xmas;                  use Xmas;
with Ada.Text_IO;           use Ada.Text_IO;

procedure Ex2 is
    package UInt64_TIO is new Ada.Text_IO.Modular_IO(UInt64);

    N : Integer_Vectors.Vector;
begin
    N := Parse;
    UInt64_TIO.Put(Find_Range(N, Find_Invalid(N)), Width => 0);
end Ex2;