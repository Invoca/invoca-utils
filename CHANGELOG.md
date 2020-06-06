# CHANGELOG for `invoca-utils`

Inspired by [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Note: This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0] - Unreleased
### Added
- Added `Invoca::Utils.retry_on_exception`.

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

[0.4.0]: https://github.com/Invoca/invoca-utils/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/Invoca/invoca-utils/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/Invoca/invoca-utils/compare/v0.1.1...v0.2.0
