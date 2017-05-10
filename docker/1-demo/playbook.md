# Demo 1
Getting to know the basic docker commands
[Docker documentation](https://docs.docker.com/)


## Basic Docker Commands
List running containers
```sh
docker ps
```

List all containers
```sh
docker ps -a
```

List all images
```sh
docker images
```

To run an image
```sh
docker run -d -p 27017:27017 --name sugcon-demo-1 istern/windows-mongo
```

Get information about a running image 
IP etc 
```sh
docker inspect sugcon-demo-1
```
Try to get the ip and connect via robomongo

To Go inside an container
```sh
docker exec -it sugcon-demo-1 powershell
```

Remove a Container
```sh
docker rm sugcon-demo-1
```

## Gotchas running windows contaiers

- Natting Ip vs local ip on linux
