class Company < ApplicationRecord
  validates :cname, presence: true, length: { maximum: 50 }
  validates :cname_sub, length: { maximum: 50 }
  validates :password, length: { maximum: 4 }
end
