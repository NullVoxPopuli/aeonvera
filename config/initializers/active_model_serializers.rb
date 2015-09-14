# ActiveModel::Serializer.config.adapter = ActiveModel::Serializer::Adapter::JsonApi

# if using > v0.10
ActiveModel::Serializer.config.adapter = :json
# ActiveModel::Serializer.config.adapter = :json_api
# in NullVoxPopuli's branch of AMS
ActiveModel::Serializer.config.sideload_associations = true

# if using v0.9
# ActiveModel::Serializer.setup do |config|
#   config.embed = :ids
#   config.embed_in_root = true
# end
