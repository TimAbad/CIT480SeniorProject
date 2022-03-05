#!/bin/bash
cd /var/www/dashboard
nohup streamlit run app.py --server.enableCORS=false
