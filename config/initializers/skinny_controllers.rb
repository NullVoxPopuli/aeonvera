# frozen_string_literal: true
SkinnyControllers.search_proc = lambda do |relation|
  relation
    .ransack(params[:q])
    .result
    # .paginate(per_page: params[:per_page] || 50, page: params[:page])
end
