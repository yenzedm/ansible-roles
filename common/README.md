Role Name
=========

A brief description of the role goes here.

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

### connect swap

block этакая группировка нескольких связанных тасок в одну сущность. Аргумент creates используется в модулях shell и command и нужен чтобы проверить существует такой файл или нет. Если файл существует то ansible ничо не будет делать.

Пятая секция прописывает новоиспеченный swap файл в /etc/fstab. Чтобы при перезагрузки сервера, swap автоматически монтировался.
Для этого используется модуль mount.
name: none = указываем точку монтирования, ее нет, это свап
src: /swapfile = путь к файлу подкачки, который будет добавлен в fstab
fstype: swap = тип файловой системы, логично swap
opts: sw = опции монтирования, обычно это sw
passno: 0 = отключаем проверку файловой системы при загрузке
dump: 0 = отключаем дампирование файловой системы. Забей!
state: present = запись в fstab должна быть добавлена, если ее еще нет.
По итогу в файле /etc/fstab получим такое:
/swapfile none swap sw 0 0

Если у тебя уже был создан swap, можешь от него избавиться:
swapоff -a
Затем физически удалить файл /swapfile
Ну и выкосить строчку из /etc/fstab
/swapfile none swap sw 0 0 
