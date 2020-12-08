with Vm;                    use Vm;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;

procedure Ex1 is
    Program : Instruction_Vectors.Vector;
begin
    Program := Parse_Program;
    Put(Item => Run(Program).Accumulator, Width => 0);
end Ex1;