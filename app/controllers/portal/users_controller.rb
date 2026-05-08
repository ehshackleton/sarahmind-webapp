module Portal
  class UsersController < BaseController
    def index
      @users = policy_scope(User)
      authorize User
    end

    def update
      @user = policy_scope(User).find(params[:id])
      authorize @user

      old_role = @user.role
      if @user.update(user_params)
        if old_role != @user.role
          log_audit!(
            "security.role_changed",
            auditable: @user,
            metadata: { from: old_role, to: @user.role }
          )
        end
        redirect_to portal_users_path, notice: "Rol actualizado."
      else
        @users = policy_scope(User)
        flash.now[:alert] = "No se pudo actualizar el rol."
        render :index, status: :unprocessable_content
      end
    end

    private

    def user_params
      params.require(:user).permit(:role)
    end
  end
end
