# INFO

This repo contains the terraform files to deploy an application environment.
The environment is deployed on AWS in one VPC, 2 Public  and 2 private subnets

## Public Subnet
VPN-server: to provide access to private subnet over private IP
Proxy server: to route incoming traffic for specific devices (Jenkins webhook from github push)
Elastic load Balancer: For public access of web server and load balancing.
Nat-Gateway: To provide internet traffic to private subnet

## Private Subnets

Auto-Scaling group with load balancer and 2 backend web-servers
All server in private-subnet have only private IPs, no public IP

## Tomcat

This is the app server hosted behind an elastic load balancer

## Jenkins

this is a java build server with plugins to deploy builds to the app server

## Sonarqube

Code Quality benchmark

## Nexus

This is an artifactory to backup our artifacts

## Nginx

Nginx is configured to be a proxy server to allow incoming connection from github to the build server only.

## VPN Server

Ubuntu server configured for vpn management.


## Build repo

https://github.com/jideola/mwa-private