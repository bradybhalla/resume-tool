open! Core
open Types

module T = struct
  type t = {
    school : Place.t;
    timespan : Timespan.t;
    info : string list;
    selected_courses : string list;
    involvement : string list;
  }
  [@@deriving sexp]

  let data_file = "education.sexp"

  let example_data =
    [
      ( Id.of_string "college",
        {
          school = { name = "College"; location = "City, State" };
          timespan = (Date.create_exn ~y:2022 ~m:Month.Sep ~d:1, Present);
          info = [ "Major"; "4.0 GPA" ];
          selected_courses = [ "Course"; "Other course" ];
          involvement = [];
        } );
      ( Id.of_string "high-school",
        {
          school = { name = "High School"; location = "City, State" };
          timespan =
            ( Date.create_exn ~y:2018 ~m:Month.Aug ~d:1,
              Done (Date.create_exn ~y:2022 ~m:Month.May ~d:1) );
          info = [ "4.0 GPA" ];
          selected_courses = [];
          involvement = [ "Club"; "Other club" ];
        } );
    ]
end

include T
module Store = Section_store (T)
