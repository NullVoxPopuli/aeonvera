# frozen_string_literal: true

class NilClass
  def to_b
    false
  end
end

class String
  def to_b
    # http://jeffgardner.org/2011/08/04/rails-string-to-boolean-method/
    return true if self == true || self =~ /(true|t|yes|on|y|1)$/i
    return false if self == false || nil? || self =~ /(false|f|no|off|n|0)$/i
    raise ArgumentError, "invalid value for Boolean: \"#{self}\""
  end
end
