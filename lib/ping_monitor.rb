require 'json'
require 'ipaddr'

class PingMonitor < Sinatra::Base
  set :protection, false
  set :environment, App.env.to_sym
  set :logging, true
  set :dump_errors, true
  set :raise_errors, false
  set :show_exceptions, false
  use Rack::CommonLogger, App.logger

  helpers do
    # TODO add checking for 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 and 240.0.0.0
    def valid_ipv4?(str)
      IPAddr.new(str).ipv4?
    rescue
      false
    end
  end

  before do
    env['rack.logger'] = App.logger
    content_type 'application/json'
  end

  post '/:ip/add' do
    halt(400, JSON.dump(error: 'Invalid ip')) unless valid_ipv4?(params['ip'])
    Ip.find_or_create(ip: params['ip']).enable!
    halt(200, JSON.dump({}))
  end

  post '/:ip/remove' do
    halt(400, JSON.dump(error: 'Invalid ip')) unless valid_ipv4?(params['ip'])
    ip = Ip.find(ip: params['ip'])
    halt(404, JSON.dump(error: 'Ip not found')) unless ip
    ip.disable!
    halt(200, JSON.dump({}))
  end

  get '/:ip/stat' do
    halt(400, JSON.dump(error: 'Invalid ip')) unless valid_ipv4?(params['ip'])
    ip = Ip.find(ip: params['ip'])
    halt(404, JSON.dump(error: 'Ip not found')) unless ip
    begin
      cs = CalcStat.new(ip, params['from'], params['to'])
    rescue
      halt(400, JSON.dump(error: 'Invalid "from" or "to"'))
    end
    result = cs.calc
    halt(404, JSON.dump(result)) if result[:total] == 0
    halt(200, JSON.dump(result))
  end

  get '/:ip/stat/all_time' do
    halt(400, JSON.dump(error: 'Invalid ip')) unless valid_ipv4?(params['ip'])
    ip = Ip.find(ip: params['ip'])
    halt(404, JSON.dump(error: 'Ip not found')) unless ip
    result = CalcStat.calc_all_time(ip)
    halt(404, JSON.dump(result)) if result[:total] == 0
    halt(200, JSON.dump(result))
  end
end
