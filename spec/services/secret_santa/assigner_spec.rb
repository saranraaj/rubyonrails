require 'rails_helper'

RSpec.describe SecretSanta::Assigner do
  let(:employees) do
    [
      Employee.new(name: 'A', email: 'a@test.com'),
      Employee.new(name: 'B', email: 'b@test.com'),
      Employee.new(name: 'C', email: 'c@test.com')
    ]
  end

  it 'does not assign self' do
    assignments = described_class.new(employees).call
    assignments.each do |a|
      expect(a.giver.email).not_to eq(a.receiver.email)
    end
  end

  it 'assigns unique receivers' do
    assignments = described_class.new(employees).call
    receiver_emails = assignments.map { |a| a.receiver.email }
    expect(receiver_emails.uniq.size).to eq(receivers_count = employees.size)
  end

  it 'respects previous year assignments' do
    previous = { 'a@test.com' => 'b@test.com' }
    assignments = described_class.new(employees, previous).call
    assignments.each do |a|
      expect(a.receiver.email).not_to eq(previous[a.giver.email])
    end
  end

  it 'raises AssignmentError when no valid assignment exists' do
    two = [
      Employee.new(name: 'X', email: 'x@test.com'),
      Employee.new(name: 'Y', email: 'y@test.com')
    ]

    # If previous year assignments are swapped, there's no alternative.
    previous = { 'x@test.com' => 'y@test.com', 'y@test.com' => 'x@test.com' }

    expect { described_class.new(two, previous).call }.to raise_error(AssignmentError)
  end
end
