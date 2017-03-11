require 'json'
require 'ipaddr'

class PingMonitor < Sinatra::Base
  configure do
    set :environment, App.env.to_sym
    set :logging, App.logger
  end

  helpers do
    # class A reserved space 10.0.0.0/8
    # class B reserved space 172.16.0.0/12
    # class C reserved space 192.168.0.0/16
    # class E reserved for research 240.0.0.0
    def valid_ipv4?(str)
      IPAddr.new(str).ipv4?
    rescue
      false
    end
  end

  before do
    content_type 'application/json'
  end

  post '/:ip/add' do
    halt(400) unless valid_ipv4?(params['ip'])
    Ip.find_or_create(ip: params['ip']).enable!
    halt(200)
  end

  post '/:ip/remove' do
    halt(400) unless valid_ipv4?(params['ip'])
    ip = Ip.find(ip: params['ip']) || halt(404)
    ip.disable!
    halt(200)
  end

  get '/:ip/stat' do
    halt(400) unless valid_ipv4?(params['ip'])
    ip = Ip.find(ip: params['ip']) || halt(404)
    cs = CalcStat.new(ip, params['from'], params['to']) rescue halt(400)
    result = cs.calc
    halt(404, JSON.dump(result)) if result[:total] == 0
    halt(200, JSON.dump(result))
  end

  get '/:ip/stat/all_time' do
    halt(400) unless valid_ipv4?(params['ip'])
    ip = Ip.find(ip: params['ip']) || halt(404)
    result = CalcStat.calc_all_time(ip)

    halt(404, JSON.dump(result)) if result[:total] == 0
    halt(200, JSON.dump(result))
  end
end
