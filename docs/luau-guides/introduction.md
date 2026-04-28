# Introduction

## What is Luau?

Luau is a scripting language — a tool for telling a computer what to do, step by step. It's fast, lightweight, and designed to be straightforward to read and write.

Luau grew out of **Lua**, a language that's been around since the early 90s. Lua was built to be small and easy to embed into other software, and it became popular for exactly that reason. Luau takes that same foundation and builds on it — adding modern features, better performance, and a few quality-of-life improvements that make the language feel a lot more comfortable to work with.

In these guide, we're going to go through the fundamentals of Luau from the ground up. By the end, you'll have a solid understanding of how the language works and the tools to start building things with it.

## Setting Up Your Environment

To run Luau code on your machine, you need a **runtime** — a program that reads your `.luau` files and executes them. There are three good options:

- **[Lune](https://github.com/lune-org/lune)** — A standalone Luau runtime with a solid standard library covering file I/O, networking, and more.
- **[Zune](https://github.com/Scythe-Technology/Zune)** — A runtime inspired by the design philosophy of Deno and Bun. A great alternative if you want something more cutting-edge.
- **[Lute](https://github.com/luau-lang/lute)** — An official runtime created by the same developers created Luau.

The three of them work perfectly for everything covered in these docs. Pick either one — you can always try the other later.

### Installing Lune

Head to the [Lune releases page](https://github.com/lune-org/lune/releases), download the binary for your OS, and add it to your `PATH`. Then verify the install by running this in your terminal:

```bash
lune --version
```

If you see a version number, you're good.

### Installing Zune

Head to the [Zune releases page](https://github.com/Scythe-Technology/Zune/releases), add it to your `PATH`, and check it with:

```bash
zune --version
```

### Installing Lute

Same process — grab it from the [Lute releases page](https://github.com/luau-lang/lute/releases), add it to your `PATH`, and check it with:

```bash
lute --version
```

## Setting Up Your Editor

You'll also want a code editor. **[Visual Studio Code](https://code.visualstudio.com/)** is a solid choice, and it has a great Luau extension to go along with it.

Install the **[Luau LSP](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.luau-lsp)** extension inside VS Code. It gives you syntax highlighting, autocomplete, and inline type hints — all things that make writing code a lot more comfortable.

---

Once your runtime is installed and your editor is ready, you're all set. Head over to the next section — we'll write your very first Luau program.