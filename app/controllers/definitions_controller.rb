class DefinitionsController < ApplicationController

  def get
    render :text => ' ' if !params[:q].present?

    url = "http://www.urbandictionary.com/iphone/search/define?term=" + params[:q]

    # log our search
    s = Search.new 
    s.query = params[:q]
    s.save

    Typhoeus::Request.new(url)
    hydra = Typhoeus::Hydra.new
    hydra.queue(request)
    hydra.run

    if response.success?
      json = JSON.parse(response.body)
      hash = Hash.new
      definition = json.list.sample
      hash[:title] = definition.word
      hash[:definition] = definition.definition
    elsif response.timed_out?
      # aw hell no
      render :text => ' '
    elsif response.code == 0
      # Could not get an http response, something's wrong.
      render :text => ' '
    else
      # Received a non-successful http response.
      render :text => ' '
    end
  end
end
