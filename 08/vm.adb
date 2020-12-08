with Ada.Text_IO; use Ada.Text_IO;

package body Vm is
    function Parse_Program return Instruction_Vectors.Vector is
        Result  : Instruction_Vectors.Vector;
        Ins     : Instruction;
        Buffer  : String(1..32); -- There is no reason for an input line to come close to 32 chars
        Len     : Natural;
    begin
        while not End_Of_File loop
            Get_Line(Buffer, Len);

            if Len < 6 or Len > 31 then
                raise Line_Format_Exception with "Parsing " & Buffer(1..Len);
            end if;

            if Buffer(1..3) = "acc" then
                Ins.Op := acc;
            elsif Buffer(1..3) = "jmp" then
                Ins.Op := jmp;
            elsif Buffer(1..3) = "nop" then
                Ins.Op := nop;
            else
                raise Invalid_Op_Exception with "Parsing " & Buffer(1..Len);
            end if;

            Ins.Offset := Integer'Value(Buffer(5..Len));
            Result.Append(Ins);
        end loop;
        return Result;
    end Parse_Program;

    function Run(Program: Instruction_Vectors.Vector) return Exit_Status is
        Program_Counter : Natural := 0;
        Accumulator     : Integer := 0;
        Ins             : Instruction;
    begin
        declare
            type Visited_Array is array(Program.First_Index .. Program.Last_Index) of Boolean;
            pragma pack(Visited_Array);

            Visited : Visited_Array := (others => False);
        begin
            loop
                if Program_Counter = Program.Last_Index + 1 then
                    return Exit_Status'(Accumulator => Accumulator, Reason => End_Of_Program);
                elsif Program_Counter < Program.First_Index or Program_Counter > Program.Last_Index + 1 then
                    return Exit_Status'(Accumulator => Accumulator, Reason => Illegal_Access);
                end if;

                if Visited(Program_Counter) then
                    return Exit_Status'(Accumulator => Accumulator, Reason => Infinite_Loop);
                else
                    Visited(Program_Counter) := True;
                end if;

                Ins := Program.Element(Program_Counter);

                case Ins.Op is
                    when nop => Program_Counter := Program_Counter + 1;
                    when acc => Program_Counter := Program_Counter + 1; Accumulator := Accumulator + Ins.Offset;
                    when jmp => Program_Counter := Program_Counter + Ins.Offset;
                end case;

            end loop;
        end;
    end Run;

    function Brute_Force_Program(Program: in out Instruction_Vectors.Vector) return Integer is
        Ins : Instruction;
        Ex  : Exit_Status;
    begin
        for I in Program.First_Index .. Program.Last_Index loop
            Ins := Program.Element(I);

            if Ins.Op /= acc then
                -- Flip instruction in place
                Ins.Op := (if Ins.Op = jmp then nop else jmp);
                Program.Replace_Element(I, Ins);

                Ex := Run(Program);

                if Ex.Reason = End_Of_Program then
                    return Ex.Accumulator;
                end if;

                -- Undo flip instruction in place
                Ins.Op := (if Ins.Op = jmp then nop else jmp);
                Program.Replace_Element(I, Ins);
            end if;
        end loop;

        raise No_Solution_Exception;
    end Brute_Force_Program;
end Vm;