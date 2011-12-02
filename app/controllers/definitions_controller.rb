class DefinitionsController < ApplicationController

  def get
    render :text => ' ' if !params[:q].present?

    url = "http://www.urbandictionary.com/iphone/search/define?term=" + params[:q]

    # log our search
    s = Search.new 
    s.query = params[:q]
    s.save

    response = Typhoeus::Request.get(url)

    if response.success?
      json = JSON.parse(response.body)
      hash = Hash.new
      p json
      definition = json['list'].sample
      hash['title'] = definition['word']
      hash['definition'] = definition['definition']
      if hash['title'] == nil
        render :json  => ({ 'notfound' => true }).to_json
      else
        render :json => hash.to_json
      end
    else
      # Received a non-successful http response.
      render :text => ' '
    end

  end
end
