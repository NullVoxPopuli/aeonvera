# frozen_string_literal: true
module Api
  class LevelsController < Api::EventResourceController
    self.serializer = LevelSerializableResource

    private

    def update_level_params
      params
        .require(:data)
        .require(:attributes)
        .permit(:name, :requirement, :description)
    end

    def create_level_params
      create_params_with(update_level_params, host: false)
    end
  end
end
