open! Core
open Types

module T = struct
  type t = {
    title : string;
    publication : string;
    year : int;
    authors : Author.t list;
  }
  [@@deriving sexp]

  let data_file = "publications.sexp"

  let example_data =
    [
      ( Id.of_string "conference",
        {
          title = "Publication in a Conference";
          year = 2025;
          publication = "Conference Name";
          authors = [ Author "Main Author"; Me "Me"; Author "Third Author" ];
        } );
      ( Id.of_string "workshop",
        {
          title = "Publication at a Workshop";
          year = 2023;
          publication = "Workshop Name";
          authors = [ Author "Co-author*"; Me "Me*"; Author "Co-author*" ];
        } );
    ]
end

include T
module Store = Section_store (T)
