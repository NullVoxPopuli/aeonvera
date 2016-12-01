# frozen_string_literal: true
SkinnyControllers.search_proc = lambda do |relation|
  relation.ransack(params[:q]).result
end
