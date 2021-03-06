class Interaction < ActiveRecord::Base


  belongs_to :concierge_request, :touch => true

  belongs_to :interactable, :polymorphic => true, :dependent => :destroy
  
  belongs_to :conversation
end
