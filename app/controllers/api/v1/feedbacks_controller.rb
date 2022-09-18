class Api::V1::FeedbacksController < ApplicationController
  def get_by_period
    @feedbacks = Wildberries::Feedback::get_by_period(contr_params).order('crt_date')
    respond(@feedbacks, FeedbackSerializer)
  end

  def get_bad
    @feedbacks = Wildberries::Feedback::get_bad(contr_params).order('crt_date')
    respond(@feedbacks, FeedbackSerializer)
  end

  def get_statistics
    stat_by_period = Wildberries::Feedback::get_stat(contr_params)
    average_mark = Wildberries::Feedback::get_average_mark(contr_params)

    @feedbacks = {:average_mark_by_period => average_mark,
                  :statistics => stat_by_period }

    respond(@feedbacks, StatFeedbackSerializer )
  end

  def respond(records, serializer)
    if records.blank?
      message = "Feedbacks not found for the period"
      render json: { error: message}, status: :not_found
    else
      render json: records, :each_serializer => serializer, status: :ok
    end
  end

  private

  def contr_params
    params.require(:card_id)
    params.require(:date_start)
    params.require(:date_end)
    params.permit(:card_id, :date_start, :date_end)
    return params
  end
end





