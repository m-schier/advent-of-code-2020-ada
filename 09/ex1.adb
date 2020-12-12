with Xmas;                  use Xmas;
with Ada.Text_IO;           use Ada.Text_IO;

procedure Ex1 is
    package UInt64_TIO is new Ada.Text_IO.Modular_IO(UInt64);
begin
    UInt64_TIO.Put(Find_Invalid(Parse), Width => 0);
end Ex1;