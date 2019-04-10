# frozen_string_literal: true

class Timeline
  class Base
    PER_PAGE = 10
    private_constant :PER_PAGE

    def initialize(date_string:, largest_tweet_id:, timeline_owner:)
      @date_string = date_string
      @largest_tweet_id = largest_tweet_id
      @timeline_owner = timeline_owner
    end

    def titile
      raise "code me"
    end

    def source_statuses
      raise "code me"
    end

    def has_next?
      # TODO : rename to has_older_status?
      # NOTE : may be deleted if how we paginate is changed
      return false if source_statuses.blank?
      older_status.exists?
    end

    def oldest_tweet_id
      oldest_status.try!(:status_id_str)
    end

    def target_date
      @target_date ||= TargetDate.new(@date_string)
    end

    private

      def oldest_status
        source_statuses.try!(:last)
      end

      def older_status
        raise "code me"
      end

      class TargetDate
        # TODO : delegate these logics to routes
        attr_reader :date_string
        def initialize(date_string_from_params)
          @date_string = date_string_from_params
        end

        def specified?
          date_string.present?
        end

        def formatted_date
          # FIXME : get rid of this
          completed_date_string.to_date.strftime(format_pattern)
        end

        private

          def year_only?
            !month_specified? && !day_specified?
          end

          def month_specified?
            date_string.split(/-/).size == 2
          end

          def day_specified?
            date_string.split(/-/).size == 3
          end

          def completed_date_string
            case
            when day_specified?
              date_string
            when month_specified?
              "#{date_string}-1"
            when year_only?
              "#{date_string}-1-1"
            end
          end

          def format_pattern
            case
            when day_specified?
              "%Y年%m月%-d日"
            when month_specified?
              "%Y年%m月"
            when year_only?
              "%Y年"
            end
          end
      end
  end
end
