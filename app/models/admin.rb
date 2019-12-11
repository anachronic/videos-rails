class Admin < ApplicationRecord
  devise :database_authenticatable, :timeoutable,
         :recoverable, :rememberable, :validatable
end
