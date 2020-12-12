with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;

package body Rain is
    function "+" (Left, Right: Vector) return Vector is
    begin
        return Vector'(Left.X + Right.X, Left.Y + Right.Y);
    end "+";

    function "*" (Left: Vector; Right: Integer) return Vector is
    begin
        return Vector'(Left.X * Right, Left.Y * Right);
    end "*";

    function To_Vector(Heading: Orientation) return Vector is
    begin
        case Heading is
            when North => return Vector'( 0, -1);
            when East  => return Vector'( 1,  0);
            when South => return Vector'( 0,  1);
            when West  => return Vector'(-1,  0);
        end case;
    end To_Vector;

    function Rotate(Heading: Orientation; CW_Angle: Integer) return Orientation is
    begin
        if CW_Angle rem 90 /= 0 then
            raise Argument_Error;
        end if;

        return Orientation'Val((Orientation'Pos(Heading) + (CW_Angle / 90)) mod 4);
    end Rotate;

    function Rotate(V: Vector; CW_Angle: Integer) return Vector is
    begin
        if CW_Angle rem 90 /= 0 then
            raise Argument_Error;
        end if;

        case (CW_Angle / 90) mod 4 is
            when 0 => return V;
            when 1 => return Vector'(-V.Y, V.X);
            when 2 => return Vector'(-V.X, -V.Y);
            when 3 => return Vector'(V.Y, -V.X);
            when others => raise Logic_Error; -- Should never be encountered
        end case;
    end Rotate;

    function Manhattan(V: Vector) return Natural is 
    begin
        return (abs V.X) + (abs V.Y);
    end Manhattan;

    function Parse_Hdg(C: Character) return Orientation is
    begin
        case C is
            when 'N' => return North;
            when 'E' => return East;
            when 'S' => return South;
            when 'W' => return West;
            when others => raise Parse_Error;
        end case;
    end Parse_Hdg;

    procedure Apply_Update_First(S: in out State) is
        Line : String := Get_Line;
        Inc  : Integer;
        C    : Character;
    begin
        Inc := Integer'Value(Line(Line'First + 1 .. Line'Last));
        C := Line(Line'First);

        case C is
            when 'N' | 'E' | 'S' | 'W' => S.Position := S.Position + To_Vector(Parse_Hdg(C)) * Inc;
            when 'F' => S.Position := S.Position + To_Vector(S.Heading) * Inc;
            when 'L' => S.Heading := Rotate(S.Heading, -Inc);
            when 'R' => S.Heading := Rotate(S.Heading,  Inc);
            when others => raise Parse_Error;
        end case;
    end Apply_Update_First;

    procedure Apply_Update_Second(S: in out Vector; W: in out Vector) is
        Line : String := Get_Line;
        Inc  : Integer;
        C    : Character;
    begin
        Inc := Integer'Value(Line(Line'First + 1 .. Line'Last));
        C := Line(Line'First);

        case Line(Line'First) is
            when 'N' | 'E' | 'S' | 'W' => W := W + To_Vector(Parse_Hdg(C)) * Inc;
            when 'F' => S := S + W * Inc;
            when 'L' => W := Rotate(W, -Inc);
            when 'R' => W := Rotate(W,  Inc);
            when others => raise Parse_Error;
        end case;
    end Apply_Update_Second;

    function Navigate_First return Natural is
        Result : State;
    begin
        while not End_Of_File loop
            Apply_Update_First(Result);
        end loop;

        return Manhattan(Result.Position);
    end Navigate_First;

    function Navigate_Second return Natural is
        Ship        : Vector;
        Waypoint    : Vector := Vector'(10, -1);
    begin
        while not End_Of_File loop
            Apply_Update_Second(Ship, Waypoint);
        end loop;

        return Manhattan(Ship);
    end Navigate_Second;

end Rain;