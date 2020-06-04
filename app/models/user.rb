class User < ApplicationRecord
  acts_as_messageable
  validates :email, presence: true
  validates :zip, presence: true
  validates :flat_id, presence: true
  validates :about, presence: true
  validates :interests, presence: true
  validates :instruments, presence: true


  def distance(distance_list)
    distance_list[zip]
  end

  def mailboxer_email(object)
    return self.email
  end

  def name
    return self.username
  end
  
  def picture
    FlatService.get_user[:picture]
  end
end
