# Variables & Data Types

## What's a Variable?

A variable is a named container for storing a value. Instead of writing the same value over and over, you give it a name and refer to that instead.

In Luau, you declare variables using the `local` keyword:

```luau
local name = "Luau"
local version = 5
print(name, version)
```

The `local` keyword means the variable belongs to the current scope — more on that when we get to functions and control flow. For now, just make it a habit to always use `local` when declaring variables.

## Data Types

Every value in Luau has a type. Here are the four primitive ones you'll be working with constantly.

### String

A `string` is a piece of text. Wrap it in double quotes, single quotes, backticks, or double square brackets:

```luau
local greeting = "Hello!"
local language = 'Luau'
local name = `John Doe`
local paragraph = [[
    This is a string
    that spans multiple lines.
    No escape characters needed.
]]
```

### Number

Luau uses a single `number` type for both integers and decimals:

```luau
local age = 20
local pi = 3.14159
```

No need to think about `int` vs `float` like in some other languages. A number is just a number.

### Boolean

A boolean is either `true` or `false`. That's it:

```luau
local isReady = true
local isDone = false
```

These come in handy when you need to make decisions in your code, which we'll get to in the Control Flow chapter.

### Nil

`nil` means the absence of a value. If a variable exists but has nothing assigned to it, it's `nil`:

```luau
local something = nil
```

It's Luau's way of saying "this has no value right now." You'll run into `nil` a lot, especially when checking whether something exists.

## Type Annotations

Here's something Luau has that plain Lua doesn't — a type system. You can explicitly tell Luau what type a variable is supposed to hold by adding a type annotation after its name:

```luau
local name: string = "Luau"
local version: number = 5
local isReady: boolean = true
```

The syntax is simple: `local variableName: Type = value`.

Now, Luau is usually smart enough to figure out the type on its own — if you write `local version = 5`, it already knows `version` is a `number`. So annotations aren't always required. But they're a good habit, especially as your code grows, because they make your intent clear and let Luau catch mistakes early.

For example, if you annotate a variable as `string` and then try to assign a number to it, Luau will warn you:

```luau
local name: string = "Luau"
name = 42 -- Type error: cannot assign 'number' to 'string'
```

That kind of feedback is really useful — it means you catch bugs before your code even runs.

### Nullable Types

Sometimes a variable might hold a value, or it might be `nil`. You can express that with a `?` after the type:

```luau
local nickname: string? = nil  -- fine, it's allowed to be nil
nickname = "John Doe"          -- also fine
```

A `string?` means "either a string or nil." Without the `?`, Luau expects the variable to always have a proper value.

## Checking a Value's Type

You can check what type a value is at runtime using the built-in `type()` function:

```luau
print(type("hello"))  -- string
print(type(42))       -- number
print(type(true))     -- boolean
print(type(nil))      -- nil
```

Handy for debugging when you're not sure what you're actually working with.