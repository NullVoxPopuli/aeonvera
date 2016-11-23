module Api
  # object is actually an Organization
  class OrganizationSummarySerializer < ActiveModel::Serializer
    type 'organization_summary'

    attributes :id, :name, :domain, :organization_id,
      :revenue_past_month, :net_received_past_month,
      :unpaid_past_month, :new_memberships_past_month,
      :logo_url_thumb

    has_many :orders

    def attendances
      object.orders.limit(5)
    end

    def logo_url_thumb
      object.logo.url(:thumb)
    end

    def organization_id
      object.id
    end

    def revenue_past_month
      paid_orders_last_month.map(&:paid_amount).inject(:+)
    end

    def net_received_past_month
      paid_orders_last_month.map(&:net_amount_received).inject(:+)
    end

    def unpaid_past_month
      unpaid_orders = orders_past_month.where(paid: false)
      unpaid_orders.map{ |o| o.total || 0 }.inject(:+)
    end

    def new_memberships_past_month
      membership_options = object.membership_options.includes(:order_line_items)
      purchases = membership_options.map(&:order_line_items).flatten
      purchases.count
    end

    private

    def paid_orders_last_month
      @paid_orders_last_month ||= orders_past_month.where(paid: true)
    end

    def orders_past_month
      return @orders_past_month if @orders_past_month
      received_at_date = order_column(:payment_received_at)
      @orders_past_month = orders.where(received_at_date.gteq(1.month.ago))
    end

    def orders
      @orders ||= object.orders
    end

    def orders_table
      Order.arel_table
    end

    def order_column(name)
      orders_table[name]
    end
  end
end
