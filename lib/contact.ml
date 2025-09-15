open! Core
open Types

module T = struct
  type t = { contact : Link_or_name.t; icon : string } [@@deriving sexp]

  let data_file = "contacts.sexp"

  let example_data =
    [
      ( Id.of_string "email",
        {
          contact =
            {
              name = "email@example.com";
              url = Some "mailto:email@example.com";
            };
          icon = "\\faEnvelope";
        } );
      ( Id.of_string "phone",
        {
          contact = { name = "(xxx)\\,xxx-xxxx"; url = None };
          icon = "\\faMobile";
        } );
      ( Id.of_string "website",
        {
          contact = { name = "example.com"; url = Some "https://example.com" };
          icon = "\\faGlobe";
        } );
      ( Id.of_string "github",
        {
          contact =
            { name = "example"; url = Some "https://github.com/example" };
          icon = "\\faGithub";
        } );
      ( Id.of_string "linkedin",
        {
          contact =
            { name = "example"; url = Some "https://linkedin.com/in/example" };
          icon = "\\faLinkedinSquare";
        } );
    ]
end

include T
module Store = Section_store (T)
