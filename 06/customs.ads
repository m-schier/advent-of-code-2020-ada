with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package Customs is
    type Question_Range is range 1 .. 26;
    type Question_Person is array (Question_Range) of Boolean;

    package Question_Person_Vectors is new Ada.Containers.Vectors
        (Index_Type   => Natural,
         Element_Type => Question_Person);

    use Question_Person_Vectors;

    package Question_Group_Vectors is new Ada.Containers.Vectors
        (Index_Type   => Natural,
         Element_Type => Question_Person_Vectors.Vector);

    use Question_Group_Vectors;

    function Make_Group return Question_Person_Vectors.Vector;

    function Parse_Question_Person(Item: Ada.Strings.Unbounded.Unbounded_String) return Question_Person;
    function Parse_Groups return Question_Group_Vectors.Vector;

    function Group_Union_Count(Group: Question_Person_Vectors.Vector) return Natural;
    function Group_Intersection_Count(Group: Question_Person_Vectors.Vector) return Natural;
end Customs;