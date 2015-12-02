class ActiveModel::Errors
  def to_json_api
    json = {}
    new_hash = to_hash(true).map do |k, v|
      v.map do |msg|
        {
          detail: msg,
          source: {
            pointer: 'data/attributes/' + k.to_s
          }
         }
      end
    end.flatten
    json[:errors] = new_hash
    json
  end
end
