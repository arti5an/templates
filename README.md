# Nix Flake Templates

A collection of personal nix flake templates, mainly development focussed, which
I put together to save me a minute or three while writing software.

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
- prisma - _JavaScript/node environment with prisma available, for building
  database-driven apps_
- rails - _Environment tailored for ruby on rails, including node environment,
  and a wrapper to pass `yarn` calls from rails to `pnpm` instead_
- ruby - _Bundler-enabled ruby environment, for building any app_

## Usage

```
mkdir <project-dir>
cd <project-dir>
nix flake init -t github:arti5an/flake-templates#<template-name>
direnv allow
```
