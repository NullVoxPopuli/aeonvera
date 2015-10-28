class ShirtSerializer < ActiveModel::Serializer
  type 'shirt'
  attributes :id, :name,
    :current_price, :price,
    :sizes,
    :expires_at,
    :host_id, :host_type, :event_id,
    :xs_price, :s_price, :sm_price, :m_price, :l_price, :xl_price, :xxl_price, :xxxl_price,
    :number_purchased

    def sizes
      available = object.metadata["sizes"].reject {|s| s.blank? }
      result = []

      available.each_with_index do |s, i|
        result << {
          id: s,
          size: s,
          price:  object.price_for_size(s)
        }
      end

      result
    end

    def number_purchased
      object.order_line_items.count
    end

    def event_id
      object.host_id
    end

    def xs_price
      object.price_for_size("XS")
    end

    def s_price
      object.price_for_size("S")
    end

    def sm_price
      object.price_for_size("SM")
    end

    def m_price
      object.price_for_size("M")
    end

    def l_price
      object.price_for_size("L")
    end

    def xl_price
      object.price_for_size("XL")
    end

    def xxl_price
      object.price_for_size("XXL")
    end

    def xxxl_price
      object.price_for_size("XXXL")
    end

end
