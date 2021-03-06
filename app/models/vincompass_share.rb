class VincompassShare < ActiveRecord::Base

  has_one :promotion, :as => :promotionable, :dependent => :destroy


  has_one :wine_share, :dependent => :destroy
  attr_accessor :wine_name, :year, :region, :grape, :producer, :link, :comment, :restaurant_name, :media_type, :media_url
  before_create :build_promotion, :attach_wine


  def post_activity(user)
    Activity.create(:user_id => user.id,
                    :body => user.profile.name + ' has tried ' + wine_share_name + ' at ' + wine_share_restaurant_name + ' via Vincompass',
                    :resource_type => 'VincompassShare',
                    :resource_id => self.id)
  end

  def wine_share_name
  return ' ' unless self.wine_share.name
  self.wine_share.name
  end

  def wine_share_restaurant_name
    return ' ' unless self.wine_share.restaurant_name
    self.wine_share.restaurant_name
  end



  private

  def attach_wine
    build_wine_share({
                         :name => wine_name,
                         :year => year,
                         :grape => grape,
                         :region => region,
                         :producer => producer,
                         :restaurant_name => restaurant_name,
                         :link => link,
                         :comment => comment,
                         :media_type => media_type,
                         :media_url => media_url})
  end

end
