Puppet Parser API Example
#########################

An example implementation of the Puppet Parser API available starting with Puppet 4.8.0,
currently described in [PR8](https://github.com/hlindberg/misc-puppet-docs/pull/8) and
[parser_api.md](https://github.com/hlindberg/misc-puppet-docs/blob/d1cbf17d720be4bede5352b25b21324474b73958/parser_api/parser_api.md).

### Getting Started

Clone this project and run `bundle install`. It only requires the puppet gem and dependencies.

### Usage

    bundle exec example.rb <filename> [<filename> .. <filename>]

Run `example.rb` and pass it at least one readable filename containing puppet DSL.
The repository includes `testing.pp` which contains a mix of valid and invalid DSL.
