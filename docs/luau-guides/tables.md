# Tables

Tables are the most versatile data structure in Luau. They're the foundation of almost everything — arrays, dictionaries, objects, modules — all of it is built on tables. Take your time with this one, it's worth understanding well.

## Creating Tables

You can define a table with values right away, or start with an empty one and fill it later:

```luau
-- With values
local fruits = {"apple", "banana", "cherry"}

-- Empty, filled later
local players = {}
players[1] = "Alice"
players[2] = "Bob"
```

If you know ahead of time how many items a table will hold, you can use `table.create` to preallocate memory for it. This is more efficient than letting the table grow on its own:

```luau
-- Allocate space for 10 items
local slots = table.create(10)

-- You can also fill it with a default value
local zeros = table.create(10, 0)
print(zeros[1])  -- 0
print(zeros[10]) -- 0
```

This is mostly a performance concern — for small tables it won't matter much, but it's a good habit when you're working with large collections.

## Array Tables

An array table is an ordered list of values:

```luau
local fruits = {"apple", "banana", "cherry"}
```

### Accessing Values

Tables in Luau are **1-indexed** — the first item is at index `1`, not `0`:

```luau
print(fruits[1]) -- apple
print(fruits[2]) -- banana
print(fruits[3]) -- cherry
```

### Modifying Values

You can reassign any index directly:

```luau
fruits[2] = "mango"
print(fruits[2]) -- mango
```

### Getting the Length

Use the `#` operator to get the number of items in an array table:

```luau
print(#fruits) -- 3
```

### Adding and Removing Items

Use `table.insert` to add items and `table.remove` to remove them:

```luau
local fruits = {"apple", "banana", "cherry"}

-- Add to the end
table.insert(fruits, "grape")
print(fruits[4]) -- grape

-- Insert at a specific position
table.insert(fruits, 2, "mango")
print(fruits[2]) -- mango (everything else shifts down)

-- Remove the last item
table.remove(fruits)

-- Remove at a specific position
table.remove(fruits, 1) -- removes "apple", everything shifts up
```

## Key-Value Tables

A key-value table — sometimes called a dictionary — lets you store values under named keys instead of numeric indexes:

```luau
local person = {
    name = "John",
    age = 25,
    isStudent = true,
}
```

### Accessing Values

You can access values using dot notation or bracket notation:

```luau
print(person.name)   -- John
print(person["age"]) -- 25
```

Dot notation is cleaner and more common. Bracket notation is useful when the key is stored in a variable or contains special characters.

### Adding and Modifying Entries

You can add new keys or change existing ones at any time:

```luau
person.email = "john@example.com" -- add new key
person.age = 26                   -- modify existing key
```

### Removing Entries

Set a key to `nil` to remove it:

```luau
person.isStudent = nil
print(person.isStudent) -- nil
```

### Checking if a Key Exists

Since accessing a missing key returns `nil`, you can check for existence with a simple `if`:

```luau
if person.email then
    print("Has email:", person.email)
else
    print("No email found")
end
```

## Mixed Tables

Tables can hold both numeric indexes and named keys at the same time:

```luau
local data = {
    "first",         -- index 1
    "second",        -- index 2
    label = "hello", -- named key
    count = 42,      -- named key
}

print(data[1])    -- first
print(data.label) -- hello
print(#data)      -- 2 (# only counts the array part)
```

Just keep in mind that `#` only counts the sequential numeric indexes — it ignores named keys entirely.

## Iterating

Luau gives you three ways to iterate over a table, each with different behavior.

### ipairs

`ipairs` iterates over the array part of a table in order, stopping at the first `nil` it encounters:

```luau
local fruits = {"apple", "banana", "cherry"}

for i, v in ipairs(fruits) do
    print(i, v)
end
-- 1  apple
-- 2  banana
-- 3  cherry
```

Since it always goes in order and stops at `nil`, it's the safe choice when you need guaranteed sequential iteration.

### pairs

`pairs` iterates over all keys in a table — both numeric indexes and named keys — but does **not** guarantee any order:

```luau
local person = {
    name = "John",
    age = 25,
    isStudent = true,
}

for key, value in pairs(person) do
    print(key, value)
end
-- order is not guaranteed
```

Use `pairs` when you need to go through every entry in a key-value table and order doesn't matter.

### Generalized Iteration (Luau)

Luau lets you skip `ipairs` and `pairs` entirely and just iterate directly on the table itself:

```luau
local fruits = {"apple", "banana", "cherry"}

for i, v in fruits do
    print(i, v)
end
```

For array tables, this behaves like `ipairs` — it goes in order and stops at `nil`. For key-value tables, it behaves like `pairs`. Luau figures out the right behavior automatically, so in most cases you can just use this and move on without thinking about which iterator to reach for.

## Tables as Modules

One of the most common patterns in Luau is using a table to group related functions and values together — essentially building a module:

```luau
local MathUtils = {}

function MathUtils.add(a: number, b: number): number
    return a + b
end

function MathUtils.subtract(a: number, b: number): number
    return a - b
end

function MathUtils.square(a: number): number
    return a ^ 2
end

print(MathUtils.add(3, 7))       -- 10
print(MathUtils.subtract(10, 4)) -- 6
print(MathUtils.square(5))       -- 25
```

This keeps related functionality organized under one name instead of scattering functions around everywhere.

### Returning a Module

When splitting code across multiple files, the convention is to define your module table, fill it with functions, and then `return` it at the end of the file:

```luau
-- mathutils.luau
local MathUtils = {}

function MathUtils.add(a: number, b: number): number
    return a + b
end

function MathUtils.subtract(a: number, b: number): number
    return a - b
end

return MathUtils
```

Then in another file, you load it with `require()`:

```luau
-- main.luau
local MathUtils = require("mathutils")

print(MathUtils.add(3, 7)) -- 10
```

This is the standard way of organizing Luau projects into multiple files — each file is a module, and `require()` is how you pull one into another.

### Private State

You can also use a module to keep some things private. Anything not added to the module table stays local to the file and can't be accessed from outside:

```luau
-- counter.luau
local Counter = {}

local count = 0 -- private, not accessible outside this file

function Counter.increment()
    count += 1
end

function Counter.getCount(): number
    return count
end

return Counter
```

```luau
-- main.luau
local Counter = require("counter")

Counter.increment()
Counter.increment()
print(Counter.getCount()) -- 2
print(Counter.count)      -- nil (private, can't be accessed)
```

This pattern gives you control over what's exposed and what isn't — a clean way to build self-contained, reusable pieces of code.