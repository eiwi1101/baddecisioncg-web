module Exceptions
  # Global Things
  class RuleViolation < RuntimeError; end

  # Round Things
  class PlayerHandViolation < RuleViolation; end
  class DiscardedCardViolation < RuleViolation; end
  class RoundOrderViolation < RuleViolation; end
end
