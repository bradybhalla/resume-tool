open! Core
open Types

module T = struct
  type t = { group : string; skills : string list } [@@deriving sexp]

  let data_file = "skills.sexp"

  let example_data =
    [
      ( Id.of_string "languages",
        { group = "Languages"; skills = [ "Python"; "OCaml"; "C++" ] } );
      ( Id.of_string "python-packages",
        { group = "Python Packages"; skills = [ "pytorch"; "numpy"; "opencv" ] }
      );
    ]
end

include T
module Store = Section_store (T)

let to_string { group; skills } =
  let skills = skills |> String.concat ~sep:", " in
  [%string {|
\plain{\textbf{%{group}}: %{skills}}
|}]
