with Luggage;                   use Luggage;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

procedure Ex2 is
begin
    Put(Item => Count_Inners(Parse_Regulations, To_Unbounded_String("shiny gold")), Width => 0);
end Ex2;