---
layout: post
title: "Pattern Matching in Elixir for Rubyists"
comments: true
author: 'Brian Cardarella'
twitter: 'bcardarella'
social: true
published: true
tags: elixir, ruby
---

This is the first in a series of posts for helping Ruby devs understand
some of the concepts in Elixir.

## Pattern Matching

Pattern Matching is one of my favorite Elixir features. Let's take a
look. (using an [Elixir
Map](http://elixir-lang.org/getting_started/7.html#7.2-maps))

```elixir
%{foo: bar} = %{foo: "baz"}
```

The above is matching a pattern. Don't think of `=` as assignment, you
should think of `=` as *equality*. The left-hand side of the `=` is
equal to the right-hand side. Through pattern matching the variable
`bar` is assigned the value `"baz"`. Consider:

```elixir
[foo, bar] = [1, 2]
```

`foo` is assigned `1` and `bar` is assigned `2`. Patterns can match to
any depth:

```elixir
[foo, bar, [baz]] = [1, 2, [3]]
```

here `foo` and `bar` have the same value from the previous example but
`baz` is now assigned the value of `3`. Alternatively if we had written:

```elixir
[foo, bar, baz] = [1, 2, [3]]
```

`baz` is now assigned the value of `[3]`. This would be an example of a
semi-greedy matcher. You can expand upon this to greedily match the
entire statement:

```elixir
my_list = [1, 2, [3]]
```

Now `my_list` greedily matched to the entire right-hand side of the
`=`. So why is this cool? Let's take a look at a Ruby method that
has some conditions:

```ruby
def foo(a, b, c)
  if a == :something
    ...
  elsif b == :other
    ...
  else
    ...
  end
end
```

The above is likely something familar to many Ruby devs. This presents
some problems. Any methods with several code paths increases the
complexity of the method. Complex methods can be difficult to test in
isolation. Let's take a look at how this would be implemented in Elixir:

```elixir
def foo(:something, b, c) do
  ...
end

def foo(a, :other, c) do
  ...
end

def foo(a, b, c) do
  ...
end
```

The first question Ruby devs have is *why are there three functions of the same
name?* In Elixir you can define multiple functions of the same name as
long as the function signatures are unique. Functions are matched
against the values passed in. So `foo(:something, 2, 3)` would match the
first `foo` defined. `foo(1, :other, 3)` matches the second. `foo(1, 2,
3)` matches the third. Match priority is the order in which the
functions are defined.

Now our functions are concise, and focused on the very specific
behavior. The conditional is obfuscated through the pattern matching but
this is a common design pattern in Elixir so it should be embraced.

The pattern matching can be more complex:

```elixir
def foo(%{foo: bar}, "baz") do
  ...
end
```

The above will match: `foo(%{foo: "zeb"}, "baz")` but would not match
`foo(%{foo: "zeb"}, "bar")` because the second argument does not match.

Take a look at the [Elixir Pattern Matching
Guide](http://elixir-lang.org/getting_started/4.html) for more
information.
