class Post < ApplicationRecord
  belongs_to :project, optional: true
  has_one_attached :image

  validates :text,
            length: { maximum: 700 }

  validate :content_presence
  validates :image,
            content_type: ["image/png", "image/jpg", "image/jpeg"],
            aspect_ratio: :is_4_5,
            dimension: {
              width: { min: 320, max: 1080 },
              height: { min: 566, max: 1350 }
            }

  belongs_to :user
  belongs_to :project, optional: true

  acts_as_votable

  include Commentable

  # Custom validators
  def content_presence
    errors.add(:base, "a post should have content") unless content?
  end

  def self.custom_create(user:, data:)
    post = Post.new(text: data["text"])
    post.auto_generated = false
    post.image.attach(data["image"])
    post.user = user

    post.set_project(project_identifier: data["project"])
    post.save
    post
  end

  def url
    "/posts/#{id}"
  end

  def content?
    !text.blank? || image.attached?
  end

  def ordered_comments
    comments.order(created_at: "desc")
  end

  def set_project(project_identifier:)
    self.project =
      Project.find_by(id: project_identifier) ||
      Project.create(user: user, title: project_identifier)
  end
end
