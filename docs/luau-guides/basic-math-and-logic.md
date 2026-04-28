# Basic Math & Logic

## Arithmetic

Luau supports all the arithmetic operators you'd expect:

```luau
print(2 + 3)   -- 5
print(10 - 4)  -- 6
print(3 * 6)   -- 18
print(15 / 4)  -- 3.75
print(15 // 4) -- 3  (floor division, rounds down)
print(10 % 3)  -- 1  (remainder)
print(2 ^ 8)   -- 256 (exponentiation)
```

Nothing too surprising here. One to note is `//` — floor division — which divides and drops the decimal, always rounding down to the nearest whole number.

## Comparison Operators

Comparison operators let you compare two values. They always return a `boolean` — either `true` or `false`:

```luau
print(5 == 5)   -- true  (equal to)
print(5 ~= 3)   -- true  (not equal to)
print(10 > 3)   -- true  (greater than)
print(10 < 3)   -- false (less than)
print(5 >= 5)   -- true  (greater than or equal to)
print(5 <= 4)   -- false (less than or equal to)
```

One thing worth pointing out — "not equal to" in Luau is `~=`, not `!=` like in some other languages.

## Logical Operators

Logical operators let you combine or negate boolean values:

```luau
print(true and false)  -- false
print(true or false)   -- true
print(not true)        -- false
```

- `and` returns `true` only if **both** sides are `true`
- `or` returns `true` if **at least one** side is `true`
- `not` flips the value — `true` becomes `false` and vice versa

These become a lot more useful once we get into control flow, where you'll use them to build conditions like "do this if A and B are both true."

### A Quick Note on Truthiness

In Luau, only `false` and `nil` are considered falsy. Everything else — including `0` and empty strings — is truthy. This is different from some other languages, so it's worth keeping in mind:

```luau
print(not 0)    -- false (0 is truthy in Luau!)
print(not "")   -- false ("" is also truthy)
print(not nil)  -- true
print(not false) -- true
```