class Assignment
  attr_reader :giver, :receiver

  def initialize(giver:, receiver:)
    @giver = giver
    @receiver = receiver
  end
end
