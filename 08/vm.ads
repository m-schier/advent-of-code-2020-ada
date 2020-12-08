with Ada.Containers.Vectors;

package Vm is
    type Op_Code is (acc, nop, jmp);

    type Instruction is record
        Op      : Op_Code;
        Offset  : Integer;
    end record;

    type Exit_Reason is (Infinite_Loop, End_Of_Program, Illegal_Access);

    type Exit_Status is record
        Reason      : Exit_Reason;
        Accumulator : Integer;
    end record;

    Invalid_Op_Exception : exception;
    Line_Format_Exception : exception;
    No_Solution_Exception : exception;

    package Instruction_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Instruction);
    use Instruction_Vectors;

    function Parse_Program return Instruction_Vectors.Vector;
    function Run(Program: Instruction_Vectors.Vector) return Exit_Status;
    function Brute_Force_Program(Program: in out Instruction_Vectors.Vector) return Integer;
end Vm;