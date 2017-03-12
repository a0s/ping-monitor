# Running
```bash
git clone https://github.com/a0s/ping-monitor.git
cd ping-monitor/docker
docker-compose -f compose.yml -p pingmonitor build
docker-compose -f compose.yml -p pingmonitor up --force-recreate
```

# Usage
```bash
#
# DONT FORGET TO ADD 9292 PORT TO VIRTUALBOX/VMWARE's NAT RULES ON MAC !!!
#

curl -X POST "http://localhost:9292/5.255.255.88/add" --verbose
> 200 {}
curl -X POST "http://localhost:9292/5.255.255.88/remove" --verbose
> 200 {}
curl -X GET "http://localhost:9292/5.255.255.88/stat?from=0&to=1492016350" --verbose
> 200 {"fails":0,"stats":350,"total":350,"fails_percent":0.0,"avg":5.71336158,"min":0.056527,"max":171.346038,"sdv":9.02434002188064,"med":3.887773}
curl -X GET "http://localhost:9292/5.255.255.88/stat?from=0&to=dfgf" --verbose
> 400 {"error":"Invalid \"from\" or \"to\""}
curl -X GET "http://localhost:9292/5.255.255.88/stat/all_time" --verbose
> 200 {"fails":0,"stats":350,"total":350,"fails_percent":0.0,"avg":5.71336158,"min":0.056527,"max":171.346038,"sdv":9.02434002188064,"med":3.887773}
curl -X GET "http://localhost:9292/1.2.3.4/stat?from=0&to=1492016350" --verbose
> 404 {"error":"Ip not found"}
curl -X GET "http://localhost:9292/a.b.c.d/stat/all_time" --verbose
> 400 {"error":"Invalid ip"}

```

# Settings
    * LOG_LEVEL
    * APP_ENV
    * PING_INTERVAL
    * PING_TIMEOUT
