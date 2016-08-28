# frozen_string_literal: true
class ShirtSerializer < ActiveModel::Serializer
  include PublicAttributes::LineItemAttributes
  include SharedAttributes::Stock

  type 'shirt'
  attributes :sizes,
    :xs_price, :s_price, :sm_price,
    :m_price,
    :l_price, :xl_price, :xxl_price, :xxxl_price

  has_many :order_line_items

  def sizes
    available = (object.metadata['sizes'] || []).reject(&:blank?)
    result = []

    available.each_with_index do |s, _i|
      result << {
        id: s,
        size: s,
        price:  object.price_for_size(s)
      }
    end

    result
  end

  def event_id
    object.host_id
  end

  def xs_price
    object.price_for_size('XS')
  end

  def s_price
    object.price_for_size('S')
  end

  def sm_price
    object.price_for_size('SM')
  end

  def m_price
    object.price_for_size('M')
  end

  def l_price
    object.price_for_size('L')
  end

  def xl_price
    object.price_for_size('XL')
  end

  def xxl_price
    object.price_for_size('XXL')
  end

  def xxxl_price
    object.price_for_size('XXXL')
  end
end
