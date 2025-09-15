open! Core
open Types

module T = struct
  type t = { award : string; years : int list } [@@deriving sexp]

  let data_file = "awards.sexp"

  let example_data =
    [
      (Id.of_string "award", { award = "Good Award"; years = [ 2022 ] });
      (Id.of_string "honor", { award = "Amazing Honor"; years = [ 2023; 2024 ] });
    ]
end

include T
module Store = Section_store (T)
