open! Core
open Types

module T = struct
  type t = {
    project : Link_or_name.t;
    skills_used : string list;
    description : string list;
  }
  [@@deriving sexp]

  let data_file = "projects.sexp"

  let example_data =
    [
      ( Id.of_string "project-1",
        {
          project = { name = "Project 1"; url = None };
          skills_used = [ "Python" ];
          description = [ "Description goes here" ];
        } );
      ( Id.of_string "project-2",
        {
          project = { name = "Project 2"; url = Some "https://example.com" };
          skills_used = [ "C" ];
          description = [ "Description goes here" ];
        } );
    ]
end

include T
module Store = Section_store (T)
