open! Core
open Types

module Spec_header = struct
  type t = { name : string; contacts : Id.t list } [@@deriving sexp]
end

module Spec_section = struct
  type t =
    | Experience of Id.t list
    | Education of Id.t list
    | Projects of Id.t list
    | Skills of Id.t list
    | Awards of Id.t list
    | Publications of Id.t list
  [@@deriving sexp]
end

type t = {
  header : Spec_header.t;
  content : Spec_section.t list;
  template_file : Filename.t;
  data_dir : Filename.t;
}
[@@deriving sexp]

let get_content_from_file load_from_file ids ~data_dir =
  let data = load_from_file ~data_dir in
  List.map ids ~f:(Map.find_exn data)

let create_section spec_section ~data_dir : Content.Section.t =
  match spec_section with
  | Spec_section.Experience ids ->
      Content.Section.Experience
        (get_content_from_file Experience.Store.load_from_file ids ~data_dir)
  | Education ids ->
      Education
        (get_content_from_file Education.Store.load_from_file ids ~data_dir)
  | Projects ids ->
      Projects
        (get_content_from_file Project.Store.load_from_file ids ~data_dir)
  | Skills ids ->
      Skills (get_content_from_file Skill.Store.load_from_file ids ~data_dir)
  | Awards ids ->
      Awards (get_content_from_file Award.Store.load_from_file ids ~data_dir)
  | Publications ids ->
      Publications
        (get_content_from_file Publication.Store.load_from_file ids ~data_dir)

let build_content
    { template_file = _; data_dir = _; header = { name; contacts }; content }
    ~data_dir =
  Content.
    {
      header =
        {
          name;
          contacts =
            get_content_from_file Contact.Store.load_from_file contacts
              ~data_dir;
        };
      sections = List.map content ~f:(create_section ~data_dir);
    }

let load_from_file file = file |> sexp_of_file |> t_of_sexp
