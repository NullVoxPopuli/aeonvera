# frozen_string_literal: true

SkinnyControllers.search_proc = lambda do |relation|
  relation
    .ransack(params[:q])
    .result
  # .paginate(per_page: params[:per_page] || 50, page: params[:page])
end

module SkinnyControllers
  module Operation
    module ModelHelpers
      def parent_resource
        nil
      end

      def association_name_for_parent_resource
        nil
      end

      def use_parent?
        parent_resource && association_name_for_parent_resource
      end

      def find_model
        if use_parent?
          return parent_resource
                 .send(association_name_for_parent_resource)
                 .find(id_from_params)
        end

        if params[:scope]
          model_from_scope
        elsif (key = params.keys.grep(/\_id$/)).present?
          # hopefully there is only ever one of these passed
          id = params[key.first]
          if params['id'].present?
            # single item / show
            model_from_parent(key.first, id, params['id'])
          else
            # list of items / index
            model_from_named_id(key.first, id)
          end
        elsif id_from_params
          model_from_id
        else
          model_from_params
        end
      end
    end
  end
end
