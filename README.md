# resume-tool

Command line tool for easily generating/maintaining resumes. Store all the data you might want to include in sexp files and produce the resume you need for any scenario using a short specification file. This is especially useful if you need to maintain multiple resumes or want to quickly generate new resumes with different subsets of your personal information.

This example specification file along with the necessary data will create the following resume.
```
((header (
   (name "Name Here")
   (contacts (email phone website github linkedin))))
 (content (
   (Education (college high-school))
   (Experience (job-1))
   (Projects (project-1 project-2))))
 (template_file dir/template.tex)
 (data_dir      dir/data))
```
<img width="1326" height="958" alt="example_output" src="https://github.com/user-attachments/assets/5e35175f-8880-4942-8478-ab203f1563d9" />



## Usage
To begin, the resume data needs to be populated. In the directory where you want to keep your data, run `resume init-data-dir`. Additonally, copy the resume template from "templates/template.tex" to this directory. Your personal information can now be added to the data files following the same format as the placeholder values. Note that you probably want to install `sexp` using opam and run `sexp pp` to format the data files.

After populating all data files, create a specification file containing all of your data by running `resume create-spec-from-data`. This file can be modified to select which subset of data to put in the resume.

Finally, generate a LaTeX file for the resume by running `resume generate`. The output file can be turned into a pdf using `latexmk` or any other LaTeX compiler.

Append `-help` to any `resume` command to see the list of arguments for customizing behavior.

## Installation
- Clone repo
- Run `opam install .`
- You should now have the `resume` executable added to your path
