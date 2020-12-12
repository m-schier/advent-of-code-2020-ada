package Rain is
    Argument_Error, Logic_Error, Parse_Error : exception;

    -- Our coordinate system is +X towards East, +Y towards South
    -- List orientations in order of ascending angle, thus +X turns towards +Y and direction is CW
    type Orientation is (North, East, South, West);

    type Vector is record
        X, Y : Integer := 0;
    end record;

    function "+" (Left, Right: Vector) return Vector;
    function "*" (Left: Vector; Right: Integer) return Vector;
    function To_Vector(Heading: Orientation) return Vector;
    function Rotate(Heading: Orientation; CW_Angle: Integer) return Orientation;
    function Rotate(V: Vector; CW_Angle: Integer) return Vector;
    function Manhattan(V: Vector) return Natural;

    type State is record
        Position : Vector;
        Heading  : Orientation := East;
    end record;

    function Navigate_First return Natural;
    function Navigate_Second return Natural;
end Rain;