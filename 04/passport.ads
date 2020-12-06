with Ada.Strings.Unbounded;

package Passport is
    Passport_Field_Error : exception;

    type Passport_Record is record
        Byr : Ada.Strings.Unbounded.Unbounded_String;
        Iyr : Ada.Strings.Unbounded.Unbounded_String;
        Eyr : Ada.Strings.Unbounded.Unbounded_String;
        Hgt : Ada.Strings.Unbounded.Unbounded_String;
        Hcl : Ada.Strings.Unbounded.Unbounded_String;
        Ecl : Ada.Strings.Unbounded.Unbounded_String;
        Pid : Ada.Strings.Unbounded.Unbounded_String;
        Cid : Ada.Strings.Unbounded.Unbounded_String;
    end record;

    function Create_Passport_Record return Passport_Record;

    procedure Parse_Passport_Line(Line: Ada.Strings.Unbounded.Unbounded_String; Passport: out Passport_Record);

    function Validate_Passport(Passport: Passport_Record) return Boolean;

    function Full_Validate_Passport(Passport: Passport_Record) return Boolean;

    function Hgt_Valid(Passport: Passport_Record) return Boolean;
    function Ecl_Valid(Passport: Passport_Record) return Boolean;
    function Hcl_Valid(Passport: Passport_Record) return Boolean;
    function Number_Valid(Str: String; Digit_Count: Positive; Low: Integer; High: Integer) return Boolean;
end Passport;