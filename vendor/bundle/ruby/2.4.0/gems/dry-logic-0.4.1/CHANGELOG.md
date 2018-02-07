# v0.4.1 2017-01-23

### Changed

* Predicates simply reuse other predicate methods instead of referring to them via `#[]` (georgemillo)

### Fixed

* Warnings on MRI 2.4.0 are gone (jtippett)

[Compare v0.4.0...v0.4.1](https://github.com/dryrb/dry-logic/compare/v0.4.0...v0.4.1)

# v0.4.0 2016-09-21

This is a partial rewrite focused on internal clean up and major performance improvements. This is also the beginning of the work to make this library first-class rather than "just" a rule backend for dry-validation and dry-types.

### Added

* `Rule#[]` which applies a rule and always returns `true` or `false` (solnic)
* `Rule#bind` which returns a rule with its predicate bound to a given object (solnic)
* `Rule#eval_args` which evaluates unbound-methods-args in the context of a given object (solnic)
* `Logic.Rule` builder function (solnic)
* Nice `#inspect` on rules and operation objects (solnic)

### Changed

* [BRAEKING] New result API (solnic)
* [BREAKING] `Predicate` is now `Rule::Predicate` (solnic)
* [BREAKING] `Rule::Conjunction` is now `Operation::And` (solnic)
* [BREAKING] `Rule::Disjunction` is now `Operation::Or` (solnic)
* [BREAKING] `Rule::ExlusiveDisjunction` is now `Operation::Xor` (solnic)
* [BREAKING] `Rule::Implication` is now `Operation::Implication` (solnic)
* [BREAKING] `Rule::Set` is now `Operation::Set` (solnic)
* [BREAKING] `Rule::Each` is now `Operation::Each` (solnic)
* [BREAKING] `Rule.new` accepts a predicate function as its first arg now (solnic)
* [BREAKING] `Rule#name` is now `Rule#id` (solnic)
* `Rule#parameters` is public now (solnic)

[Compare v0.3.0...v0.4.0](https://github.com/dryrb/dry-logic/compare/v0.3.0...v0.4.0)

# v0.3.0 2016-07-01

### Added

* `:type?` predicate imported from dry-types (solnic)
* `Rule#curry` interface (solnic)

### Changed

* Predicates AST now includes information about args (names & possible values) (fran-worley + solnic)
* Predicates raise errors when they are called with invalid arity (fran-worley + solnic)
* Rules no longer evaluate input twice when building result objects (solnic)

[Compare v0.2.3...v0.3.0](https://github.com/dryrb/dry-logic/compare/v0.2.3...v0.3.0)

# v0.2.3 2016-05-11

### Added

* `not_eql?`, `includes?`, `excludes?` predicates (fran-worley)

### Changed

* Renamed `inclusion?` to `included_in?` and deprecated `inclusion?` (fran-worley)
* Renamed `exclusion?` to `excluded_from?` and deprecated `exclusion?` (fran-worley)

[Compare v0.2.2...v0.2.3](https://github.com/dryrb/dry-logic/compare/v0.2.2...v0.2.3)

# v0.2.2 2016-03-30

### Added

* `number?`, `odd?`, `even?` predicates (fran-worley)

[Compare v0.2.1...v0.2.2](https://github.com/dryrb/dry-logic/compare/v0.2.1...v0.2.2)

# v0.2.1 2016-03-20

### Fixed

* Result AST for `Rule::Each` correctly maps elements with eql inputs (solnic)

# v0.2.0 2016-03-11

### Changed

* Entire AST has been redefined (solnic)

[Compare v0.1.4...v0.2.0](https://github.com/dryrb/dry-logic/compare/v0.1.4...v0.2.0)

# v0.1.4 2016-01-27

### Added

* Support for hash-names in `Check` and `Result` which can properly resolve input
  from nested results (solnic)

[Compare v0.1.3...v0.1.4](https://github.com/dryrb/dry-logic/compare/v0.1.3...v0.1.4)

# v0.1.3 2016-01-27

### Added

* Support for resolving input from `Rule::Result` (solnic)

### Changed

* `Check` and `Result` carry original input(s) (solnic)

[Compare v0.1.2...v0.1.3](https://github.com/dryrb/dry-logic/compare/v0.1.2...v0.1.3)

# v0.1.2 2016-01-19

### Fixed

* `xor` returns wrapped results when used against another result-rule (solnic)

[Compare v0.1.1...v0.1.2](https://github.com/dryrb/dry-logic/compare/v0.1.1...v0.1.2)

# v0.1.1 2016-01-18

### Added

* `Rule::Attr` which can be applied to a data object with attr readers (SunnyMagadan)
* `Rule::Result` which can be applied to a result object (solnic)
* `true?` and `false?` predicates (solnic)

[Compare v0.1.0...v0.1.1](https://github.com/dryrb/dry-logic/compare/v0.1.0...v0.1.1)

# v0.1.0 2016-01-11

Code extracted from dry-validation 0.4.1
