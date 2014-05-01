require 'digest/md5'
require 'faraday'

module Smsc
  class Sms

    def initialize(login, password, charset = 'utf-8')
      @login = login
      @password = Digest::MD5.hexdigest(password.to_s)
      @charset = charset
      @connection = Faraday.new(url: 'https://smsc.ru') do |i|
        i.request  :url_encoded
        i.response :logger
        i.adapter  Faraday.default_adapter
      end
    end

    def message(message, phones, options = {})
      params = {
        login: @login,
        psw: @password,
        phones: phones.join(','),
        mes: message,
        charset: @charset,
        sender: options[:sender],
        id: options[:id]
      }

      @connection.post '/sys/send.php', params
    end

    def status(phone, message_id)
      params = {
        login: @login,
        psw: @password,
        phone: phone,
        id: message_id
      }

      @connection.get '/sys/status.php', params
    end

    def balance
      params = {
        login: @login,
        psw: @password
      }

      @connection.get '/sys/balance.php', params
    end

    def statistic(start_date, end_date)
      params = {
        get_stat: 1,
        login: @login,
        psw: @password,
        start: start_date,
        end: end_date
      }

      @connection.get '/sys/get.php', params
    end
  end
end
