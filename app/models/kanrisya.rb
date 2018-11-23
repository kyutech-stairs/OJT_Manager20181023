class Kanrisya < ApplicationRecord
  # Include default devise modules. Others available are:
  # 名前は必ず書く
  # 年齢は0~149、初期値0(viewで指定)
  # 社員番号は必ず書く（15文字まで）
  # 性別は必ず選択
  # 所属は必ず選択
  validates :name, presence: true, length: { maximum: 50 }
  validates :age, numericality: {only_integer: true}
  validates :crew_number, presence: true, length: { maximum: 15 }
  validates :sex, presence: true
  validates :belong, presence: true
  validates :image, presence: true
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  serialize :check

  mount_uploader :image, ImageUploader

  has_many :checkusers, dependent: :destroy
  has_many :checklists, through: :checkusers
  accepts_nested_attributes_for :checkusers

  has_many :sirabasuusers, dependent: :destroy
  has_many :sirabasus, through: :sirabasuusers
  accepts_nested_attributes_for :sirabasuusers
end
