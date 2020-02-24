# frozen_string_literal: true

class MyProgressBar
  def self.create(total:)
    ProgressBar.create(total: total, format: "%t: |%B| %a %E  %c/%C %P%%")
  end
end
