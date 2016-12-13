#!/usr/bin/ruby

require 'pp'
require 'puppet'

minimum_puppet_version = '4.0.0'
if Gem::Version.new(Puppet::PUPPETVERSION) < Gem::Version.new(minimum_puppet_version)
  puts "ERROR: Puppet Parser API requires Puppet v#{minimum_puppet_version} or better!"
  exit 1
end

# Example of a module setting everything up to perform custom
# validation of an AST model produced by parsing puppet source.
#
module MyValidation
  # We create a diagnostic formatter that outputs the error with a simple predefined
  # format for location, severity, and the message. This format is a typical output from
  # something like a linter or compiler.
  # (We do this because there is a bug in the DiagnosticFormatter's `format` method prior to
  # Puppet 4.9.0. It could otherwise have been used directly.
  #
  class Formatter < Puppet::Pops::Validation::DiagnosticFormatter
    def format(diagnostic)
      "  #{format_location(diagnostic)} #{format_severity(diagnostic)}#{format_message(diagnostic)}"
    end
  end
end

# Track the number of CLI arguments that are unreadable filenames
@unreadable_files = 0

# Usage statement
def usage()
  script_name = $0
  puts <<-USAGE
#{script_name} <filename>

Parses and validates a file containing Puppet DSL
  USAGE

  exit 2
end

def invalid_file(code_file)
  puts "Could not read #{code_file}, skipping."
  @unreadable_files += 1
end

# Ensure at least one CLI arguments was passed
def validate_arguments()
  usage unless ARGV.count > 0
end

# Validate the contents of a file
def validate(code_file)
  print "Validating file #{code_file} ... "
  $stdout.flush

  # Get a parser
  parser = Puppet::Pops::Parser::EvaluatingParser.singleton

  # parse without validation
  result = parser.parser.parse_file(code_file)
  result = result.model

  # validate using the default validator and get hold of the acceptor containing the result
  acceptor = parser.validate(result)

  # -- At this point, we have done everything `puppet parser validate` does except report the errors
  # and raise an exception if there were errors.

  # The acceptor may now contain errors and warnings as found by the standard puppet validation.
  # We could look at the amount of errors/warnings produced and decide it is too much already
  # or we could simply continue. Here, some feedback is printed:
  #

  # Output the errors and warnings using a provided simple starter formatter
  unless acceptor.errors_and_warnings == []
    print "#{acceptor.error_count} errors " if acceptor.error_count
    print "#{acceptor.warning_count} warnings" if acceptor.warning_count
    puts ""

    formatter = MyValidation::Formatter.new

    acceptor.errors_and_warnings.each do |diagnostic|
      puts formatter.format(diagnostic)
    end
  else
    puts "OK!"
  end
end
# Get and validate the filename
validate_arguments

while (code_file = ARGV.shift)
  unless (code_file and File.readable?(code_file) )
    invalid_file(code_file)
    next
  end

  validate(code_file)
end

exit_code = 0
if @unreadable_files > 0
  exit_code = 1
end

exit exit_code
