class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :create, Photo

    can :read, Photo, archive: false
    can(%i[read update destroy], Photo, user:)

    can %i[read create], Comment, photo: { archive: false }
    can %i[read destroy], Comment, photo: { user: }
    can(:destroy, Comment, user:)

    can %i[read create], Reply, comment: { photo: { archive: false } }
    can %i[read destroy], Reply, comment: { photo: { user: } }
    can(:destroy, Reply, user:)

    can %i[read create], PhotoLike, photo: { archive: false }
    can :read, PhotoLike, photo: { user: }
    can(:destroy, PhotoLike, user:)

    can %i[read create], CommentLike, comment: { photo: { archive: false } }
    can :read, CommentLike, comment: { photo: { user: } }
    can(:destroy, CommentLike, user:)

    can %i[read create], ReplyLike, reply: { comment: { photo: { archive: false } } }
    can :read, ReplyLike, reply: { comment: { photo: { user: } } }
    can(:destroy, ReplyLike, user:)

    can :manage, :all if user.email == 'admin@email.com'
  end
end
