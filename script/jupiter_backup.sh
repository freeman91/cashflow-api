#!/bin/sh

pg_dump -v cashflow_development > ~/postgres/backups/cashflow_jupiter_$(date +%Y%m%d).bak