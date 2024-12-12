#!/bin/bash

# Функция для редактирования файла с использованием sed
edit_file() {
    local file=$1
    local search=$2
    local replace=$3

    # Используем sed для замены строки в файле
    sed -i "s|$search|$replace|g" "$file"
}

# Путь к файлам конфигурации
deploy_config=~/infernet-container-starter/deploy/config.json
hello_world_config=~/infernet-container-starter/projects/hello-world/container/config.json
deploy_script=~/infernet-container-starter/projects/hello-world/contracts/script/Deploy.s.sol
makefile=~/infernet-container-starter/projects/hello-world/contracts/Makefile
docker_compose=~/infernet-container-starter/deploy/docker-compose.yaml

# 1. Редактируем config.json в папке deploy
edit_file "$deploy_config" '"snapshot_sync": {' '"snapshot_sync": { "sleep": 5, "starting_sub_id": 160000, "batch_size": 800, "sync_period": 30 }'
edit_file "$deploy_config" '"trail_head_blocks": 3' '"trail_head_blocks": 3'

# 2. Редактируем config.json в папке hello-world
edit_file "$hello_world_config" '"Register_address":' '"Register_address": "0x3B1554f346DFe5c482Bb4BA31b880c1C18412170"'

# 3. Редактируем Deploy.s.sol
edit_file "$deploy_script" 'RPC URL:' 'RPC URL: https://mainnet.base.org/'
edit_file "$deploy_script" 'Private Key:' 'Private Key: 0xваш_приватный_ключ'  # Замените на ваш приватный ключ

# 4. Редактируем Makefile
edit_file "$makefile" '"Register_address":' '"Register_address": "0x3B1554f346DFe5c482Bb4BA31b880c1C18412170"'

# 5. Обновляем версию в Deploy.s.sol
edit_file "$deploy_script" 'version: ' 'version: 1.4.0'

# 6. Внесение изменений в docker-compose.yaml (если необходимо, добавьте конкретные изменения здесь)
# Пример для редактирования (замените на нужную строку или настройку):
# edit_file "$docker_compose" 'старое_значение' 'новое_значение'

echo "Все изменения внесены. Выход из редакторов через Ctrl+X, Y, Enter"
