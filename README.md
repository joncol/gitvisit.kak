# gitvisit.kak

This is a Kakoune plugin that lets you visit the remote repository of a file. It
is useful when you are editing a file and want to see it in a web browser, maybe
to be able to send a link to someone else.

It automatically copies the link to the system clipboard.

It works with GitHub, and GitLab.

## Requirements

To figure out the currently selected lines, `awk` is used.

The command `xdg-open` is required to open the default web browser.

To copy the link to the clipboard, `xsel` is used.


## Installation

To install using [plug.kak](https://github.com/andreyorst/plug.kak), add:
```kak
plug "joncol/gitvisit.kak" config %{
  # Here you can bind some key to the command `visit-git-remote-url`.
}
```

## Feedback

Bug reports and/or PRs are welcome.
