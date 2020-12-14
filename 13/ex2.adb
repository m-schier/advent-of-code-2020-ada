with Bus;                   use Bus;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;

procedure Ex2 is
    package UTIO is new Ada.Text_IO.Modular_IO(UInt64);
begin
    UTIO.Put(Find_Consecutive(Parse), Width => 0);
end Ex2;