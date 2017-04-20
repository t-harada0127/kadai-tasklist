class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end

  def require_authentication
    unless logged_in?
      redirect_to login_url
    end
    if current_user.tasks.first.nil?
      redirect_to root_url
    else
      unless Task.all.find(params[:id]).user_id == current_user.tasks.first.user_id
        redirect_to root_url
      end
    end
  end

  def counts(user)
    @count_tasks = user.tasks.count
  end
end
