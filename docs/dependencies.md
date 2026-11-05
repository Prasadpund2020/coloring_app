# Dependency decisions

## `xml` (Phase 3)

- Solves: typed XML parsing for the authored colouring SVG files.
- Why Flutter SDK is not enough: Flutter has no built-in XML document parser.
- Publisher and release: pub.dev package maintained by the Dart ecosystem; the
  installed latest compatible release is `7.1.0`.
- SDK/platform: compatible with this project's Dart 3.13 SDK and Android; null
  safe with no deprecation notices observed during analysis.
- Licence: MIT; commercial use is allowed.
- Permissions/network: parsing is local only; it requests no Android
  permissions and adds no analytics, tracking, or network code.
- Smallest alternative: write a restricted XML tokenizer, which would add
  parser maintenance and weaker validation.

## `path_drawing` (Phase 3)

- Solves: converts SVG path `d` attributes into Flutter `Path` objects.
- Why Flutter SDK is not enough: Flutter does not parse SVG path command data.
- Publisher and release: pub.dev package maintained by the Dart ecosystem; the
  installed latest compatible release is `1.0.1`.
- SDK/platform: compatible with this project's Dart 3.13 SDK and Android; null
  safe with no deprecation notices observed during analysis.
- Licence: MIT; commercial use is allowed.
- Permissions/network: path conversion is local only; it requests no Android
  permissions and adds no analytics, tracking, or network code.
- Smallest alternative: implement all absolute SVG path commands ourselves,
  which would increase parser risk and testing cost.

## `shared_preferences` (Phase 6)

- Solves: persistent local parent settings such as sound effects.
- Permissions/network: stores values locally and does not provide networking.

## `url_launcher` (Phase 6)

- Solves: opening the privacy policy in the platform browser.
- Permissions/network: only launches a user-selected external URL; the app
  itself does not fetch remote content.
