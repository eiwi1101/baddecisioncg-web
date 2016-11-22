module Exceptions
  # Global Things
  class RuleViolation < RuntimeError; end

  # Round Things
  class CardTypeViolation < RuleViolation; end
  class PlayerHandViolation < RuleViolation; end
  class DiscardedCardViolation < RuleViolation; end
  class RoundOrderViolation < RuleViolation; end
  class RoundMismatchViolation < RuleViolation; end
end
