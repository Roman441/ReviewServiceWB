Rails.application.routes.draw do
  #get 'feedbacks/index'
  #get 'feedbacks/getbad'

  namespace 'api' do
    namespace 'v1' do
      get 'feedbacks/get_by_period', :defaults => { :format => 'json' }
      get 'feedbacks/get_bad', :defaults => { :format => 'json' }
      get 'feedbacks/get_statistics', :defaults => { :format => 'json' }
    end
  end
end
