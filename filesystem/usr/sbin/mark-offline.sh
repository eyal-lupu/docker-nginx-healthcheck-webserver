#!/bin/sh
ln -sf /etc/nginx/conf.d/health-check-return--offline /etc/nginx/conf.d/health-check-return-cmd
/usr/sbin/nginx -s reload
