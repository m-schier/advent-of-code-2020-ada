with Ada.Containers.Vectors;

package Bus is
    Argument_Error : exception;

    type UInt64 is mod 2**64;
    type Int64 is range -2**63 .. 2**63 - 1;

    type Line(Scheduled : Boolean := False) is record
        case Scheduled is
            when True => Id : Natural;
            when False => null;
        end case;
    end record;

    package Line_Vectors is new Ada.Containers.Vectors(Index_Type => Natural, Element_Type => Line);
    use Line_Vectors;

    type Schedule is record
        Earliest_Departure : Natural;
        Lines : Line_Vectors.Vector;
    end record;

    function Parse return Schedule;
    function Find_Earliest(S : Schedule) return Natural;
    function Find_Consecutive(S : Schedule) return UInt64;
end Bus;