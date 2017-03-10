require 'json'
require 'ipaddr'

class PingMonitor < Sinatra::Base
  set :environment, App.env.to_sym
  set :logging, App.logger

  post '/:ip/add' do
    (halt(400) unless IPAddr.new(params['ip']).ipv4?) rescue halt(400)
    Ip.find_or_create(ip: params['ip']).enable!
    halt(200)
  end

  post '/:ip/remove' do
    (halt(400) unless IPAddr.new(params['ip']).ipv4?) rescue halt(400)
    ip = Ip.find(ip: params['ip'])
    halt(404) unless ip
    ip.disable!
    halt(200)
  end

  get '/:ip/stat' do
    (halt(400) unless IPAddr.new(params['ip']).ipv4?) rescue halt(400)
    cs = CalcStat.new(params['from'], params['to'], params['ip']) rescue halt(400)
    pp cs
  end
end
