#!/bin/bash

if [ ! -f .env ]; then
    cp .env.example .env
    echo "created .env from .env.example."
else
    echo ".env already exists."
fi

if [ ! -f work/request.sql ]; then
    cp domain/request.sql work/request.sql
    echo "created work/request.sql. tune up it!"
else
    echo "work/request.sql already exists."
fi
