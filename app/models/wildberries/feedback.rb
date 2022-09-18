class Wildberries::Feedback < ActiveRecord::Base
  self.table_name = :feedbacks
  self.primary_key = :id

  def active_model_serializer
    FeedbackSerializer
  end

  belongs_to :card

  scope :last_feedback, -> { order('card_id').last }
  scope :check_id_feedback, ->(id) { where('id_feedback = ?', id).first }

  def self.get_by_period(params)
   joins(:card)
     .where('cards.value = ? AND crt_date BETWEEN ? AND ?',
          params['card_id'],
          params['date_start'],
          params['date_end']
    )
  end

  def self.get_bad(params)
    joins(:card)
      .where('cards.value = ? AND product_valuation < 3 AND crt_date BETWEEN ? AND ?',
             params['card_id'],
             params['date_start'],
             params['date_end']
      )
  end

  def self.get_stat(params)
    sql = "select c.card, a.crt_date, b.product_valuation, count_val from (select distinct id, value as card from cards where value = #{params[:card_id]} group by value, id ) c inner join (select distinct crt_date::date, card_id from feedbacks group by crt_date, card_id) a on(c.id = a.card_id) inner join (select distinct count(product_valuation) as count_val, product_valuation, crt_date::date, card_id from feedbacks group by product_valuation, card_id, crt_date) b on (a.crt_date = b.crt_date and a.card_id = b.card_id) order by a.crt_date"
    return ActiveRecord::Base.connection.execute(sql)
  end

  def self.get_average_mark(params)
    joins(:card)
      .where('cards.value = ? AND crt_date >= ? AND crt_date <= ?',
             params['card_id'],
             params['date_start'],
             params['date_end']
      )
      .average(:product_valuation)
  end

  def self.get_by_days_stat(params)
    sql = "select a.crt_date from (select distinct id, value as card from cards group by value, id ) c inner join (select distinct crt_date::date, card_id from feedbacks group by crt_date, card_id) a on (c.id = a.card_id) where crt_date BETWEEN '#{params[:date_start]}' AND '#{params[:date_end]}' order by a.crt_date"
    return ActiveRecord::Base.connection.execute(sql)
  end
end
