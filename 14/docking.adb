with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Interfaces; use Interfaces;
with Ada.Containers.Ordered_Maps;
with Ada.Containers.Vectors;

package body Docking is

    package Memory_Maps is new Ada.Containers.Ordered_Maps(Key_Type => UInt36, Element_Type => UInt36);
    use Memory_Maps;

    package Address_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => UInt36);
    use Address_Vectors;

    function Build_Address_Vector(Mask: String; Addr: UInt36) return Address_Vectors.Vector is
        Result_A : Address_Vectors.Vector;
        Result_B : Address_Vectors.Vector;
        T        : UInt36;
    begin
        Result_A.Append(0);
        
        for I in Mask'Range loop
            case Mask(I) is
                when '0' => 
                    T := UInt36(Shift_Right(Interfaces.Unsigned_64(Addr), 36 - I)) and 1;
                    for A of Result_A loop
                        Result_B.Append((A * 2) or T);
                    end loop;
                when '1' =>
                    for A of Result_A loop
                        Result_B.Append((A * 2) or 1);
                    end loop;
                when 'X' =>
                    for A of Result_A loop
                        Result_B.Append((A * 2));
                        Result_B.Append((A * 2) or 1);
                    end loop;
                when others => raise Parse_Error;
            end case;

            Result_A.Move(Source => Result_B);
        end loop;
        
        return Result_A;
    end Build_Address_Vector;

    procedure Parse_Value_Mask(Str: String; And_Mask: out UInt36; Or_Mask: out UInt36) is
    begin
        if Str'Length /= 36 then
            raise Parse_Error;
        end if;

        And_Mask := 0;
        Or_Mask := 0;

        for C of Str loop
            And_Mask := (And_Mask * 2) or 1;
            Or_Mask := Or_Mask * 2;
            case C is
                when 'X' => null;
                when '1' => Or_Mask := Or_Mask or 1;
                when '0' => And_Mask := And_Mask and (not 1);
                when others => raise Parse_Error;
            end case;
        end loop;
    end Parse_Value_Mask;

    function Run return UInt64 is
        Result      : UInt64 := 0;
        And_Mask    : UInt36 := UInt36'Last;
        Or_Mask     : UInt36 := 0;
        Address     : UInt36;
        Word        : UInt36;
        Pos1, Pos2  : Integer;
        Memory      : Memory_Maps.Map;
    begin
        while not End_Of_File loop
            declare
                Line : String := Get_Line;
            begin
                if Line(1..4) = "mask" then
                    Parse_Value_Mask(Line(Line'Last - 35 .. Line'Last), And_Mask, Or_Mask);
                else
                    Pos1 := Index(Line, "[");
                    Pos2 := Index(Line, "]");
                    Address := UInt36'Value(Line(Pos1 + 1 .. Pos2 - 1));
                    Pos1 := Index(Line, "=");
                    Word := UInt36'Value(Line(Pos1 + 1 .. Line'Last));
                    Word := (Word or Or_Mask) and And_Mask;
                    Memory.Include(Address, Word);
                end if;
            end;
        end loop;

        for C in Memory.Iterate loop
            Result := Result + UInt64(Element(C));
        end loop;
        return Result;
    end Run;

    function Run_V2 return UInt64 is
        Result      : UInt64 := 0;
        Mask        : String(1..36);
        Address     : UInt36;
        Word        : UInt36;
        Pos1, Pos2  : Integer;
        Memory      : Memory_Maps.Map;
    begin
        while not End_Of_File loop
            declare
                Line : String := Get_Line;
            begin
                if Line(1..4) = "mask" then
                    Mask := Line(Line'Last - 35 .. Line'Last);
                else
                    Pos1 := Index(Line, "[");
                    Pos2 := Index(Line, "]");
                    Address := UInt36'Value(Line(Pos1 + 1 .. Pos2 - 1));
                    Pos1 := Index(Line, "=");
                    Word := UInt36'Value(Line(Pos1 + 1 .. Line'Last));

                    for A of Build_Address_Vector(Mask, Address) loop
                        Memory.Include(A, Word);
                    end loop;
                end if;
            end;
        end loop;

        for C in Memory.Iterate loop
            Result := Result + UInt64(Element(C));
        end loop;
        return Result;
    end Run_V2;
end Docking;