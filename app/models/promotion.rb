class Promotion < ActiveRecord::Base
  has_many :photos, :as => :photoable, :dependent => :destroy
  belongs_to :promotionable, :polymorphic => true, :dependent => :destroy
  has_and_belongs_to_many :users

  has_many :registered_members,  :class_name => 'PayablePromotion'
end
