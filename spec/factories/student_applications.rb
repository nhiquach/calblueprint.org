# == Schema Information
#
# Table name: student_applications
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  applicant_id        :integer
#  semester_id         :integer
#  why_join            :text
#  resume_file_name    :string(255)
#  resume_content_type :string(255)
#  resume_file_size    :integer
#  resume_updated_at   :datetime
#  phone               :string(255)
#  year                :string(255)
#

FactoryGirl.define do
  factory :student_application do
    applicant
    semester
    why_join "I love Blueprint"
    phone "012-345-5678"
    year "Freshman"
    resume { File.new("#{Rails.root}/spec/support/fixtures/bops.pdf") }
  end
end
