class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email,
             :pan_number, :adhaar_number, :status
end
