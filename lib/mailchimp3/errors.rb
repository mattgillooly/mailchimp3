module MailChimp3
  module Errors
    class AuthRequiredError < StandardError; end
    class DataCenterRequiredError < StandardError; end

    class BaseError < StandardError
      attr_reader :status, :details

      def initialize(response)
        @status = response.status
        @message = if response.body.is_a?(Hash) && response.body['error']
                     "#{response.body['name']}: #{response.body['error']}"
                   elsif response.body.is_a?(Hash)
                     "#{response.body['title']}: #{response.body['detail']}"
                   else
                     response.body.to_s
                   end
        @details = response.body if response.body.is_a?(Hash)
      end

      def to_s
        @message
      end

      def inspect
        "<#{self.class.name} status=#{@status} message=#{@message}>"
      end
    end

    class ClientError              < BaseError;   end # 400..499
    class BadRequest               < ClientError; end # 400
    class Unauthorized             < ClientError; end # 401
    class Forbidden                < ClientError; end # 403
    class NotFound                 < ClientError; end # 404
    class MethodNotAllowed         < ClientError; end # 405
    class UnprocessableEntity      < ClientError; end # 422

    class ServerError              < BaseError;   end # 500..599
    class InternalServerError      < ServerError; end # 500
  end
end
