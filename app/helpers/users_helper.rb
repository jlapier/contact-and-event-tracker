module UsersHelper
  def roles_for_select
    User.roles_as_array.collect{|r| [r.capitalize, r]}
  end
end
