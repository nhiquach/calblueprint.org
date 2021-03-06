require "rails_helper"

def fill_in_semester(season, year)
  visit new_admin_semester_path
  select season, from: "Season:"
  fill_in "Year", with: year
end

RSpec.describe "Semester" do
  let(:student_application) { create :student_application }
  let!(:semester_empty) { create :semester, year: "empty", is_current_semester: true }
  let!(:semester_nonempty) do
    create :semester, year: "nonempty", student_applications: [student_application]
  end
  let(:settings) { create :settings }
  let!(:semester_empty) { create :semester, year: "empty" }
  let!(:semester_nonempty) { create :semester, year: "nonempty", student_applications: [student_application] }

  before do
    admin = create :admin, :super_admin
    sign_in admin
    expect(page).to have_content "Signed in successfully."
  end

  subject { page }

  describe "without filling in semester details" do
    before { visit new_admin_semester_path }
    it "renders back form with errors" do
      expect { click_button "Create Semester" }.not_to change { Semester.count }
      expect(page).to have_content "can't be blank"
    end
  end

  describe "after filling in semester details" do
    before { fill_in_semester "Spring", "new" }
    it "redirects to semesters page on submit" do
      expect { click_button "Create Semester" }.to change { Semester.count }.by(1)
      expect(page).to have_content "new"
    end
  end

  describe "after creating a duplicate semester" do
    before { fill_in_semester "Spring", "nonempty" }
    it "renders back form with errors" do
      expect { click_button "Create Semester" }.not_to change { Semester.count }
      expect(page).to have_content "has already been taken"
    end
  end

  describe "after delete" do
    context "non-empty semester" do
      before { visit admin_semesters_path }
      it "renders back page with nothing" do
        expect { click_link dom_id(semester_nonempty, :delete) }.not_to change { Semester.count }
        expect(page).to have_content t("admins.semesters.destroy.error")
      end
    end

    context "empty semester" do
      before { visit admin_semesters_path }
      it "renders back page without deleted semester" do
        expect { click_link dom_id(semester_empty, :delete) }.to change { Semester.count }.by(-1)
      end
    end
  end

  describe "after creating new current semester" do
    it "checks new current semester" do
      visit admin_semesters_path
      click_link dom_id(semester_empty, :set_as_current)
      visit admin_settings_path
      expect(page).to have_content "spring empty"
    end

    it "checks another current semester" do
      visit admin_semesters_path
      click_link dom_id(semester_nonempty, :set_as_current)
      visit admin_settings_path
      expect(page).to have_content "spring nonempty"
    end
  end
end
