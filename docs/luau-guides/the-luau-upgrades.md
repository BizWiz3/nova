# The Luau Upgrades

Lua is already a solid language, but Luau adds some quality-of-life features that make everyday coding a lot smoother. Here are two you'll find yourself using constantly.

## Compound Assignment

In regular Lua, if you want to add something to a variable, you'd write:

```luau
local count = 0
count = count + 1
```

Luau lets you shorten that with compound assignment operators:

```luau
local count = 0
count += 1   -- same as count = count + 1
count -= 1   -- same as count = count - 1
count *= 2   -- same as count = count * 2
count /= 2   -- same as count = count / 2
count //= 2  -- same as count = count // 2
count %= 2   -- same as count = count % 2
count ^= 2   -- same as count = count ^ 2
```

It's a small change, but it makes code cleaner and easier to read — especially inside loops where you're updating values frequently.

## String Interpolation

Normally, if you want to build a string from multiple values, you'd concatenate them using `..`:

```luau
local name = "Luau"
local version = 5
print("Welcome to " .. name .. " version " .. version)
```

It works, but it gets messy fast. String interpolation lets you embed values directly inside a string using backticks and `{}`:

```luau
local name = "Luau"
local version = 5
print(`Welcome to {name} version {version}`)
```

Much cleaner. Anything inside `{}` gets evaluated and dropped right into the string. You can even put expressions in there:

```luau
local a = 10
local b = 3
print(`{a} + {b} = {a + b}`)  -- 10 + 3 = 13
```

Just keep in mind that string interpolation only works with backtick strings — it won't work with regular quotes.