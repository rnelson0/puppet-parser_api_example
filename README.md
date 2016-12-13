Puppet Parser API Example
#########################

An example implementation of the Puppet Parser API available starting with Puppet 4.8.0,
currently described in [PR8](https://github.com/hlindberg/misc-puppet-docs/pull/8) and
[parser_api.md](https://github.com/hlindberg/misc-puppet-docs/blob/d1cbf17d720be4bede5352b25b21324474b73958/parser_api/parser_api.md).

### Getting Started

Clone this project and run `bundle install`. It only requires the puppet gem and dependencies.

### Usage

To perform parsing and an example of a custom validation, run `example.rb` and pass it at least one readable filename containing puppet DSL.

    bundle exec example.rb <filename> [<filename> .. <filename>]

To perform simple validation, `validate.rb` accepts at least one readable filename and displays any errors it finds

    bundle exec validate.rb <filename> [<filename> .. <filename>]

Example:

    $ be validate.rb puppethack.pp testing.pp
    Validating file puppethack.pp ... OK!
    Validating file testing.pp ... 1 errors 0 warnings
      testing.pp:7:1: Illegal attempt to assign to 'a Name'. Not an assignable reference

The repository also includes `testing.pp`, a mix of valid and invalid DSL, and `puppethack.pp`, valid DSL that does not match the style guide.
