class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show


  def index
    @users = User.paginate(page: params[:page])
    
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end


  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
     respond_to do |format|
       format.html
       format.json { render json: @user }
    end
  end
  
  private
  def set_user
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
     
    respond_to do |format|
     format.html
     format.json { render json: @user }
    end
  end


   def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        log_in @user
        flash[:success] = '新規作成に成功しました。'
        format.html { redirect_to @user }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
  end


  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = "ユーザー情報を更新しました。"
        format.html { redirect_to @user }
        format.json { render json: @user, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
  
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end


  def edit_basic_info
    @user = User.find(params[:id])
  
    respond_to do |format|
      format.html { render partial: 'users/edit_basic_info', locals: { user: @user } } # 修正
      format.turbo_stream
    end
  end




  def update_basic_info
    if @user.update(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
  
    respond_to do |format|
      format.html { redirect_to users_url }
      format.turbo_stream
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
  end
end