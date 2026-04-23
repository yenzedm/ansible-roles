add_monitoring_docker_containers
=========

Adds monitoring for Docker containers on deb-based systems. If there is an image but the container is not running, the trigger will fire.

Role Variables
--------------

There is no need to redefine variables. They are located in 
roles/add_monitoring_docker_containers/defaults/main.yml

Dependencies
------------

No dependencies

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: 'add_monitoring_docker_containers' }

# Role Information
------------------

Add to zabbix_agent2.conf

UserParameter=docker.image_names,/path/to/image_names.py
UserParameter=docker.container.image_name[*],/path/to/is_docker_container_available.py $1

------------------

Key for discovery rule

docker.image_names

------------------

Key for item prototype

docker.container.image_name[{#NAME}]

------------------

Expression for trigger prototype

last(/hostname/docker.container.image_name[{#NAME}])=0
