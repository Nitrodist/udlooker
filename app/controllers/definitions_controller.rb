class DefinitionsController < ApplicationController
  def get
    definitions = UrbanLexicophile.define(params[:q])
    # log our search
    s = Search.new 
    s.query = params[:q]
    s.save
    render :json => definitions.sample
  end
end
