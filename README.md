# Secret Santa - Ruby service

## Overview
This repository provides a small, modular Secret Santa assignment service implemented as plain Ruby objects (service objects + small models). It is designed to be:

- Correct: ensures no self-assignments, one-to-one matching, and avoidance of previous-year pairings.
- Extensible: small classes can be composed or replaced (readers/writers, assigner logic).
- Testable: includes RSpec examples for core behavior.

## Repository structure (high level)

- `app/models/` — small value objects: `Employee`, `Assignment`.
- `app/services/csv/` — CSV helpers: `EmployeeReader`, `PreviousAssignmentReader`, `AssignmentWriter`.
- `app/services/secret_santa/assigner.rb` — the main assignment algorithm (backtracking solver).
- `app/errors/assignment_error.rb` — custom error raised on assignment problems.
- `spec/` — test suite (RSpec).

## Requirements

- Ruby (recommended 2.6+ or any modern Ruby 2.x/3.x)
- Bundler (to install gems)

## Installation

1. Install Ruby (instructions vary by OS). Example for Debian/Ubuntu:

```bash
sudo apt update && sudo apt install -y ruby ruby-dev build-essential
gem install bundler
```

2. From the project root, install gems:

```bash
cd /home/saran/Downloads/secret_santa_rails
bundle install
```

Note: This repository contains only a small amount of Ruby code and minimal gem dependencies; Bundler will install the test dependencies (RSpec) used in `spec/`.

## CSV input formats

Create a `data/` directory (or any path you prefer). The system expects two CSV inputs:

1) Employees CSV — headers (exact spelling required):

```
Employee_Name,Employee_EmailID
Alice,a@example.com
Bob,b@example.com
Carol,c@example.com
```

2) Previous year assignments CSV (optional) — headers:

```
Employee_Name,Employee_EmailID,Secret_Child_Name,Secret_Child_EmailID
Alice,a@example.com,Bob,b@example.com
Bob,b@example.com,Carol,c@example.com
```

The `PreviousAssignmentReader` returns a mapping keyed by `Employee_EmailID` with values being the `Secret_Child_EmailID` for that employee — used to avoid repeating last year's recipient for that giver.

## Running the assigner

You can run the assigner from an interactive Ruby console (pry/irb) or a small script. Example (console):

```ruby
require_relative 'app/services/csv/employee_reader'
require_relative 'app/services/csv/previous_assignment_reader'
require_relative 'app/services/csv/assignment_writer'
require_relative 'app/services/secret_santa/assigner'

employees = Csv::EmployeeReader.read('data/employees.csv')
previous = Csv::PreviousAssignmentReader.read('data/previous_year.csv')
assignments = SecretSanta::Assigner.new(employees, previous).call
Csv::AssignmentWriter.write('data/output.csv', assignments)

puts "Wrote data/output.csv with #{assignments.size} assignments"
```

Example script (`run_assigner.rb`): create a file and run `ruby run_assigner.rb`.

## What the assigner does

- Validates there are at least two employees.
- Uses a backtracking search to produce a permutation where:
	- `giver.email != receiver.email` (no self-assignments)
	- `receiver.email != previous[giver.email]` (avoid same recipient as last year)
	- each receiver is assigned to exactly one giver.
- Raises `AssignmentError` when no valid assignment exists.

## Error handling

All assignment-specific failures raise `AssignmentError`. Example usage with graceful handling:

```ruby
begin
	assignments = SecretSanta::Assigner.new(employees, previous).call
rescue AssignmentError => e
	warn "Assignment failed: #{e.message}"
	exit 1
end
```

CSV reader errors:
- `Csv::EmployeeReader.read` raises `AssignmentError` when the employees CSV file is missing.
- `Csv::PreviousAssignmentReader.read` returns an empty hash if the previous-year file is not found.

## Tests

Run the test suite with:

```bash
bundle exec rspec --format documentation
```

Core specs live under `spec/services/secret_santa/assigner_spec.rb` and cover self-assignment protection, uniqueness, previous-year avoidance, and impossible-case behavior.
