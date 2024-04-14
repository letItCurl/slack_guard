class BackOffice::UsersController < ApplicationController
  def update
    current_user.update(slack_token: params[:slack_token])
    redirect_to campaigns_path, notice: "Token updated."
  end
end
