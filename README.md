Setting Up
----------

TODO: Remove this requirement
Add **10.100.195.200  liferay** to your hosts file

```bash
vagrant up swarm-master swarm-node-1 swarm-node-2

vagrant ssh swarm-master

ansible-playbook /vagrant/ansible/swarm.yml \
    -i /vagrant/ansible/hosts/prod \
    -vv

export DOCKER_HOST=tcp://10.100.195.200:2375

docker info

docker ps -a

curl 10.100.195.200:8500/v1/catalog/services \
    | jq '.'
```

Running the Application
-----------------------

# TODO: Figure out how to avoid running the watcher after the first run

```bash
ansible-playbook /vagrant/ansible/liferay.yml \
    -i /vagrant/ansible/hosts/prod \
    -vv

docker ps | grep liferay

curl 10.100.195.200:8500/v1/catalog/services \
    | jq '.'

curl 10.100.195.200:8500/v1/catalog/service/liferay \
    | jq '.'
```

Open [http://10.100.195.200:8500/](http://10.100.195.200:8500/).
Open [http://liferay/](http://liferay/).

Recuperating From the Application Failure
-----------------------------------------

```bash
cd /data/liferay

sudo DOCKER_HOST=tcp://10.100.195.200:2375 \
    docker-compose stop app

tail -f /data/consul/logs/watches.log # Stop with CTRL+c

docker ps | grep life

curl 10.100.195.200:8500/v1/catalog/service/liferay \
    | jq '.'
```

Open [http://10.100.195.200:8500/](http://10.100.195.200:8500/).
Open [http://liferay/](http://liferay/).

Recuperating From the Server Failure
------------------------------------

```bash
exit

# Run this command only if the application
# was deployed to the swarm-node-1.
vagrant halt swarm-node-1

# Run this command only if the application
# was deployed to the swarm-node-2.
vagrant halt swarm-node-2

vagrant ssh swarm-master

tail -f /data/consul/logs/watches.log # Stop with CTRL+c

export DOCKER_HOST=tcp://10.100.195.200:2375

docker ps | grep life

curl 10.100.195.200:8500/v1/catalog/service/liferay \
    | jq '.'

cat /data/nginx/upstreams/liferay.conf
```

Open [http://10.100.195.200:8500/](http://10.100.195.200:8500/).
Open [http://liferay/](http://liferay/).

Cleaning Up
-----------

```bash
sudo rm -f /data/consul/config/liferay.json

sudo killall -HUP consul

cd /data/liferay

sudo DOCKER_HOST=tcp://10.100.195.200:2375 \
    docker-compose stop app

sudo DOCKER_HOST=tcp://10.100.195.200:2375 \
    docker-compose rm -f app

exit

vagrant halt
```
