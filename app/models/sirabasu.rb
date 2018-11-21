class Sirabasu < ApplicationRecord
    has_many :checklists, dependent: :destroy
    has_many :images, dependent: :destroy
    has_many :publishing_configs, dependent: :destroy
    accepts_nested_attributes_for :images, allow_destroy: true
    accepts_nested_attributes_for :checklists, allow_destroy: true
    accepts_nested_attributes_for :publishing_configs, allow_destroy: true
    validates :number, :numericality => { :only_interger => true }
    mount_uploaders :image, ImageUploader

    has_many :sirabasuusers, dependent: :destroy
    has_many :kanrisyas, through: :sirabasuusers
    accepts_nested_attributes_for :sirabasuusers
    validates :name, {presence: true,length: {maximum: 100}}
    validates :content, {presence: true,length: {maximum: 1000}}
end
