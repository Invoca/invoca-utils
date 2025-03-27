# CHANGELOG for `invoca-utils`

Inspired by [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

**Note:** This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.6.1] - Unreleased
### Fixed
- Fixed a global namespace collision with diff-lcs over the `Diff` constant

### Added
- Loading `invoca/utils/diff` now gives access to both `invoca-utils` and `diff-lcs` diff helpers

## [0.6.0] - 2024-07-10
### Added
- Require Ruby > 3.1
- Allow ActiveSupport >= 6
### Removed
- Support for Ruby < 3
- Support for ActiveSupport < 6

## [0.5.1] - 2023-02-17
### Added
- Integrated Appraisal into github actions for testing across multiple versions of ActiveSupport
- 
## [0.5.0] - 2023-02-10
### Added
- Relaxed version requirement for ActiveSupport 

## [0.4.1] - 2020-06-17
### Fixed
- Support Ruby < 2.5 by adding `begin`/`end` around `rescue` in `retry_on_exception`. 

## [0.4.0] - 2020-06-09
### Added
- Added `Invoca::Utils.retry_on_exception`.
- Added `Invoca::Utils::GuaranteedUTF8String.normalize_all_strings` to normalize
  all strings found in a JSON doc of hashes, arrays, and values.

## [0.3.0] - 2020-04-28
### Added
- Array::* operator changed to use alias_method instead of prepend to prevent infinite recursion when HoboSupport gem is present
- Enumerable::map_and_find, map_with_index, and map_hash methods ported from HoboSupport
- Hash::select_hash, map_hash, partition_hash, & and - methods ported from HoboSupport
- HashWithIndifferentAccess::partition_hash, & and - methods ported from HoboSupport
- Module::alias_method_chain ported from HoboSupport

## [0.2.0] - 2020-04-27
### Added
- Enumerable::build_hash method ported from HoboSupport
- Enumerable::* operator ported from HoboSupport

[0.5.1]: https://github.com/Invoca/invoca-utils/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/Invoca/invoca-utils/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/Invoca/invoca-utils/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/Invoca/invoca-utils/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/Invoca/invoca-utils/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/Invoca/invoca-utils/compare/v0.1.1...v0.2.0
