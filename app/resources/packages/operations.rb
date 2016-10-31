module PackageOperations
  class ReadAll < SkinnyControllers::Operation::Base
    def run
      # if we scope to the parent object,
      # we don't need to check if we can access all
      # of the child items
      if params['event_id'].present?
        model
      else
        model.select do |package|
          package.event.is_accessible_to? current_user
        end
      end
    end
  end

  class Create < SkinnyControllers::Operation::Base

    def run
      package = Package.new(model_params)

      if allowed_for?(package)
        package.save
      else
        package.errors.add(:base, 'not authorized')
      end

      package
    end
  end

  class Update < SkinnyControllers::Operation::Base

    def run
      if allowed?
        update
      else
        (model.presence || Package.new).errors.add(:base, 'not authorized')
      end

      model
    end

    def update
      package = model
      package.update(model_params)
      package
    end

  end

end
