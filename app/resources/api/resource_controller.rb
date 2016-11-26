# frozen_string_literal: true
module Api
  class ResourceController < APIController
    include SkinnyControllers::Diet

    respond_to :json, :csv

    def index
      respond_to do |format|
        format.json { render_models }
        format.csv do
          csv_data = CsvGeneration.model_to_csv(model, params[:fields])
          send_data(csv_data)
        end
      end
    end

    def show
      render_model(params[:include])
    end

    def create
      render_model(params[:include], success_status: 201)
    end

    def update
      render_model
    end

    def destroy
      render_model
    end
  end
end
