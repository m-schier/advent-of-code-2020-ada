with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings;               use Ada.Strings;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

with Ada.Containers.Ordered_Sets;

package body Luggage is
    function Create_Bag_Constraint(Color: Unbounded_String; Count: Positive) return Bag_Constraint is
        Result : Bag_Constraint := (Color => Color, Count => Count);
    begin
        return Result;
    end Create_Bag_Constraint;

    function Create_Bag_Constraints_Vector return Bag_Constraints_Vectors.Vector is
        Result : Bag_Constraints_Vectors.Vector;
    begin
        return Result;
    end Create_Bag_Constraints_Vector;

    function Parse_Regulations return Regulation_Maps.Map is
        Result              : Regulation_Maps.Map;
        Current_Line        : Unbounded_String;
        Pos                 : Natural;
        Current_Key         : Unbounded_String;
        Key_Value_Delim     : constant String := " bags contain ";
    begin
        while not End_Of_File loop
            Get_Line(Current_Line);

            Pos := Index(Source => Current_Line, Pattern => Key_Value_Delim);
            Current_Key := Unbounded_Slice(Current_Line, 1, Pos - 1);

            Result.Insert(Current_Key, Parse_Constraints(Current_Line, Pos + Key_Value_Delim'Length));
        end loop;
        return Result;
    end Parse_Regulations;

    function Parse_Constraints(Line: Unbounded_String; From: Positive) return Bag_Constraints_Vectors.Vector is
        Space_Pos, Split_Pos    : Natural;
        Pos                     : Natural;
        Result                  : Bag_Constraints_Vectors.Vector;
        Count                   : Positive;
        Color                   : Unbounded_String;
        Skip_Length             : Natural;
        Split_Delim             : constant String := " bag";
    begin
        Pos := From;

        if Slice(Line, From, From + 1) = "no" then
            return Result;
        end if;

        loop
            Space_Pos := Index(Line, " ", From => Pos);
            Count := Positive'Value(Slice(Line, Pos, Space_Pos - 1));
            Split_Pos := Index(Line, Split_Delim, From => Space_Pos + 1);
            Color := Unbounded_Slice(Line, Space_Pos + 1, Split_Pos - 1);

            Result.Append(Create_Bag_Constraint(Color => Color, Count => Count));

            Skip_Length := Split_Delim'Length + (if Count = 1 then 0 else 1);

            if Element(Line, Split_Pos + Skip_Length) = '.' then
                return Result;
            end if;

            Pos := Split_Pos + Skip_Length + 2;
        end loop;
    end Parse_Constraints;

    function Reverse_Regulations(Regulations: Regulation_Maps.Map) return Regulation_Maps.Map is
        Result          : Regulation_Maps.Map;
        From            : Unbounded_String;
        Inserted_Cursor : Regulation_Maps.Cursor;
        Inserted        : Boolean;
        Current_Vector  : Bag_Constraints_Vectors.Vector;
    begin
        for Cursor in Regulations.Iterate loop
            From := Key(Cursor);

            -- Don't care about cursor or inserted but prevent exception
            Result.Insert(From, Create_Bag_Constraints_Vector, Position => Inserted_Cursor, Inserted => Inserted);

            for Constraint of Element(Cursor) loop
                Result.Insert(Constraint.Color, Create_Bag_Constraints_Vector, Position => Inserted_Cursor, Inserted => Inserted);

                Current_Vector := Element(Inserted_Cursor);
                Current_Vector.Append(Create_Bag_Constraint(Color => From, Count => Constraint.Count));
                Result.Replace_Element(Inserted_Cursor, Current_Vector);
            end loop;
        end loop;

        return Result;
    end Reverse_Regulations;

    function Count_Outers(Regulations: Regulation_Maps.Map; Inner: Unbounded_String) return Natural is
        package Unbounded_Sets is new Ada.Containers.Ordered_Sets(Element_Type => Unbounded_String);
        use Unbounded_Sets;

        package Unbounded_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Unbounded_String);
        use Unbounded_Vectors;

        use Ada.Containers;

        Reversed        : Regulation_Maps.Map;
        Visited         : Unbounded_Sets.Set;
        Current         : Unbounded_String;
        Frontier        : Unbounded_Vectors.Vector;
        Result          : Unbounded_Sets.Set;
        Inserted        : Boolean;
        Inserted_Cursor : Unbounded_Sets.Cursor;
    begin
        -- Reverse the "graph" build from the Map and Vectors for efficient reverse look-up
        Reversed := Reverse_Regulations(Regulations);
        Frontier.Append(Inner);

        while Frontier.Length > 0 loop
            Current := Frontier.Last_Element;
            Frontier.Delete_Last;
            
            Visited.Insert(Current, Position => Inserted_Cursor, Inserted => Inserted);
            if Inserted then
                for Constraint of Reversed.Element(Current) loop
                    Frontier.Append(Constraint.Color);

                    -- Don't care about actual success but don't throw
                    Result.Insert(Constraint.Color, Position => Inserted_Cursor, Inserted => Inserted);
                end loop;
            end if;
        end loop;
        return Natural(Result.Length);
    end Count_Outers;

    function Count_Inners(Regulations: Regulation_Maps.Map; Outer: Unbounded_String) return Natural is
        type Stack_Element is record
            Multiplier  : Natural;
            Color       : Unbounded_String;
        end record;

        package Stack_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Stack_Element);
        use Stack_Vectors;

        use Ada.Containers;

        Frontier        : Stack_Vectors.Vector;
        Result          : Natural := 0;
        Elem, Current   : Stack_Element;
    begin
        Elem := (Multiplier => 1, Color => Outer);
        Frontier.Append(Elem);

        while Frontier.Length > 0 loop
            Current := Frontier.Last_Element;
            Frontier.Delete_Last;

            for Constraint of Regulations.Element(Current.Color) loop
                Result := Result + Constraint.Count * Current.Multiplier;
                Elem := (Multiplier => Current.Multiplier * Constraint.Count, Color => Constraint.Color);
                Frontier.Append(Elem);
            end loop;
        end loop;

        return Result;
    end Count_Inners;
end Luggage;