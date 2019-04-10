# frozen_string_literal: true

class TimelineType
  VALID_TYPE_SYMS = [:public_timeline, :user_timeline, :home_timeline]
  private_constant :VALID_TYPE_SYMS

  def initialize(type)
    @type_sym = type.to_sym
    validate_type_sym!
  end

  def public_timeline?
    @type_sym == :public_timeline
  end

  def user_timeline?
    @type_sym == :user_timeline
  end

  def home_timeline?
    @type_sym == :home_timeline
  end

  private

    def validate_type_sym!
      return if VALID_TYPE_SYMS.include?(@type_sym)
      raise "Unexpected type symbol(#{@type_sym}) given."
    end
end
