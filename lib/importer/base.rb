module Importer
  class Base

    def self.import(*args)
      self.new.instance_eval do
        open_log
        begin
          ActiveRecord::Base.transaction do
            import *args
          end
        rescue Exception => e
          report_error e
        end
        close_log
      end
    end

    def open_log
      logger
    end

    def close_log
      logger.close
      @logger = nil
    end

    def logger
      @logger ||= Logger.new File.expand_path("#{self.class.name.underscore.parameterize}.log", 'log')
    end

    def log(message)
      logger.info message
    end

    def report_error(e)
      logger.error 'Произошла ошибка!'
      logger.error '='*10
      logger.error e.message
      e.backtrace.each do |b|
        logger.error b
      end
      logger.error '='*10
    end

    private

      def sql(*query)
        ActiveRecord::Base.connection.execute ActiveRecord::Base.send(:sanitize_sql_array, query)
      end

      def insert(table_name, data, opts={})
        query = "INSERT INTO #{table_name} (#{data.keys.map{|key| key.to_s }.join ', '}) VALUES (?)"
        query << " RETURNING #{opts[:returning]}" if !!opts[:returning]
        sql query, data.values
      end

      def update(table_name, where, data, opts={})
        query = "UPDATE #{table_name} SET #{data.keys.map{|key| "#{key.to_s} = ?" }.join ', '}"
        query << " WHERE #{ where.keys.map{ |key| "#{key.to_s} = ?" }.join ' AND ' }" unless where.empty?
        query << " RETURNING #{opts[:returning]}" if !!opts[:returning]
        interpolation = data.values + where.values
        sql query, *interpolation
      end

      def touch(table_name, *params)
        where = params.extract_options!
        fields_to_update = Hash[params.map{ |param| [param, @created_at]}]
        update table_name, where, fields_to_update
      end
  end
end
