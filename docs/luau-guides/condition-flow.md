# Condition Flow

## if, elseif, else

Condition flow is how you make decisions in your code. The most fundamental tool for that is the `if` statement:

```luau
local score = 85

if score >= 90 then
    print("A")
elseif score >= 80 then
    print("B")
elseif score >= 70 then
    print("C")
else
    print("F")
end
```

Luau reads through each condition from top to bottom and runs the first block that's `true`. If none match, it falls through to `else`. You can have as many `elseif` branches as you need, and `else` is always optional.

## if Expressions

Sometimes you just want to assign one of two values based on a condition. The `if` expression lets you do that inline, without writing a full `if` block:

```luau
local age = 20
local status = if age >= 18 then "adult" else "minor"
print(status) -- adult
```

The syntax is `if condition then valueIfTrue else valueIfFalse`. It's Luau's answer to the ternary operator you might've seen in other languages. Clean and readable.

## The `and`/`or` Trick

Before `if` expressions existed in Luau, there was a pattern borrowed from Lua to achieve the same thing using `and` and `or`:

```luau
local age = 20
local status = age >= 18 and "adult" or "minor"
print(status) -- adult
```

Here's how it works — `and` returns the second value if the first is truthy, otherwise it returns the first. Then `or` returns the first value if it's truthy, otherwise the second. Chained together, it behaves like a ternary.

It works well in most cases, but it has one gotcha — if the "true" value is `false` or `nil`, the whole thing breaks:

```luau
local value = true and false or "fallback"
print(value) -- "fallback" (wrong! we wanted false)
```

So if you're on Luau, just use `if` expressions — they're safer and more readable. But you'll likely run into the `and`/`or` pattern in older Lua code or community projects, so it's good to know what it's doing.