#!/bin/bash

if [ ! -f .env ]; then
    cp .env.example .env
    echo "created .env from .env.example."
else
    echo ".env already exists."
fi