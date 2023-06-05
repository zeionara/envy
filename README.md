# Envy

<p align="center">
    <img src="Assets/logo.png"/>
</p>

A miniature tool for flattening configuration files. The tool takes an input configuration in `yaml` format and emits an output configuration in format of setting bash environment variables.

## Prerequisites

Install dependencies:

```sh
swift package update
```

Build an executable:

```sh
swift build
```

## Running

Run the app to convert `Assets/config.yml` file with configuration in `yaml` format to `Assets/.env` file with configuration represented as a list of environment variables:

```sh
swift run envy make --from config.yml --to .env && cat Assets/.env
```

For instance, if file `Assets/config.yml` looks like this:

```yml
foo:
  bar: baz
  qux: quux
corge:
  grault:
    garply: waldo
fred:
  - xyzzy
  - plugh
  - thud
```

Then generated `Assets/.env` file will look like this:

```sh
CORGE_GRAULT_GARPLY=waldo

FOO_BAR=baz
FOO_QUX=quux

FRED=xyzzy,plugh,thud
```

Notice that keys are sorted when generating `Assets/.env` file.

### Generating config reader

In addition, the tools supports generation of the config reader for `javascript`. This feature can be utilized by passing an additional `--reader/-r` flag like follows:

```sh
swit run envy make --from config.yml --to .env --reader
```

For the example given above, the following config reader which will be generated and saved as `Assets/.env.reader.js`:

```js
export const config = {
  "corge" : {
    "grault" : {
      "garply": process.env.CORGE_GRAULT_GARPLY
    }
  },
  "foo" : {
    "bar": process.env.FOO_BAR,
    "qux": process.env.FOO_QUX
  },
  "fred": process.env.FRED
}
```

### Generating config with alternative naming conventions

By default upper-snake-case naming convention is utilized, but this behavior can be changed by passing flag `--kebab-case/-k`. Currently only kebab-case is supported as an alternative naming convention. Notice that when using the kebab-case naming convention, config reader cannot be generated because in this case an additional preprocessor for the `.env` file is required, which depends on the platform and framework used in your particular application. The following call demonstrates the usage of the described flag:

```sh
swift run envy make --from config.yml --to .env --kebab-case
```

For the example presented above, the following config will be generated in response to the given call:

```sh
corge-grault-garply=waldo

foo-bar=baz
foo-qux=quux

fred=xyzzy,plugh,thud
```
