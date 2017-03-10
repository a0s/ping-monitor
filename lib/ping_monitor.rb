require 'json'
require 'ipaddr'

class PingMonitor < Sinatra::Base
  set :environment, App.env.to_sym
  set :logging, App.logger

  post '/:ip/add' do
    begin
      halt(400) unless IPAddr.new(params['ip']).ipv4?
    rescue IPAddr::InvalidAddressError
      halt(400)
    end
    Ip.find_or_create(ip: params['ip']).enable!
    halt(200)
  end

  post '/:ip/remove' do
    begin
      halt(400) unless IPAddr.new(params['ip']).ipv4?
    rescue IPAddr::InvalidAddressError
      halt(400)
    end
    ip = Ip.find(ip: params['ip'])
    halt(404) unless ip
    ip.disable!
    halt(200)
  end
end
