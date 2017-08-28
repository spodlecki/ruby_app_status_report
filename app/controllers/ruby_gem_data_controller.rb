class RubyGemDataController < ApplicationController
  def index
    models = RubyGemDatum.all
    render json: models.as_json
  end
end
