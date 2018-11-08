class Kanrisya < ApplicationRecord
  # Include default devise modules. Others available are:
  validates :name, presence: true, length: { maximum: 50 }
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
