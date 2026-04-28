# Loops

Loops let you run a block of code multiple times without writing it out over and over. Luau has three kinds — each suited for different situations.

## while

A `while` loop keeps running as long as its condition is `true`:

```luau
local count = 0

while count < 5 do
    print(count)
    count += 1
end
```

The condition is checked **before** each iteration. If it's `false` from the start, the loop body never runs at all.

## repeat...until

`repeat...until` is the flip side of `while`. Instead of checking the condition at the start, it checks at the **end** — which means the body always runs at least once:

```luau
local count = 0

repeat
    print(count)
    count += 1
until count >= 5
```

The loop keeps repeating until the condition becomes `true`. It's useful when you always need to run the body at least once before deciding whether to continue — like prompting for user input and validating it afterward.

## Numeric for

A numeric `for` loop runs a set number of times. You give it a start, a stop, and an optional step:

```luau
for i = 1, 5 do
    print(i) -- 1, 2, 3, 4, 5
end
```

By default the step is `1`, but you can change it:

```luau
for i = 0, 10, 2 do
    print(i) -- 0, 2, 4, 6, 8, 10
end
```

You can also count backwards with a negative step:

```luau
for i = 5, 1, -1 do
    print(i) -- 5, 4, 3, 2, 1
end
```

## Generalized Iteration

The generalized `for` loop is used to iterate over collections like tables. You'll learn about tables properly in a later chapter, but here's a quick look at what it looks like:

```luau
local fruits = {"apple", "banana", "cherry"}

for i, v in fruits do
    print(i, v)
end
-- 1  apple
-- 2  banana
-- 3  cherry
```

`i` is the index and `v` is the value at that index. This is one of the most common patterns you'll write in Luau, so it's worth getting familiar with the shape of it early even if tables aren't fully covered yet.

## break

Any loop can be exited early with `break`:

```luau
for i = 1, 10 do
    if i == 5 then
        break
    end
    print(i) -- 1, 2, 3, 4
end
```

Once `break` is hit, Luau jumps out of the loop immediately and continues with whatever comes after it.