class BulkDiscount < ApplicationRecord
  validates :percentage_discount, presence:true, numericality: {only_float: true}
  belongs_to :merchant
  # has_many :
  # has_many :, through: :
end