# object is actually an Organization in this serializer
class CommunitySerializer < ActiveModel::Serializer
  type 'community'

  attributes :id, :name, :tagline,
    :city, :state, :beta, :owner_id,
    :domain, :url,
    :logo_file_name, :logo_content_type,
    :logo_file_size, :logo_updated_at,
    :logo_url_thumb, :logo_url_medium, :logo_url


    def url
      object.link
    end

    def logo_url_thumb
      object.logo.url(:thumb)
    end

    def logo_url_medium
      object.logo.url(:medium)
    end

    def logo_url
      object.logo.url(:original)
    end


end
