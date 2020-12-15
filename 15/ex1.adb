with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Memory;                use Memory;

procedure Ex1 is
begin
    Put(Find_Nth(2020), Width => 0);
end Ex1;