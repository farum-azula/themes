# Themes for Spring for Dart

Themes and design systems for
[`spring_boot_starter_flutter`](https://pub.dev/packages/spring_boot_starter_flutter):
the look of an app written in YAML, and the libraries of widgets that
read it.

| Folder | What |
|---|---|
| [`packages/`](packages/) | Flutter libraries: widgets, fonts, pictures and the theme files they ship |
| [`themes/`](themes/) | Theme files alone (`*.yml`), to import into an app |

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

Actions → **Release** → Run workflow, with the package (`neon_ui`) and
the bump: `major`, `minor` or `patch`. CI checks every package; then the
version in the package's `pubspec.yaml` is raised, committed to `main`,
tagged `<package>-v<version>` and published as a GitHub release. Apps pin
the tag in `ref:`.

Nothing here is published on pub.dev.

## Test

```bash
cd packages/neon_ui
flutter pub get
flutter test
```
