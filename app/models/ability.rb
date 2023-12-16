class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :create, :all
    can :read, Photo, archive: false
    can(%i[update destroy], Photo, user:)

    can :manage, :all if user.email == 'admin@email.com'
  end
end
