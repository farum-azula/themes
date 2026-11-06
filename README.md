# Themes for Spring for Dart

Themes and design systems for
[`spring_boot_starter_flutter`](https://pub.dev/packages/spring_boot_starter_flutter):
the look of an app written in YAML, and the libraries of widgets that
read it.

| Folder | What |
|---|---|
| [`packages/`](packages/) | Flutter libraries: widgets, fonts, pictures and the theme files they ship |
| [`themes/`](themes/) | Theme files alone (`*.yml`), to import into an app |

## Theme files

| File | What |
|---|---|
| [`themes/code.yml`](themes/code.yml) | The languages of code blocks (`syntax.*`): Dart, Java, YAML, properties, shell, JSON |

A theme file is downloaded by the app, for every theme with `source` on
`spring.flutter.theme`, or as one theme with `themes.<name>.source`:

```yaml
spring:
  flutter:
    theme:
      source: github:farum-azula/themes/themes/code.yml@code-v0.2.0
```

`checks/` tests them against `spring_boot_starter_flutter`.

## Packages

| Package | What |
|---|---|
| [`neon_ui`](packages/neon_ui/README.md) | NEON: a design system for apps of type `widgets`, with its theme, fonts, background and the `neon-gate` splash |

A package is taken from this repository:

```yaml
dependencies:
  neon_ui:
    git:
      url: https://github.com/farum-azula/themes.git
      path: packages/neon_ui
      ref: neon_ui-v0.2.0
```

## Releases

Actions → **Release** → Run workflow, with what to release (a package,
`neon_ui`, or a theme file, `code`) and the bump: `major`, `minor` or
`patch`. CI checks everything; then the version (the package's
`pubspec.yaml`, or `themes/<name>.version`) is raised, committed to `main`,
tagged `<name>-v<version>` and published as a GitHub release. Apps pin the
tag: `ref:` of a package, `@<tag>` of a theme file.

Nothing here is published on pub.dev.

## Test

```bash
cd packages/neon_ui
flutter pub get
flutter test
```
