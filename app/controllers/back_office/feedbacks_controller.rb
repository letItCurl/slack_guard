class BackOffice::FeedbacksController < BackOfficeController
  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # POST /feedbacks or /feedbacks.json
  def create
    @feedback = current_user.feedbacks.new(feedback_params)

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to campaigns_path, notice: "Feedback was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
  private
    # Only allow a list of trusted parameters through.
    def feedback_params
      params.require(:feedback).permit(:content)
    end
end
