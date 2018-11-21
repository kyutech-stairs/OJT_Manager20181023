class Checklist < ApplicationRecord
    belongs_to :sirabasu
    validates :number, :numericality => { :only_interger => true }
    validates :content, {presence: true,length: {maximum: 200}}

    has_many :checkusers, dependent: :destroy
    has_many :kanrisyas, through: :checkusers
    accepts_nested_attributes_for :checkusers
end
