with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with System;

package body Bus is
    function Parse return Schedule is
        Result  : Schedule;
        Old_Pos : Integer := 0;
        Pos     : Integer;
        Slice_End : Integer;
    begin
        Result.Earliest_Departure := Integer'Value(Get_Line);

        declare
            Departures : String := Get_Line;
        begin
            loop
                Pos := Index(Departures, ",", Old_Pos + 1);
                Slice_End := (if Pos = 0 then Departures'Last else Pos - 1);

                if Departures(Old_Pos + 1 .. Slice_End) = "x" then
                    Result.Lines.Append(Line'(Scheduled => False));
                else
                    Result.Lines.Append(Line'(Scheduled => True, Id => Integer'Value(Departures(Old_Pos + 1 .. Slice_End))));
                end if;

                exit when Pos = 0;
                Old_Pos := Pos;
            end loop;
        end;
        return Result;
    end Parse;

    function Find_Earliest(S : Schedule) return Natural is
        Earliest : Natural := 0; -- Assignment not necessary but supresses compiler warning
        Id       : Natural;
        Time     : Natural;
        Valid    : Boolean := False;
    begin
        for L of S.Lines loop
            if L.Scheduled then
                Time := (L.Id - S.Earliest_Departure) mod L.Id;

                if not Valid or else Time < Earliest then
                    Valid := True;
                    Earliest := Time;
                    Id := L.Id;
                end if;
            end if;
        end loop;

        if not Valid then
            raise Argument_Error;
        end if;

        return Id * Earliest;
    end Find_Earliest;

    function GCD(A: Int64; B: Int64; S: out Int64; T: out Int64) return Int64 is
        DI, SI, TI : Int64;
    begin
        if B = 0 then
            S := 1;
            T := 0;
            return A;
        else
            DI := GCD(B, A mod B, SI, TI);
            S := TI;
            T := SI - (A / B) * TI;
            return DI;
        end if;
    end GCD;

    function Find_Consecutive(S : Schedule) return UInt64 is
        L                   : Line;
        LCM                 : Int64 := 1;
        Time                : Int64 := 0;
        X, Y, M_I, R_I      : Int64;
    begin
        for L of S.Lines loop
            if L.Scheduled then
                LCM := LCM * Int64(L.Id);
            end if;
        end loop;

        -- Use Chinese Remainder Theorem
        -- if Scheduled(0): X = Id(0) - 0 mod Id(0)
        -- if Scheduled(1): X = Id(1) - 1 mod Id(1)
        --   ...
        for Offset in S.Lines.First_Index .. S.Lines.Last_Index loop
            L := S.Lines.Element(Offset);

            if L.Scheduled then
                R_I := Int64(L.Id);
                M_I := LCM / R_I;
                
                if GCD(R_I, M_I, X, Y) /= 1 then
                    -- Input was not coprime
                    raise Argument_Error;
                end if;

                Time := (Time + Int64((L.Id - Offset) mod L.Id) * Y * M_I) mod LCM;
            end if;
        end loop;

        return UInt64(Time);
    end Find_Consecutive;
end Bus;