with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package Customs is
    type Question_Range is range 1 .. 26;
    type Question_Person is array (Question_Range) of Boolean;

    function Parse_Question_Person(Item: Ada.Strings.Unbounded.Unbounded_String) return Question_Person;

    function Question_Count(Group: Question_Person) return Natural;
end Customs;