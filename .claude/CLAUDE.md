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

- Let the reader of the code breathe. Add empty lines between logical blocks of code.

- Add a small, to the point, comment to explain *what* the block does and *why*. Use examples when
  possible.

- The audience and history rules above bite hardest here.  A comment is written for someone who has
  never seen this code broken, so *why it is this way* belongs in the comment and *why it changed
  today* belongs in the commit message.  Giveaways that you have written the wrong one: "used to",
  "originally", "at the time", "turns out", "found by", "first attempt", "by mistake", "which is why
  I".  Same for a design doc or README -- neither is a log.

- Feel free to use markdown styles in code comments, too, including links.

- In command examples, use long flags wherever the tool offers them -- `jq --raw-input` rather than
  `jq -R` -- so the meaning is readable without opening a man page.  Plenty of tools have no long
  forms at all; short flags are fine there.


## Scope

- Working in logical segments is nice.  But don't let it stop you from fixing problems you see.  Don't
  bite off a huge extra project.  But if you notice misspelling or over-verbose-text, feel free to fix it
  while you're in the area.  This is how things move from worse to better over time.
