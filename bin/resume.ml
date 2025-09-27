open! Core
open! Resume

include struct
  open Command.Param

  let out_file =
    flag_optional_with_default_doc "-out" Filename_unix.arg_type
      String.sexp_of_t ~default:"resume.tex" ~doc:"FILE output LaTeX file"

  let template_file =
    flag_optional_with_default_doc "-template" Filename_unix.arg_type
      String.sexp_of_t ~default:"templates/default.tex"
      ~doc:"FILE LaTeX preamble defining necessary macros and formatting"

  let spec_file =
    flag_optional_with_default_doc "-spec" Filename_unix.arg_type
      String.sexp_of_t ~default:"spec.sexp"
      ~doc:"FILE sexp file specifying what goes in the resume"

  let data_dir =
    flag_optional_with_default_doc "-data" Filename_unix.arg_type
      String.sexp_of_t ~default:"data/"
      ~doc:"DIR directory containing data for the resume"

  let name =
    flag_optional_with_default_doc "-name" string String.sexp_of_t
      ~default:"Name Here" ~doc:"STRING name for the resume"

  let map_realpath = map ~f:UnixLabels.realpath
end

let generate_command =
  Command.basic ~summary:"Generate resume from a spec file."
    (let%map_open.Command spec_file = spec_file and out_file = out_file in
     fun () ->
       let spec = spec_file |> Spec.load_from_file in
       let preamble = In_channel.read_all spec.template_file in
       let content =
         spec |> Spec.build_content ~data_dir:spec.data_dir |> Content.to_string
       in
       Out_channel.write_all out_file ~data:(preamble ^ content))

let create_spec_from_data_command =
  Command.basic ~summary:"Create a spec file from all existing data."
    (let%map_open.Command spec_file = spec_file
     and data_dir = data_dir |> map_realpath
     and template_file = template_file |> map_realpath
     and name = name in
     fun () ->
       let contacts = Contact.Store.get_all_ids ~data_dir in
       let education = Education.Store.get_all_ids ~data_dir in
       let experience = Experience.Store.get_all_ids ~data_dir in
       let projects = Project.Store.get_all_ids ~data_dir in
       let skills = Skill.Store.get_all_ids ~data_dir in
       let publications = Publication.Store.get_all_ids ~data_dir in
       let awards = Award.Store.get_all_ids ~data_dir in
       let spec =
         Spec.
           {
             data_dir;
             template_file;
             header = { name; contacts };
             content =
               [
                 Education education;
                 Experience experience;
                 Projects projects;
                 Skills skills;
                 Publications publications;
                 Awards awards;
               ];
           }
       in
       Out_channel.write_all spec_file
         ~data:([%sexp (spec : Spec.t)] |> Sexp.to_string))

let init_data_dir_command =
  Command.basic ~summary:"Initialize the data directory with placeholder data."
    (let%map_open.Command data_dir = data_dir in
     fun () ->
       match Sys_unix.is_directory data_dir with
       | `Yes | `Unknown ->
           print_s [%message "cannot create directory" (data_dir : string)]
       | `No ->
           Core_unix.mkdir data_dir ~perm:0o755;
           Contact.Store.populate_file_with_example ~data_dir;
           Education.Store.populate_file_with_example ~data_dir;
           Experience.Store.populate_file_with_example ~data_dir;
           Project.Store.populate_file_with_example ~data_dir;
           Skill.Store.populate_file_with_example ~data_dir;
           Publication.Store.populate_file_with_example ~data_dir;
           Award.Store.populate_file_with_example ~data_dir)

let () =
  Command.group
    [
      ("generate", generate_command);
      ("create-spec-from-data", create_spec_from_data_command);
      ("init-data-dir", init_data_dir_command);
    ]
    ~summary:"Utility for creating and maintaining resumes"
  |> Command_unix.run
