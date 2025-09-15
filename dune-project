(lang dune 3.19)

(name resume)

(generate_opam_files true)

(source
 (github bradybhalla/resume-tool))

(authors "Brady Bhalla")

(maintainers "Brady Bhalla")

(license LICENSE)

(package
  (name resume)
  (synopsis "CLI for easily generating resumes")
  (description
   "Command line tool for easily generating/maintaining resumes. Store all the data you might want to include in sexp files and produce the resume you need for any scenario using a short specification file. This is especially useful if you need to maintain multiple resumes or want to quickly generate new resumes with different subsets of your information.")
  (depends ocaml)
  (tags (resume utility cli)))
