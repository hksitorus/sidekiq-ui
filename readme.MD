sidekiq-ui with sidekiq-cron

env:
```
USERNAME=username
PASSWORD=password
REDIS_URL=redis://myredishost:6379/0
MOUNT_AT=/sidekiq-ui
```

* leave `USERNAME` and `PASSWORD` empty and it wont have basic auth


example run using docker:
```
docker run -d --rm --name sidekiq-ui -e USERNAME=rick -e PASSWORD=morty -e REDIS_URL=redis://6.6.6.6:6379/0 -p 4000:4000 hksitorus/sidekiq-ui
```


