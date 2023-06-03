# Envy

<p align="center">
    <img src="Assets/logo.png"/>
</p>

A miniature tool for flattening configuration files

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
