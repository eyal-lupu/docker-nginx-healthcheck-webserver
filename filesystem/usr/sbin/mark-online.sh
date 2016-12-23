#!/bin/sh
ln -sf /etc/nginx/conf.d/health-check-return--online /etc/nginx/conf.d/health-check-return-cmd
/usr/sbin/nginx -s reload
