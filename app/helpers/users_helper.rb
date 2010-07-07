module UsersHelper
  def roles_for_select
    User.roles.collect{|r| [r.capitalize, r]}
  end
end
