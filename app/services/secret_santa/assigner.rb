module SecretSanta
  class Assigner
    def initialize(employees, previous_year_map = {})
      @employees = employees
      @previous_year_map = previous_year_map
    end

    def call
      raise AssignmentError, 'At least two employees required' if @employees.size < 2

      # Kick off the backtracking search. We pass the same list for givers and
      # receivers — receivers will be consumed as the recursion assigns them.
      assignments = find_assignments(@employees, @employees)
      return assignments if assignments

      # No valid full assignment was found under the constraints provided.
      raise AssignmentError, 'Unable to generate valid assignments'
    end

    private

    # Backtracking search for a valid assignment permutation.
    # Core Logic:
    # 1. If there are no givers left, we've successfully assigned everyone —
    #    return an empty list to start unwinding the recursion.
    # 2. Take the first giver and build a list of `candidates` from the
    #    remaining receivers that satisfy the local constraints:
    #      - not the giver themself
    #      - not the same receiver as last year for this giver
    #    The candidate list is shuffled to introduce non-determinism.
    # 3. For each candidate, remove that receiver from the available pool and
    #    recursively attempt to assign the remaining givers. If the recursion
    #    returns a valid sub-assignment, prepend the current (giver ->
    #    candidate) assignment and return the combined result.
    # 4. If no candidate leads to a full valid assignment, return `nil` to
    #    signal failure and trigger backtracking.
    def find_assignments(givers, receivers)
      return [] if givers.empty?

      giver = givers.first

      # Build candidate receivers for this giver, enforcing constraints.
      candidates = receivers.select do |r|
        r.email != giver.email && @previous_year_map[giver.email] != r.email
      end.shuffle

      candidates.each do |candidate|
        # Remove the chosen receiver for the recursive call so they aren't
        # assigned multiple times.
        remaining_receivers = receivers.reject { |r| r.email == candidate.email }

        # Attempt to find valid assignments for the remaining givers.
        sub = find_assignments(givers[1..-1], remaining_receivers)
        next unless sub

        # Prepend current pairing and return the successful arrangement.
        return [Assignment.new(giver: giver, receiver: candidate)] + sub
      end

      # No candidate worked for this giver under the current partial state.
      nil
    end
  end
end
