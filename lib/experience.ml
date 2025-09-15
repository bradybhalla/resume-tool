open! Core
open Types

module T = struct
  type t = {
    job_title : string;
    company : Place.t;
    timespan : Timespan.t;
    description : string;
  }
  [@@deriving sexp]

  let data_file = "experience.sexp"

  let example_data =
    [
      ( Id.of_string "job-1",
        {
          job_title = "Software Developer";
          company = { name = "Company"; location = "City, State" };
          timespan = (Date.create_exn ~y:2022 ~m:Month.Sep ~d:1, Present);
          description = "Description goes here";
        } );
    ]
end

include T
module Store = Section_store (T)
