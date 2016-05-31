module CollaborationOperations
  class Create < SkinnyController::Operation::Base
    include CollaborationOperations::Helpers

    def run
      create_cache_entry
      send_email

      collaboration
    end

    def create_cache_entry
      # store the token in the cache so that it can be looked up later
      # by the person receiving the email
      Cache.set(cache_key, true)
      Cache.set("#{cache_key}-email", params[:email])
    end

    def send_email
      CollaboratorsMailer.invitation(
        from: current_user, email_to: params[:email],
        host: host, link: link_path
      ).deliver_now!
    end

    def link_path
      # for non rails use (cause I was curious)
      # to_query could be written as:
      # hash.to_a.map{ |i| i.join('=') }.join('&')
      ENV.host + '/collaborations?' + link_params.to_query
    end

    def link_params
      { host_type: host.class.name, host_id: host.id, token: token_from_email }
    end

    def token_from_email
      @token_from_email ||= Digest::SHA1.hexdigest(params[:email] + Time.now.to_s)
    end

    def cache_key
      @cache_key ||= "#{host.class.name}-#{host.id}-#{token_from_email}"
    end
  end
end
