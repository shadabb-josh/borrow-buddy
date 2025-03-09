require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/config/"
  add_filter "/vendor/"
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Services", "app/services"
  add_group "Mailers", "app/mailers"
  add_group "Jobs", "app/jobs"
  add_group "Concerns", "app/controllers/concerns"
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Run only tests with `:focus` metadata if present, otherwise run all tests
  config.filter_run_when_matching :focus

  # Allow RSpec to persist state for `--only-failures` and `--next-failure`
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Disable monkey patching for better readability and maintainability
  config.disable_monkey_patching!

  # Use documentation format for detailed output when running a single spec file
  config.default_formatter = "doc" if config.files_to_run.one?

  # Show the slowest 10 examples at the end of the test run
  config.profile_examples = 10

  # Run specs in random order to identify order-dependent failures
  config.order = :random
  Kernel.srand config.seed
end
