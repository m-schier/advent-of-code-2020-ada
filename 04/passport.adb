with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Passport is
    function Create_Passport_Record return Passport_Record is
        Result : Passport_Record;
    begin
        return Result;
    end Create_Passport_Record;

    procedure Parse_Passport_Line(Line: Unbounded_String; Passport: out Passport_Record) is
        Start_Pos                   : Natural := 1;
        Next_Space_Pos, Colon_Pos   : Natural;
        Key                         : String(1 .. 3);
        Value                       : Unbounded_String;
    begin
        while True loop
            Colon_Pos := Index(Source => Line, Pattern => ":", From => Start_Pos);
            Next_Space_Pos := Index(Source => Line, Pattern => " ", From => Colon_Pos);

            -- We can't parse keys with length other than 3 and shouldn't be required to
            if Colon_Pos - Start_Pos /= 3 then
                raise Passport_Field_Error;
            end if;

            Key := Slice(Source => Line, Low => Start_Pos, High => Colon_Pos - 1);
            Value := Unbounded_Slice(Source => Line, Low => Colon_Pos + 1, High => (if Next_Space_Pos = 0 then Length(Line) else Next_Space_Pos - 1));

            if Key = "byr" then
                Passport.Byr := Value;
            elsif Key = "iyr" then
                Passport.Iyr := Value;
            elsif Key = "eyr" then
                Passport.Eyr := Value;
            elsif Key = "hgt" then
                Passport.Hgt := Value;
            elsif Key = "hcl" then
                Passport.Hcl := Value;
            elsif Key = "ecl" then
                Passport.Ecl := Value;
            elsif Key = "pid" then
                Passport.Pid := Value;
            elsif Key = "cid" then
                Passport.Cid := Value;
            else
                raise Passport_Field_Error;
            end if;

            if Next_Space_Pos = 0 then
                return;
            else
                Start_Pos := Next_Space_Pos + 1;
            end if;
        end loop;
    end Parse_Passport_Line;

    function Validate_Passport(Passport: Passport_Record) return Boolean is
    begin
        return Length(Passport.Byr) > 0 and Length(Passport.Iyr) > 0 and Length(Passport.Eyr) > 0 and Length(Passport.Hgt) > 0
            and Length(Passport.Hcl) > 0 and Length(Passport.Ecl) > 0 and Length(Passport.Pid) > 0;
    end Validate_Passport;

    function Full_Validate_Passport(Passport: Passport_Record) return Boolean is 
    begin
        if not Validate_Passport(Passport) then
            return False;
        elsif not Ecl_Valid(Passport) then
            return False;
        elsif not Hcl_Valid(Passport) then
            return False;
        elsif not Number_Valid(To_String(Passport.Byr), 4, 1920, 2002) then
            return False;
        elsif not Number_Valid(To_String(Passport.Iyr), 4, 2010, 2020) then
            return False;
        elsif not Number_Valid(To_String(Passport.Eyr), 4, 2020, 2030) then
            return False;
        elsif not Number_Valid(To_String(Passport.Pid), 9, 0, 999999999) then
            return False;
        elsif not Hgt_Valid(Passport) then
            return False;
        else
            return True;
        end if;
    end Full_Validate_Passport;

    function Hgt_Valid(Passport: Passport_Record) return Boolean is
        Unit : String(1..2);
    begin
        if Length(Passport.Hgt) < 4 then
            return False;
        end if;

        Unit := Slice(Passport.Hgt, Length(Passport.Hgt) - 1, Length(Passport.Hgt));

        if Unit = "cm" then
            return Number_Valid(Slice(Passport.Hgt, 1, Length(Passport.Hgt) - 2), 3, 150, 193);
        elsif Unit = "in" then
            return Number_Valid(Slice(Passport.Hgt, 1, Length(Passport.Hgt) - 2), 2, 59, 76);
        else
            return False;
        end if;
    end Hgt_Valid;

    function Ecl_Valid(Passport: Passport_Record) return Boolean is 
    begin
        return Passport.Ecl = "amb" or Passport.Ecl = "blu" or Passport.Ecl = "brn" or Passport.Ecl = "gry" or Passport.Ecl = "grn"
            or Passport.Ecl = "hzl" or Passport.Ecl = "oth";
    end Ecl_Valid;

    function Hcl_Valid(Passport: Passport_Record) return Boolean is
        C : Character;
    begin
        if Length(Passport.Hcl) /= 7 then
            return False;
        elsif Element(Passport.Hcl, 1) /= '#' then
            return False;
        else
            for I in 2 .. 7 loop
                C := Element(Passport.Hcl, I);
                if C >= '0' and C <= '9' then
                    null;
                elsif C >= 'a' and C <= 'f' then
                    null;
                else
                    return False;
                end if;
            end loop;
            return True;
        end if;
    end Hcl_Valid;

    function Number_Valid(Str: String; Digit_Count: Positive; Low: Integer; High: Integer) return Boolean is
        Parsed_Value : Integer;
    begin
        if Str'Length /= Digit_Count then
            return False;
        end if;

        for C of Str loop
            if C < '0' or C > '9' then
                return False;
            end if;
        end loop;

        Parsed_Value := Integer'Value(Str);

        return Parsed_Value >= Low and Parsed_Value <= High;
    end Number_Valid;
end Passport;