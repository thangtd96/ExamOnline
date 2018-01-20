class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "Room"
  belongs_to :followed, class_name: "User"
  after_save :make_notification
  after_destroy :make_notification_leave_room

  private

  def make_notification
    Room.find_by(id: self.follower_id).following.each do |user|
      Notification.create sender_id: self.followed_id, receiver_id: user.id, checked: true
    end
  end

  def make_notification_leave_room
    Room.find_by(id: self.follower_id).following.each do |user|
      Notification.create sender_id: self.followed_id, receiver_id: user.id, checked: false
    end
  end
end