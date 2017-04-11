class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    user = authenticated_user
    { token: JsonWebToken.encode(user_id: user.id), user: user } if user
  end

  private

  attr_accessor :email, :password

  def authenticated_user
    user = User.find_by_email(@email)
    return user if user && user.authenticate(@password)

    errors.add :authentication, 'Wrong credentials'
    nil
  end
end
