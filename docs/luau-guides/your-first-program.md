# Your First Program

## Printing to the Console

The first thing we'll do is get Luau to say something. The `print()` function does exactly that — it takes whatever you give it and outputs it to the console.

Create a new file called `main.luau` and write this:

```luau
print("Hello, world!")
```

Then run it with your runtime:

```bash
lune run main.luau
# or
zune run main.luau
# or
lute run main.luau
```

You should see `Hello, world!` printed in your terminal. That's it — you just ran your first Luau program.

You can print pretty much anything. Numbers, text, multiple values at once:

```luau
print("Hello, world!")
print(42)
print("My name is", "Luau")
```

When you pass multiple values separated by commas, `print()` outputs them on the same line with a tab between each one.

## Comments

Comments are lines that Luau completely ignores when running your code. They're for you — notes, explanations, reminders, whatever you need.

There are two ways to write them.

A **single-line comment** starts with `--`:

```luau
-- This is a comment, Luau won't run this
print("This runs fine") -- You can also put comments at the end of a line
```

A **multi-line comment** uses `--[[` to open and `]]` to close:

```luau
--[[
    This is a multi-line comment.
    Everything in here is ignored.
    Great for longer notes.
]]
print("This still runs")
```

Get into the habit of leaving comments as you write code. Future you will appreciate it.