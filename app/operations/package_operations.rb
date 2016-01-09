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
end
