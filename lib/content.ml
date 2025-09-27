open! Core
open Types

let string_and_concat ?sep xs to_string =
  xs |> List.map ~f:to_string |> String.concat ?sep

module Section = struct
  type t =
    | Education of Education.t list
    | Experience of Experience.t list
    | Projects of Project.t list
    | Skills of Skill.t list
    | Awards of Award.t list
    | Publications of Publication.t list
  [@@deriving sexp]

  let to_string = function
    | Education educations ->
        "\\section{Education}\n"
        ^ string_and_concat educations
            (fun { school; timespan; selected_courses; info; involvement } ->
              let descriptions =
                "\\description{\n"
                ^ ([
                     ("Selected Courses", selected_courses);
                     ("Involvement", involvement);
                   ]
                  |> List.filter_map ~f:(fun (title, content) ->
                         if List.is_empty content then None
                         else
                           let content = String.concat ~sep:", " content in
                           Some
                             [%string {|  \item \textbf{%{title}}: %{content}|}])
                  |> String.concat ~sep:" \n")
                ^ "\n}"
              in
              let info = String.concat ~sep:"; " info in
              [%string
                {|\experience{%{school.name}}{%{info}}
           {%{timespan#Timespan}}{%{school.location}}
%{descriptions}

|}])
    | Experience experiences ->
        "\\section{Experience}\n"
        ^ string_and_concat experiences
            (fun { job_title; company; timespan; description } ->
              let description =
                string_and_concat ~sep:"\n" description (fun s -> "  \\item " ^ s)
              in
              [%string
                {|\experience{%{job_title}}{%{company.name}}
           {%{timespan#Timespan}}{%{company.location}}
\description{
%{description}
}

|}])
    | Projects projects ->
        "\\section{Projects}\n"
        ^ string_and_concat projects
            (fun { project; skills_used; description } ->
              let description =
                string_and_concat ~sep:"\n" description (fun s -> "  \\item " ^ s)
              in
              let skills = String.concat ~sep:", " skills_used in
              [%string
                {|\project{%{project#Link_or_name}}
        {%{skills}}
\description{
%{description}
}

|}])
    | Skills skills ->
        "\\section{Skills}\n\\description{\n"
        ^ string_and_concat skills (fun { group; skills } ->
              let skills = String.concat skills ~sep:", " in
              [%string {|  \item \textbf{%{group}}: %{skills}
|}])
        ^ "}\n\n"
    | Awards awards ->
        "\\section{Awards}\n\\description{\n"
        ^ string_and_concat awards (fun { award; years } ->
              let years = string_and_concat ~sep:", " years Int.to_string in
              [%string {|  \item %{award} \textit{(%{years})}
|}])
        ^ "}\n\n"
    | Publications publications ->
        "\\section{Publications \\footnotesize{(* denotes equal contribution)}}\n\\description{\n"
        ^ string_and_concat publications
            (fun { title; publication; year; authors } ->
              let authors =
                string_and_concat authors ~sep:", " Author.to_string
              in
              [%string
                {|  \item {\footnotesize
    %{authors},
    ``%{title},"
    \textit{%{publication}}, %{year#Int}.
  }
|}]) ^ "}\n\n"
end

module Header = struct
  type t = { name : string; contacts : Contact.t list } [@@deriving sexp]

  let to_string { name; contacts } =
    let contacts =
      string_and_concat ~sep:" $|$\n" contacts (fun { icon; contact } ->
          [%string "  \\contact{%{icon}}{%{contact#Link_or_name}}"])
    in
    [%string {|\header{%{name}}{
%{contacts}
}
|}]
end

type t = { header : Header.t; sections : Section.t list } [@@deriving sexp]

let to_string { header; sections } =
  let section_str = string_and_concat sections Section.to_string in
  [%string
    {|
\begin{document}
%{header#Header}
%{section_str}
\end{document}
|}]
