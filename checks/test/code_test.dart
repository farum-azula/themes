import 'package:flutter_test/flutter_test.dart';
import 'package:spring_boot_starter_flutter/spring_boot_starter_flutter.dart';

import 'support.dart';

final _theme = themeFile('code').data('light');

List<CodeToken> _of(String code, String language) =>
    CodeTokens.of(code, _theme.syntaxOf(language));

List<(String, CodeTokenKind)> _tokens(String code, String language) => [
  for (final token in _of(code, language))
    if (token.kind != CodeTokenKind.plain) (token.text, token.kind),
];

void main() {
  group('code.yml', () {
    test('Dart', () {
      expect(
        _tokens(
          "@Service()\nfinal class A { // one\n  var b = 'x'; int c = 42;\n}",
          'dart',
        ),
        [
          ('@Service', CodeTokenKind.annotation),
          ('()', CodeTokenKind.punctuation),
          ('final', CodeTokenKind.keyword),
          ('class', CodeTokenKind.keyword),
          ('{', CodeTokenKind.punctuation),
          ('// one', CodeTokenKind.comment),
          ('var', CodeTokenKind.keyword),
          ("'x'", CodeTokenKind.string),
          (';', CodeTokenKind.punctuation),
          ('int', CodeTokenKind.type),
          ('42', CodeTokenKind.number),
          (';', CodeTokenKind.punctuation),
          ('}', CodeTokenKind.punctuation),
        ],
      );
    });

    test('YAML', () {
      expect(
        _tokens(
          'server:\n  port: 8080 # the port\n  name: "shop"\n  ssl: false',
          'yaml',
        ),
        [
          ('server', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('port', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('8080', CodeTokenKind.number),
          ('# the port', CodeTokenKind.comment),
          ('name', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('"shop"', CodeTokenKind.string),
          ('ssl', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('false', CodeTokenKind.keyword),
        ],
      );
    });

    test('YAML: flow maps and lists, units, references, anchors', () {
      expect(
        _tokens(
          '- durations: { fast: 120ms, medium: 0.25s }\n'
              '  colors: [\$neon.accent, \$neon.cyan]\n'
              '  base: &base { alpha: 35% }\n'
              '  copy: *base\n'
              '  port: \${PORT:8080} # env\n'
              '  text: |\n'
              '  url: https://a.dev/x:1',
          'yaml',
        ),
        [
          ('-', CodeTokenKind.punctuation),
          ('durations', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('{', CodeTokenKind.punctuation),
          ('fast', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('120ms', CodeTokenKind.number),
          (',', CodeTokenKind.punctuation),
          ('medium', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('0.25s', CodeTokenKind.number),
          ('}', CodeTokenKind.punctuation),
          ('colors', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('[', CodeTokenKind.punctuation),
          (r'$neon.accent', CodeTokenKind.variable),
          (',', CodeTokenKind.punctuation),
          (r'$neon.cyan', CodeTokenKind.variable),
          (']', CodeTokenKind.punctuation),
          ('base', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('&base', CodeTokenKind.variable),
          ('{', CodeTokenKind.punctuation),
          ('alpha', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('35%', CodeTokenKind.number),
          ('}', CodeTokenKind.punctuation),
          ('copy', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('*base', CodeTokenKind.variable),
          ('port', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          (r'${PORT:8080}', CodeTokenKind.variable),
          ('# env', CodeTokenKind.comment),
          ('text', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('|', CodeTokenKind.punctuation),
          ('url', CodeTokenKind.key),
          (':', CodeTokenKind.punctuation),
          ('https://a.dev/x:1', CodeTokenKind.string),
        ],
      );
    });

    test('YAML and properties: a value without quotes is a string', () {
      expect(_tokens('curve: ease-out\nb: { c: linear }', 'yaml'), [
        ('curve', CodeTokenKind.key),
        (':', CodeTokenKind.punctuation),
        ('ease-out', CodeTokenKind.string),
        ('b', CodeTokenKind.key),
        (':', CodeTokenKind.punctuation),
        ('{', CodeTokenKind.punctuation),
        ('c', CodeTokenKind.key),
        (':', CodeTokenKind.punctuation),
        ('linear', CodeTokenKind.string),
        ('}', CodeTokenKind.punctuation),
      ]);
      expect(_tokens('a.b=on-time', 'properties'), [
        ('a.b', CodeTokenKind.key),
        ('=', CodeTokenKind.punctuation),
        ('on-time', CodeTokenKind.string),
      ]);
    });

    test('YAML: a flow collection over several lines', () {
      expect(_tokens('a: [\n  b: 1,\n  2 ]', 'yaml'), [
        ('a', CodeTokenKind.key),
        (':', CodeTokenKind.punctuation),
        ('[', CodeTokenKind.punctuation),
        ('b', CodeTokenKind.key),
        (':', CodeTokenKind.punctuation),
        ('1', CodeTokenKind.number),
        (',', CodeTokenKind.punctuation),
        ('2', CodeTokenKind.number),
        (']', CodeTokenKind.punctuation),
      ]);
    });

    test('Dart: types and punctuation', () {
      expect(_tokens('int a = 1;', 'dart').first, ('int', CodeTokenKind.type));
      expect(_tokens('final a = <String>[];', 'dart'), [
        ('final', CodeTokenKind.keyword),
        ('String', CodeTokenKind.type),
        ('[];', CodeTokenKind.punctuation),
      ]);
    });

    test('shell and JSON', () {
      expect(_tokens(r'echo $HOME && ls', 'sh'), [
        ('echo', CodeTokenKind.keyword),
        (r'$HOME', CodeTokenKind.variable),
        ('&&', CodeTokenKind.punctuation),
      ]);
      expect(_tokens('{"a": [1]}', 'json'), [
        ('{', CodeTokenKind.punctuation),
        ('"a"', CodeTokenKind.key),
        (':', CodeTokenKind.punctuation),
        ('[', CodeTokenKind.punctuation),
        ('1', CodeTokenKind.number),
        (']}', CodeTokenKind.punctuation),
      ]);
    });

    test('properties', () {
      expect(_tokens('# c\nserver.port=8080', 'properties'), [
        ('# c', CodeTokenKind.comment),
        ('server.port', CodeTokenKind.key),
        ('=', CodeTokenKind.punctuation),
        ('8080', CodeTokenKind.number),
      ]);
    });

    test('the pieces join to the code', () {
      const code = "a: 'b' # c\n- d: [1, 2]";
      expect(_of(code, 'yaml').map((t) => t.text).join(), code);
      expect(_of(code, 'cobol').single.kind, CodeTokenKind.plain);
      for (final (text, language) in [
        ("a: { b: [1, 'x', \"y\"], c: \${d:e} } # f\n- - g: &h *i", 'yaml'),
        ("k: 'it''s'\nl: \"\\\"\"\nm: [\n  n,\n  { o: p }\n]\n---\n", 'yaml'),
        ('q: |\n  r: s\n  t\nu: !tag v', 'yaml'),
        (r'a=${b:c},d  # e', 'properties'),
        (r'echo "$A" | grep -v ${B}; ls', 'sh'),
        ("final f = <A<B>>{'k': [1, 2.5e3]}; // c", 'dart'),
      ]) {
        expect(
          _of(text, language).map((t) => t.text).join(),
          text,
          reason: text,
        );
      }
    });
  });
}
