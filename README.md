# [every programming language](https://ii8.github.io/every-language/)

Parametric search for programming languages.


## Building and running locally

Prerequisites:

- make
- m4
- sed
- [elm](https://guide.elm-lang.org/install/elm.html)
- [tailwind](https://tailwindcss.com/docs/installation)
- Any http server like [mighty](https://github.com/kazu-yamamoto/mighttpd2)
  or [darkhttpd](https://github.com/emikulic/darkhttpd)

Optional (to run benchmarks):

- docker

Building:
```
make benchmark # optional
make
```

To run just serve the page:
```
darkhttpd .
```
and visit `localhost:8080`


## Adding a new language

Create a new file in the `lang` directory, you can just copy `lang/lua` and
modify the values. Ensure there exists a corresponding svg for it in `icon`.
The `language` value should be set the same as the filename, and the `name` can
be set to a nice printable version. For example:
```
language = "cpp"
name = "C++"
...
```
The available parameters and their meanings are listed in `Lang.elm.in`.
The `example` should be idiomatic, concise and demonstrate the most important
or unique language features.

If applicable, create a benchmark dockerfile for the language for each
subdirectory in `benchmark`. Look at the readme in each benchmark subdirectory
to see what it has to do.

Run make again and the language should appear on the web page.
