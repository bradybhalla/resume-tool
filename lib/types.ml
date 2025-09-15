open! Core

let sexp_of_file file = file |> In_channel.read_all |> Sexp.of_string

module Id =
  String_id.Make
    (struct
      let module_name = "id"
    end)
    ()

module type Storable_S = sig
  type t [@@deriving sexp]

  val data_file : string
  val example_data : (Id.t * t) list
end

module type Store_S = sig
  type t

  val load_from_file : data_dir:string -> t Id.Map.t
  val populate_file_with_example : data_dir:string -> unit
  val get_all_ids : data_dir:string -> Id.t List.t
end

module Section_store (M : Storable_S) = struct
  type t = M.t
  type data = (Id.t * M.t) list [@@deriving sexp]

  let load_from_file ~data_dir =
    Filename.concat data_dir M.data_file
    |> sexp_of_file |> data_of_sexp |> Id.Map.of_alist_exn

  let populate_file_with_example ~data_dir =
    Out_channel.write_all
      (Filename.concat data_dir M.data_file)
      ~data:(M.example_data |> sexp_of_data |> Sexp.to_string)

  let get_all_ids ~data_dir =
    Filename.concat data_dir M.data_file
    |> sexp_of_file |> data_of_sexp |> List.map ~f:fst
end

let date_to_latex date =
  [%string "%{Date.month date#Month} %{Date.year date#Int}"]

module Date_or_present = struct
  type t = Done of Date.t | Present [@@deriving sexp]

  let to_string = function
    | Done date -> date_to_latex date
    | Present -> "Present"
end

module Timespan = struct
  type t = Date.t * Date_or_present.t [@@deriving sexp]

  let to_string (start, finish) =
    date_to_latex start ^ " \\textbf{--} " ^ Date_or_present.to_string finish
end

module Place = struct
  type t = { name : string; location : string } [@@deriving sexp]
end

module Link_or_name = struct
  type t = { name : string; url : string option } [@@deriving sexp]

  let to_string { name; url } =
    match url with
    | None -> name
    | Some url -> [%string "\\href{%{url}}{%{name}}"]
end

module Author = struct
  type t = Me of string | Author of string [@@deriving sexp]

  let to_string = function
    | Me name -> "\\textbf{" ^ name ^ "}"
    | Author author -> author
end
