# frozen_string_literal: true

module Errors
  class Base         < StandardError; end
  class BadRequest   < Base; end
  class Unauthorized < Base; end
  class NotFound     < Base; end
end
