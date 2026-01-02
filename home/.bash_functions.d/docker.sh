# Docker utility functions

docker-rmi-none() {
  docker images | grep non | awk '{print $3}' | xargs -n 1 docker rmi
}
