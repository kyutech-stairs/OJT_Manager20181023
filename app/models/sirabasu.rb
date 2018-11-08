class Sirabasu < ApplicationRecord
    has_many :checklists, dependent: :destroy
    validates :number, :numericality => { :only_interger => true }
    validates :name, {presence: true,length: {maximum: 100}}
    validates :content, {presence: true,length: {maximum: 100}}
end
