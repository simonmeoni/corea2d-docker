#!/bin/bash
cd corea2d-indexer && USER_COREA2D=`jq -r .USER_COREA2D ../config.json` PWD_COREA2D=`jq -r .PWD_COREA2D ../config.json` SQL_COREA2D=`jq -r .SQL_COREA2D ../config.json` npm start
