# docker-nginx-healthcheck-webserver
This image features a NGINX web server with health-check support as defined
by HAProxy's [httpchk][1] option. This is used mostly for demonstration purpose
but can also be used as a proper web server by dropping the appropriate files
in /etc/nginx/conf.d (see [nginx image][2] in docker Hub for usage of the nginx
image).

## Starting a container
The simplest form to start a container out of this image will be:
```
docker run --name my-app -d -P elupu/nginx-healthcheck-webserver
```

Thee health check URI will be /health-check exposed on the port bound to 8888.
Given the command above the health check can be tested using the following command
```
curl http://localhost:<port bound to 8888>/health-check
```

## Supported modes
* Online - When the server is in online mode the HAProxy load balancer will
 include it in the back ends pool and forward requests to it (HTTP status code
   204).
* Offline - An Offline server will be taken out of the HAProxy's back ends pool
 and requests will not be forwarded to it (HTTP status code 503). **This is the
 default start mode**
* Drain - A server in that mode will be excluded from load balancing but will
 still receive persistent connections. This is important in a sticky session mode
 when we would like to allow any running sessions to end ('drain') before shutting
 down the server. This mode complies with HAProxy's [http-check][3] directive (HTTP
   status code 404)

## Switching between modes
Assuming we had started the container using the command above (so the container
  name is my-app) switching can be done using the following commands
  ```
  # offline
  docker exec -it my-app /bin/sh -c /usr/sbin/mark-offline.sh

  # online
  docker exec -it my-app /bin/sh -c /usr/sbin/mark-online.sh

  # drain
  docker exec -it my-app /bin/sh -c /usr/sbin/mark-drain.sh
  ```

## Sample HAProxy configuration
If an instance of that image is providing application features an front-end
HAProxy can use the /health-check URI using a configuration similar to  the
following (app-A and app-B illustrate A/B deployment)
```
 ....
 ....
backend my_app_service
  option httpchk OPTIONS /health-check
  server app-A.2.432szy6ipg946revou5df903d 10.0.0.9:80 check port 8888
  server app-A.2.25fyoebru2qbpl3u10djxbz1x 10.0.0.8:80 check port 8888
  server app-B.1.8u94isujw586jpy0v8ade1e84 10.0.0.7:80 check port 8888
  server app-B.2.cir250stuf2y69lwhtehn6ds0 10.0.0.6:80 check port 8888

```
[1]: https://cbonte.github.io/haproxy-dconv/1.8/configuration.html#4-option%20httpchk
[2]: https://hub.docker.com/_/nginx/
[3]: https://cbonte.github.io/haproxy-dconv/1.8/configuration.html#http-check
