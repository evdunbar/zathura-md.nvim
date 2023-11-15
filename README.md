# zathura-md.nvim

Preview markdown files in Zathura with auto-compilation and reload on save!

## Requirements

- Zathura (duh)
- Pandoc
- LaTeX

## How it works

- attaches to markdown files
    - maybe also to any file with command?
- generates a corresponding pdf with Pandoc and LaTeX
- opens the pdf with Zathura
    - automatic close when buffer is closed
