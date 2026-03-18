#!/usr/bin/env bash

ssh root@192.168.99.1 "date -s '@$(date +%s)'"
