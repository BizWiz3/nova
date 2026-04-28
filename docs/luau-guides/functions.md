# Functions

A function is a reusable block of code that you can call by name. Instead of writing the same logic in multiple places, you write it once as a function and call it whenever you need it.

## Declaring and Calling Functions

Here's the basic syntax:

```luau
local function greet()
    print("Hello!")
end

greet() -- Hello!
```

You define the function with `local function`, give it a name, write the body, and close it with `end`. Then you call it by writing its name followed by `()`.

## Parameters

Parameters let you pass values into a function:

```luau
local function greet(name: string)
    print(`Hello, {name}!`)
end

greet("Luau") -- Hello, Luau!
greet("World") -- Hello, World!
```

You can have as many parameters as you need:

```luau
local function add(a: number, b: number)
    print(a + b)
end

add(3, 7)  -- 10
add(10, 5) -- 15
```

## Return Values

Functions can send a value back to whoever called them using `return`:

```luau
local function add(a: number, b: number): number
    return a + b
end

local result = add(3, 7)
print(result) -- 10
```

Notice the `: number` after the parameter list — that's the return type annotation, telling Luau what type this function is expected to return.

Luau also supports returning multiple values at once, which is something not many languages do:

```luau
local function minmax(a: number, b: number): (number, number)
    return math.min(a, b), math.max(a, b)
end

local min, max = minmax(10, 3)
print(min, max) -- 3  10
```

## Default-like Behavior with `or`

Luau doesn't have built-in default parameters, but you can achieve the same thing using the `or` pattern:

```luau
local function greet(name: string?)
    name = name or "stranger"
    print(`Hello, {name}!`)
end

greet("Luau")  -- Hello, Luau!
greet()        -- Hello, stranger!
```

Since calling a function without an argument makes that parameter `nil`, and `nil` is falsy, the `or` kicks in and provides the fallback value.

## Functions as Values

In Luau, functions are values just like numbers or strings. You can assign them to variables, pass them to other functions, or store them in tables:

```luau
local function add(a: number, b: number): number
    return a + b
end

local operation = add
print(operation(3, 7)) -- 10
```

This is a powerful idea that becomes especially useful as your programs grow in complexity.