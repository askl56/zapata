require 'zapata'
require 'coveralls'

Coveralls.wear!
# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause this
# file to always be loaded, without a need to explicitly require it in any files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, make a
# separate helper file that requires this one and then use it only in the specs
# that actually need it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # The settings below are suggested to provide a good initial experience
  # with RSpec, but feel free to customize to your heart's content.
=begin
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
    expectations.syntax = :expect
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = true
  end
=end
end

# Helper methods
RAILS_TEST_APP_DIR = "#{Dir.pwd}/spec/support/rails_test_app"

def clean(string)
  string.split(/\n/).map(&:strip).join("\n")
end

def expected(code)
  clean(
    <<-EXPECTED
      #{code}
    EXPECTED
  )
end

def exec_generation(generate_for)
  stdin, stdout, stderr = Bundler.with_clean_env do
    Open3.popen3(
      "cd #{RAILS_TEST_APP_DIR} && bundle exec zapata generate #{generate_for} -s"
    )
  end

  output = stdout.readlines
  begin
    generated_filename = output.last.match(/File\ (.+)\ was/)[1]
  rescue
    raise "Did not get the message that file was generated. Got this instead:
      STDOUT: #{output}
      STDERR: #{stderr.readlines}"
  end
  spec_path = "#{RAILS_TEST_APP_DIR}/#{generated_filename}"

  clean(
    <<-ACTUAL
      #{File.read(spec_path)}
    ACTUAL
  )
end

def has_block(name, expected_content)
  generated_lines = @generated.split("\n")
  it_starts = generated_lines.index { |line| line == "it '#{name}' do" }
  raise 'No such block' unless it_starts

  might_match_lines = generated_lines[it_starts..-1]
  it_ends = might_match_lines.index { |line| line == 'end' }

  block = might_match_lines[1...it_ends].first
  expect(block).to eq(expected_content.strip)
end
