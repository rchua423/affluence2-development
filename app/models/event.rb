class Event < ActiveRecord::Base

  has_one :promotion, :as => :promotionable, :dependent => :destroy
  has_many :schedules, :dependent => :destroy
  has_many :includes, :dependent => :destroy



  scope :active, where(:status => true)
  scope :draft, where(:status => false)

  scope :past, where('sale_ends_at <= ?', Date.today)
  scope :up_comming, where('sale_ends_at >= ?', Date.today)


  EMAIL_NOTIFICATIONS = {1 => 'registraion',
                 2 => 'schedule',
  }
  EMAIL_NOTIFICATION_METHODS = { 1 => 'event_registration',
                         2 => 'event_reminder',


  }
  EMAIL_REMINDER_SCHEDULE_INTERVAL_DAYS = [1,2] # days before the event starts

  accepts_nested_attributes_for :schedules, :includes


  validates_presence_of :title, :description, :price
  validates_presence_of :carousel_image, :normal_image, :on => :create
  validates :sale_ends_at, :presence => true
  validates :tickets, :presence => true


  has_permalink :title, :update => true


  attr_accessor :carousel_image, :normal_image


  def self.process_tickets(event,tickets,state)
    if state == 'initial'
    initial_process(event,tickets)
    elsif state = 'success'
      success_process(event,tickets)
    elsif state == 'failure'
      failure_process(event,tickets)
    end
  end


  def self.initial_process(event,tickets)
    event = Event.find(event.id)
    if event.tickets_remaining > 0 &&  event.tickets_remaining.to_i >= tickets.to_i
      tickets_remaining = event.tickets_remaining.to_i - tickets.to_i
      in_progress = event.inprogress.to_i + tickets.to_i
      event.update_attributes(:tickets_remaining => tickets_remaining, :inprogress => in_progress)
    end
  end

  def self.success_process(event,tickets)
    event = Event.find(event.id)
    in_progress = event.inprogress.to_i - tickets.to_i
    event.update_attributes(:inprogress => in_progress)
  end


  def self.failure_process(event,tickets)
    event = Event.find(event.id)
    tickets_remaining = event.tickets_remaining.to_i + tickets.to_i
    in_progress = event.inprogress.to_i - tickets.to_i
    event.update_attributes(:tickets_remaining => tickets_remaining, :inprogress => in_progress)
  end

end
 