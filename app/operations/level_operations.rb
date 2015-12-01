module LevelOperations
  class Create < SkinnyControllers::Operation::Base

    def run
      level = Level.new(model_params)

      if allowed_for?(level)
        level.save
      else
        level.errors.add(:base, 'not authorized')
      end

      level
    end
  end

  class Update < SkinnyControllers::Operation::Base

    def run
      if allowed?
        update
      else
        (model.presence || Level.new).errors.add(:base, 'not authorized')
      end
    end

    def update
      level = model
      level.update(model_params)
      level
    end

  end

end
