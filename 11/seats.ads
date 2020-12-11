package Seats is
    type Seat_State is (Floor, Empty, Occupied);

    type Seat_Grid is array(Integer range <>, Integer range <>) of Seat_State;

    type Position is record
        X, Y : Integer;
    end record;

    Directions : array(0 .. 7) of Position := (
        0 => Position'(-1,  0),
        1 => Position'(-1,  1),
        2 => Position'( 0,  1),
        3 => Position'( 1,  1),
        4 => Position'( 1,  0),
        5 => Position'( 1, -1),
        6 => Position'( 0, -1),
        7 => Position'(-1, -1)
    );

    Parse_Error : exception;
    Logic_Error : exception;

    function Parse return Seat_Grid;

    function Arrival(Grid: Seat_Grid) return Natural;
    function Arrival2(Grid: Seat_Grid) return Natural;
end Seats;