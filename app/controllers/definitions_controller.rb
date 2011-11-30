class DefinitionsController < ApplicationController



{ "has_related_words" : false,
  "images" : [  ],
  "list" : [ { "current_vote" : "",
        "defid" : 963116,
        "definition" : "A whiney admin in the #myspleen channel that complains about the bot performing google searches.",
        "example" : "Nitrodist is a whiney administrator.",
        "permalink" : "http://nitrodist.urbanup.com/963116",
        "thumbs_down" : 10,
        "thumbs_up" : 2,
        "word" : "nitrodist"
      } ],
  "pages" : 1,
  "result_type" : "exact",
  "total" : 1
}



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
