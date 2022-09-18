class Wildberries::FeedbacksImporter < Importer::Base
  include HTTParty
  require 'importer'

  MAIN_URL = "https://public-feedbacks.wildberries.ru/api/v1/feedbacks"
  STEP = 10

  def import
    @cards = Wildberries::CardProduct.all
    @cards.each do |card|
      log "Собираем отзывы для карточки #{card.value}"
      loop_by_request(card)
    end
  end


  private

  def loop_by_request(card)
    skip = 0

    loop do
      options  = get_options(card.value, skip)
      response = request(options)
      result   = JSON.parse(response.body)

      unless result['ErrorCode'] == nil ||
             result['ErrorCode'] == 200 ||
             result['feedbacks'] != nil
        log "Ошибка получения данных"
        break
      end

      if result['feedbacks'].empty?
        break
      end

      result['feedbacks'].each do |data|
        unless data['text'].nil?
          if _is_new_feed?(data['id'])
            _insert(card.id, data)
          else
            return
          end
        else
          return
        end
      end

      skip = skip + STEP
    end
  end

  def _is_new_feed?(id_feed)
    feed = Wildberries::Feedback.check_id_feedback(id_feed)

    if feed.blank?
      return true
    else
      return false
    end
  end

  def _insert(card_id, data)
    insert(:feedbacks,
          card_id: card_id,
          id_feedback: data['id'],
          crt_date: data['createdDate'],
          user_id: data['wbUserId'],
          user_name: data['wbUserDetails']['name'],
          user_country: data['wbUserDetails']['country'],
          text: data['text'],
          product_valuation: data['productValuation']
    )
  end

  def get_options(card_id, skip)
    return {"skip" => skip, "imtId" => card_id, "order" => "dateDesc", "take" => STEP}
  end

  def request(options)
    response = HTTParty.post("https://public-feedbacks.wildberries.ru/api/v1/feedbacks",
                             :body => options.to_json,
                             :headers => {'Content-Type' => 'application/json',
                             :ssl_version => "TLSv1_2" }
    )

    return response
  end
end