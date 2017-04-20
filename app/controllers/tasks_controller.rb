class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create ]
  before_action :require_authentication, only: [:show, :edit, :update, :destroy ]

  def index
    @alltasks = Task.all
    @allusers = User.all
    if logged_in?
      @user = current_user
      @task = current_user.tasks.build  # form_for 用
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
    end
  end

  def show
    set_task
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new
    end

  end

  def edit
    set_task
  end

  def update
    set_task

    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end

  end

  def destroy
    set_task
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url

  end
 


 private

  def set_task
    @task = Task.find(params[:id])
  end


  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status, :user_id)
  end



end
