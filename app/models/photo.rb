class Photo < ActiveRecord::Base
  belongs_to :photoable, :polymorphic => true
  attr_accessor :parent_type
  attr_accessible :image, :title, :description, :photoable_type
  


  unless Rails.env.development?
    paperclip_opts = { :storage => :s3,
      :s3_credentials => "#{Rails.root}/config/s3.yml",
      :path => "/:id/:style/:basename.:extension",
      :styles => Proc.new { |clip| clip.instance.styles }    }
  else
    paperclip_opts = {
        :styles => Proc.new { |clip| clip.instance.styles },
    }
  end

  has_attached_file :image, paperclip_opts

  after_create  :reprocess

  def styles
    p "photoable_type #{self.photoable_type}"
    if self.photoable_type == 'Profile'
      { :medium => ['260x260#', :png], :thumb => ['60x60#', :png] }
    elsif self.photoable_type == 'Promotion'
      p "promotionable_type #{self.photoable.promotionable_type}"
      if self.photoable.promotionable_type == 'Event'
        { :medium => ['360x268#', :png], :carousel => ['870x400#', :png]}
      elsif  self.photoable.promotionable_type == 'Offer'
        { :medium => ['210x100#', :png]}
      end
    elsif self.photoable_type.nil?
      p "photoable_type is nil "
      { :medium => ['260x260#', :png], :thumb => ['60x60#', :png] }
    end
  end




  private

  def reprocess
    #todo add condition for events
    self.image.reprocess!
  end


end
