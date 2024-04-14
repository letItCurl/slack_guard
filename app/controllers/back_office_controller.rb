class BackOfficeController < ApplicationController
  before_action :authenticate_user!
end
