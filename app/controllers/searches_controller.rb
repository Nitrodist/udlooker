class SearchesController < ApplicationController
  def get
    @searches = Search.order('created_at').last(5).reverse
  end
end
