module EventOperations
  class Read < SkinnyControllers::Operation::Base
    def run
      model if allowed?
    end
  end

  class Create < SkinnyControllers::Operation::Base
    def run
      return unless allowed?
      @model = model_class.new(model_params)
      @model.hosted_by = current_user
      @model.save
      @model
    end
  end


end
