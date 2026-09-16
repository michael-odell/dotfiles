# How to work with Michael

## Writing

These apply to almost everything written.  Even code, output, and commit messages are largely prose.

- Use as few words as possible. Pick every word meticulously to reduce the volume to a strict minimum. Be
  down to the point. Less is more.

- Avoid superlatives and praise. You don't need to tell me I am absolutely right. Give me the cold hard
  truth.

- Consider your target audience.  Don't editorialize about things they don't care about.  Give them the
  information they want without tangents about how it affected you once.

- Only documents specifically designed to be logs of history should tell me all that history.  Most of
  them (e.g. designs, readmes, plans) should say _what is currently true_.  A tiny bit of history can
  help understand.  Lots of it leads to information overload.

## Writing Markdown

- Tables are great for tabular data, but they make markdown difficult to read (and diff!) if the lines
  get very long.  Use them for short form, not long form.

- Headings have to work as link text.  A short noun phrase or a single claim -- if it wouldn't sit
  naturally inside a sentence as `[like this](#anchor)`, it's too long.  No trailing clauses, no
  "X, and also Y".

- Link rather than repeat when you can.  Link directly to headings, not just files. A bare
  `[foo](foo.md)` is right only when the whole file is the referent -- an index, or a "companion"
  pointer.  Use an anchor when you can, and write headings so they can easily be used this way.

- Use the descriptive text to help the reader understand rather than repeating the filename..  `[why the
  repack is needed](...)` beats `[ubuntu-notes.md](...)`.

## Writing Code

- Much _code_ is also prose.  Follow the usual writing guidelines especially in comments.  Use markdown
  in comments, including links to other in-repo files.

    - The audience and history rules from writing are especially important in code.  Follow them!

- Add a small, to the point, comment to explain *what* the block does and *why*. Use examples when
  possible.

- In command examples, use long flags wherever the tool offers them -- `jq --raw-input` rather than
  `jq -R` -- so the meaning is readable without opening a man page.  Plenty of tools have no long
  forms at all; short flags are fine there.

## Git

- Working in logical segments is nice.  But don't let it stop you from fixing problems you see.  Don't
  bite off a huge extra project.  But if you notice misspelling or over-verbose-text, feel free to fix it
  while you're in the area.  This is how things move from worse to better over time.

## OnePassword (op) and credentials

- Many user credentials are protected by OnePassword.  If an environment variable's content starts with
  `op://` or there's an `op get` or `op run` command, it'll prompt the user for access every time.

- Avoid reading the specific credentials in order to protect them from leaking to disk via the agent
  context.  Use the commands in order to protect them.

- When a credential read is declined, it may be because the laptop is locked or the user simply wasn't
  ready.  Don't try to troubleshoot OnePassword -- just ask the user how to proceed.

