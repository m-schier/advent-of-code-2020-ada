with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Containers.Vectors;

package body Seats is
    function Parse return Seat_Grid is
        package Unbounded_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Unbounded_String);
        use Unbounded_Vectors;

        Lines : Unbounded_Vectors.Vector;
        Line  : Unbounded_String;
    begin
        while not End_Of_File loop
            Lines.Append(Get_Line);
        end loop;

        declare
            Result : Seat_Grid(0 .. Natural(Lines.Length) - 1, 0 .. Length(Lines.Element(0)) - 1);
        begin
            for Y in 0 .. Natural(Lines.Length) - 1 loop
                Line := Lines.Element(Y);

                for X in 0 .. Length(Line) - 1 loop
                    case Element(Line, X + 1) is
                        when '.' => Result(Y, X) := Floor;
                        when 'L' => Result(Y, X) := Empty;
                        when '#' => Result(Y, X) := Occupied;
                        when others => raise Parse_Error;
                    end case;
                end loop;
            end loop;

            return Result;
        end;
    end Parse;

    type Flip_Func_Access is access function(Grid: Seat_Grid; Y: Integer; X: Integer) return Seat_State;

    function Flip_First(Grid: Seat_Grid; Y: Integer; X: Integer) return Seat_State is
        Count : Natural;
    begin
        if Grid(Y, X) = Floor then
            return Floor;
        end if;

        Count := 0;
        for D of Directions loop
            if (D.Y + Y in Grid'Range(1) and D.X + X in Grid'Range(2)) and then Grid(D.Y + Y, D.X + X) = Occupied then
                Count := Count + 1;
            end if;
        end loop;

        case Grid(Y, X) is
            when Empty      => return (if Count = 0 then Occupied else Empty);
            when Occupied   => return (if Count >= 4 then Empty else Occupied);
            when others     => raise Logic_Error;
        end case;
    end Flip_First;

    function Flip_Second(Grid: Seat_Grid; Y: Integer; X: Integer) return Seat_State is
        Count   : Natural;
        Pos     : Position;
    begin
        if Grid(Y, X) = Floor then
            return Floor;
        end if;

        Count := 0;
        for D of Directions loop
            Pos := Position'(X + D.X, Y + D.Y);
            while Pos.Y in Grid'Range(1) and Pos.X in Grid'Range(2) loop
                if Grid(Pos.Y, Pos.X) /= Floor then
                    if Grid(Pos.Y, Pos.X) = Occupied then
                        Count := Count + 1;
                    end if;
                    exit;
                end if;
                Pos := Position'(Pos.X + D.X, Pos.Y + D.Y);
            end loop;
        end loop;

        case Grid(Y, X) is
            when Empty      => return (if Count = 0 then Occupied else Empty);
            when Occupied   => return (if Count >= 5 then Empty else Occupied);
            when others     => raise Logic_Error;
        end case;
    end Flip_Second;

    function Arrival_Generic(Grid: Seat_Grid; Flip: Flip_Func_Access) return Natural is
        Last_Grid   : Seat_Grid := Grid;
        Next_Grid   : Seat_Grid := Grid;
        Count       : Natural;
    begin
        loop
            for Y in Grid'Range(1) loop
                for X in Grid'Range(2) loop
                    Next_Grid(Y, X) := Flip(Last_Grid, Y, X);
                end loop;
            end loop;

            exit when Last_Grid = Next_Grid;
            Last_Grid := Next_Grid;
        end loop;

        Count := 0;
        for Y in Grid'Range(1) loop
            for X in Grid'Range(2) loop
                if Next_Grid(Y, X) = Occupied then
                    Count := Count + 1;
                end if;
            end loop;
        end loop;

        return Count;
    end Arrival_Generic;

    function Arrival(Grid: Seat_Grid) return Natural is
    begin
        return Arrival_Generic(Grid, Flip_First'Access);
    end Arrival;

    function Arrival2(Grid: Seat_Grid) return Natural is
    begin
        return Arrival_Generic(Grid, Flip_Second'Access);
    end Arrival2;
end Seats;