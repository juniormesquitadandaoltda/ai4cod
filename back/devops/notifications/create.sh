#!/bin/sh

set -e

TOKEN=X8WaUC6yi29wGaDHHBsSywVQdQ7rRNeDqTwUVwQ15CaRuE5QScByvfPmx3CjPYzMqeVVanfGRAjHGbJbhbSHA1fkoMnXsPtyHEVmwAWcE71wrWucXgpeZUs4UxuQVtQmyXYNtWG4D7NLkNvq5e5dL3vqQ5nN9BDSHE69ST7gfJfuFcdkqNZavNvTv1QN8ZGqKGWM5JryenpFbq33ZEi6CFUBVneUw1zrK8jVEBbLhjyjGSzwgara4CrKpRCicUgm

curl \
  --include \
  --request POST \
  --location "http://localhost:3004/data/public/notificators/${TOKEN}/notifications" \
  --data '{"key":"value"}'
