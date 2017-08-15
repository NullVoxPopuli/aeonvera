# frozen_string_literal: true

module Api
  class ResourceController < ::APIController
    include SkinnyControllers::Diet

    respond_to :json, :csv

    def index
      respond_to do |format|
        format.json { render_jsonapi }
        format.csv do
          csv_data = CsvGeneration.model_to_csv(model, params[:fields])
          send_data(csv_data)
        end
      end
    end

    def show
      render_jsonapi
    end

    def create
      render_jsonapi(options: { status: 201 })
    end

    def update
      render_jsonapi
    end

    def destroy
      render_jsonapi
    end
  end
end
