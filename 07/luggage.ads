with Ada.Containers.Vectors;
with Ada.Containers.Ordered_Maps;
with Ada.Strings.Unbounded;

package Luggage is
    use Ada.Strings.Unbounded;

    type Bag_Constraint is record
        Color : Unbounded_String;
        Count : Positive;
    end record;

    function Create_Bag_Constraint(Color: Unbounded_String; Count: Positive) return Bag_Constraint;

    package Bag_Constraints_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Bag_Constraint);
    use Bag_Constraints_Vectors;

    function Create_Bag_Constraints_Vector return Bag_Constraints_Vectors.Vector;

    package Regulation_Maps is new Ada.Containers.Ordered_Maps(Key_Type => Unbounded_String, Element_Type => Bag_Constraints_Vectors.Vector);
    use Regulation_Maps;

    function Parse_Regulations return Regulation_Maps.Map;
    function Parse_Constraints(Line: Unbounded_String; From: Positive) return Bag_Constraints_Vectors.Vector;

    function Count_Outers(Regulations: Regulation_Maps.Map; Inner: Unbounded_String) return Natural;
    function Count_Inners(Regulations: Regulation_Maps.Map; Outer: Unbounded_String) return Natural;
end Luggage;