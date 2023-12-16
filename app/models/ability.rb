class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :create, :all

    can :read, Photo, archive: false
    can(%i[read update destroy], Photo, user:)

    can :read, Comment, photo: { archive: false }
    can %i[read destroy], Comment, photo: { user: }
    can(:destroy, Comment, user:)




    can :manage, :all if user.email == 'admin@email.com'
  end
end
