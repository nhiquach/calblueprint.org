# == Schema Information
#
# Table name: semesters
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  season              :string(255)
#  year                :string(255)
#  is_current_semester :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Semester, type: :model do
  it { should have_many :student_applications }
  it { should enumerize(:season).in(:fall, :spring) }
  it { should validate_presence_of :year }
  it { should validate_uniqueness_of(:year).scoped_to(:season) }
end
