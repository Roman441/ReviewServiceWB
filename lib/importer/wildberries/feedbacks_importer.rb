class Importer::Wildberries::FeedbacksImporter < Importer::Base
    MAIN_URL = "https://public-feedbacks.wildberries.ru/api/v1/feedbacks"

    def import
      @cards = Wildberries::CardProduct.all

      @cards.each do |card|
        log "Собираем отзывы для карточки #{card.card_id}"

        options = {
          "skip": 0,
          "imtId": card.card_id,
          "order": "dateDesc",
          "take": 10
        }

        request = Net::HTTP::Post.new(MAIN_URL, options)
        response = http.request(request)

        response.each do |data|
          unless data['text'].zero?
            insert(:feedback,
                   card_id: card.id,
                   userId: data['wbUserId'],
                   name: data['wbUserDetails']['name'],
                   userCountry: data['wbUserDetails']['country'],
                   text: data['text'],
                   product_valuation: data['productValuation'])
          end
        end
      end
    end
  end