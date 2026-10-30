# boost-org-latex-toolkit - Project Guidelines

## Context and sources

Org-to-LaTeX export toolkit with document classes, Beamer themes, and Emacs
integration.

Keep `lisp/org-mc-latex-classes.el`, reusable settings in `org/setup/`, and
classes/themes under `texmf/` consistent. Preserve public class and theme names.

## Changes and precautions

- Keep changes focused and preserve unrelated working-tree edits.
- If a file is generated from an Org/Babel source, edit that source and
  regenerate only the affected output; inspect tangle directives first.
- Validate a changed class or setup file with a small local export and inspect
  the resulting PDF. Do not replace an entire user TeX tree to test a change.

## Org mode headers

- Recursively scan this Git repository's `.txt` files and prepend the
  following exact first line when missing:

  ```text
  # Hey Emacs, this is a -*- org -*- file ...
  ```

- Preserve the rest of the file and its line endings. Do not follow
  symbolic links, scan `.git`, or cross into nested Git repositories.
- For `.org` files, omit this redundant header; remove it only when it
  matches the exact first line above.

## Validation

- For documentation-only changes, review the diff and affected local
  links; run an export only when rendering is part of the change.
- Never report an unrun or unavailable validation as successful. Do not
  install new tooling solely to validate an instructions-file change.
