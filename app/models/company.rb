class Company < ApplicationRecord
  validates :cname, presence: true, length: { maximum: 50 }
  validates :cname_sub, length: { maximum: 50 }
  validates :pas, length: { maximum: 4 }
end
