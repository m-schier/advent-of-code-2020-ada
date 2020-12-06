with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

procedure Ex2 is
    Line                            : Unbounded_String;
    EnforcedCharacter               : Character;
    FirstPos, LastPos               : Natural;
    DashPos, SpacePos, ColonPos     : Natural;
    ValidPasswordCount              : Natural := 0;
begin
    while not End_Of_File loop
        Get_Line (Line);
        DashPos  := Index(Source => Line, Pattern => "-");
        SpacePos := Index(Source => Line, Pattern => " ", From => DashPos);
        ColonPos := Index(Source => Line, Pattern => ":", From => SpacePos);

        FirstPos := Natural'Value (Slice(Line, 1, DashPos - 1));
        LastPos  := Natural'Value (Slice(Line, DashPos + 1, SpacePos - 1));
        EnforcedCharacter := Element(Line, SpacePos + 1);

        if Element(Line, ColonPos + 1 + FirstPos) = EnforcedCharacter xor Element(Line, ColonPos + 1 + LastPos) = EnforcedCharacter then
            ValidPasswordCount := ValidPasswordCount + 1;
        end if;
    end loop;

    Put (Item => ValidPasswordCount, Width => 0);
end Ex2;