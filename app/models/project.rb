# == Schema Information
#
# Table name: projects
#
#  id               :integer          not null, primary key
#  title            :string
#  short_summary    :string
#  link             :string
#  created_at       :datetime
#  updated_at       :datetime
#  full_description :text
#

class Project < ActiveRecord::Base
  validates :title, presence: true
  validates :short_summary, presence: true
  validates :link, presence: true
  validates :full_description, presence: true
end
