class StudentApplicationsController < ApplicationController
  before_action :authenticate_applicant!
  before_action :verify_unique_semester_application
  before_action :verify_student_app_open

  def new
    @student_application = current_applicant.student_applications.build name: current_user.name,
                                                                        email: current_user.email
  end

  def create
    @student_application = current_user.student_applications.build student_application_params
    if @student_application.save
      SendStudentApplicationEmail.execute @student_application
      redirect_to students_apply_path, flash: { success: t('student_applications.create.success') }
    else
      render "new"
    end
  end

  def student_application_params
    params.require(:student_application).permit(
      :why_join, :resume, :phone, :year, :applicant_id, :semester_id, :name, :email,
      :why_you, :experience, :projects, :service, :applied_before,
      :available_for_retreat, :available_for_bp_games, :why_no_bp_games, :why_no_retreat).merge(
        semester: @settings.current_semester
      )
  end

  def verify_unique_semester_application
    return true unless current_applicant.applied_for?(@settings.current_semester)
    redirect_to students_apply_path, flash: { success: t('student_applications.create.resubmit') }
  end

  def verify_student_app_open
    return if @settings.student_app_open
    redirect_to students_apply_path, flash: { error: t('student_applications.closed') }
  end
end
