with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Passport;                  use Passport;

procedure Ex2 is
    Current_Line    : Unbounded_String;
    Passport        : Passport_Record := Create_Passport_Record;
    Valid_Count     : Natural := 0;
begin
    while not End_Of_File loop
        Get_Line(Current_Line);

        if Length(Current_Line) /= 0 then
            Parse_Passport_Line(Line => Current_Line, Passport => Passport);
        end if;
        
        if Length(Current_Line) = 0 or End_Of_File then
            if Full_Validate_Passport(Passport) then
                Valid_Count := Valid_Count + 1;
            end if;

            Passport := Create_Passport_Record;
        end if;
    end loop;

    Put(Item => Valid_Count, Width => 0);
end Ex2;