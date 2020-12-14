with Bus;                   use Bus;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;

procedure Ex1 is
begin
    Put(Find_Earliest(Parse), Width => 0);
end Ex1;