# Nix Flake Templates

A collection of personal nix flake templates, mainly development focussed, which
I put together to save me a minute or three whilst writing software.

## Pre-requisites

- **Nix** _(obviously)_ with experimental features enabled for commands and
  flakes
- **direnv** _(optional)_ so each flake is applied automatically on entry to the
  project directory

## Available Templates

- csharp/dotnet - _the official SDK for .NET (previously .NET Core) development_
- hugo - A simple environment for building Hugo websites
- javascript/js/node - _JavaScript/node environment, predominantly for building
  web apps_
- phoenix - _Devbox environment tailored for Elixir/Phoenix development_
- prisma - _JavaScript/node environment with prisma available, for building
  database-driven apps_
- rails - _Environment tailored for ruby on rails, including node environment,
  and a wrapper to pass `yarn` calls from rails to `pnpm` instead_
- railswithoutnode - _Environment tailored for ruby on rails which has no
  dependency on node - be sure to use the plain or API template, or the
  standalone tailwind template using `bundle exec rails . -c tailwind`_
- ruby - _Bundler-enabled ruby environment, for building any app_

## Usage

```
mkdir <project-dir>
cd <project-dir>
nix flake init -t github:arti5an/templates#<template-name>
direnv allow
```
