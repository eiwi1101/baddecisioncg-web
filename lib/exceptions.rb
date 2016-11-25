module Exceptions
  # Global Things
  class RuleViolation < RuntimeError; end

  # Round Things
  class CardTypeViolation < RuleViolation; end
  class PlayerHandViolation < RuleViolation; end
  class DiscardedCardViolation < RuleViolation; end
  class RoundOrderViolation < RuleViolation; end
  class RoundMismatchViolation < RuleViolation; end

  # Game Things
  class GameStatusViolation < RuleViolation; end
  class UserLobbyViolation < RuleViolation; end
  class PlayerExistsViolation < RuleViolation; end

  # Lobby Things
  class LobbyClosedViolation < RuleViolation; end
  class LobbyPermissionViolation < RuleViolation; end
end
