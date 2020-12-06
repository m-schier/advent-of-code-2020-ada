with Interfaces; use Interfaces;

function Decode_Binary(Item: String; High_Char: Character) return Natural is
    Result: Unsigned_32 := 0;
begin
    for C of Item loop
        Result := Shift_Left(Result, 1);

        if C = High_Char then
            Result := Result or 1;
        end if;
    end loop;
    return Natural(Result);
end Decode_Binary;