class Admin < ApplicationRecord
  devise :database_authenticatable, :timeoutable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist
end
