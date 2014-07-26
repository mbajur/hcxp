class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # Guests
    can :read, :all
    can :browse, Event

    # Members
    unless user.new_record?
      can [:edit, :update, :new, :create], Event, user_id: user.id
      can [:edit, :update, :new, :create], Band
      can [:edit, :update, :new, :create], Venue
      can [:toggle_save], Event
    end

    if user.is_admin
      can [:toggle_promote], Event
      can [:destroy], Event, persisted?: true
      can [:edit, :update], Event
    end
  end
end
