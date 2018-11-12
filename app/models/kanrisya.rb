class Kanrisya < ApplicationRecord
  # Include default devise modules. Others available are:
  validates :name, presence: true, length: { maximum: 50 }
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  serialize :check

  has_many :checkusers, dependent: :destroy
  has_many :checklists, through: :checkusers
  accepts_nested_attributes_for :checkusers
end
