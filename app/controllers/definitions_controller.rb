class DefinitionsController < ApplicationController

  def get
    render :text => ' ' unless params.has_key?(:q)

    url = "http://www.urbandictionary.com/iphone/search/define?term=" + params[:q].gsub(' ', '%20')

    # log our search
    Search.create(:query => params[:q])

    ud_response = Typhoeus::Request.get(url)

    if ud_response.success?

      definition = JSON.parse(ud_response.body)['list'].sample
      result_hash = { 'title' => definition['word'],
                      'definition' => definition['definition'] }

      if result_hash['title'] == nil
        render :json => ({ 'notfound' => true }).to_json
      else
        render :json => hash.to_json
      end

    else
      render :text => ' '
    end

  end

end
