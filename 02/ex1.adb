with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

procedure Ex1 is
    Line                            : Unbounded_String;
    EnforcedCharacter               : Character;
    MinCount, MaxCount, ActualCount : Natural;
    DashPos, SpacePos, ColonPos     : Natural;
    ValidPasswordCount              : Natural := 0;
begin
    while not End_Of_File loop
        Get_Line (Line);
        DashPos := Index(Source => Line, Pattern => "-");
        SpacePos := Index(Source => Line, Pattern => " ", From => DashPos);
        ColonPos := Index(Source => Line, Pattern => ":", From => SpacePos);

        MinCount := Natural'Value (Slice(Line, 1, DashPos - 1));
        MaxCount := Natural'Value (Slice(Line, DashPos + 1, SpacePos - 1));
        EnforcedCharacter := Element(Line, SpacePos + 1);

        ActualCount := 0;
        
        for I in ColonPos + 1 .. Length(Line) loop
            if Element(Line, I) = EnforcedCharacter then
                ActualCount := ActualCount + 1;
            end if;
        end loop;

        if ActualCount >= MinCount and ActualCount <= MaxCount then
            ValidPasswordCount := ValidPasswordCount + 1;
        end if;
    end loop;

    Put (Item => ValidPasswordCount, Width => 0);
end Ex1;