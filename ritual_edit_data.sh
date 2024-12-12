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

# Запрос ввода значений у пользователя
read -p "Введите RPC URL (например, https://mainnet.base.org/): " rpc_url
read -p "Введите приватный ключ (с префиксом 0x): " private_key
read -p "Введите Registry адрес (например, 0x3B1554f346DFe5c482Bb4BA31b880c1C18412170): " registry_address
read -p "Введите значение sleep для snapshot_sync (например, 3): " snapshot_sleep
read -p "Введите значение batch_size для snapshot_sync (например, 800): " snapshot_batch_size
read -p "Введите значение trail_head_blocks (например, 3): " trail_head_blocks
read -p "Введите версию (например, 1.4.0): " version

# 1. Редактируем config.json в папке deploy
edit_file "$deploy_config" '"RPC URL": \"[^\"]*\"' "\"RPC URL\": \"$rpc_url\""
edit_file "$deploy_config" '"Private Key": \"[^\"]*\"' "\"Private Key\": \"$private_key\""
edit_file "$deploy_config" '"Registry": \"[^\"]*\"' "\"Registry\": \"$registry_address\""
edit_file "$deploy_config" '"sleep": [0-9]*' "\"sleep\": $snapshot_sleep"
edit_file "$deploy_config" '"batch_size": [0-9]*' "\"batch_size\": $snapshot_batch_size"
edit_file "$deploy_config" '"trail_head_blocks": [0-9]*' "\"trail_head_blocks\": $trail_head_blocks"

# 2. Редактируем config.json в папке hello-world
edit_file "$hello_world_config" '"RPC URL": \"[^\"]*\"' "\"RPC URL\": \"$rpc_url\""
edit_file "$hello_world_config" '"Private Key": \"[^\"]*\"' "\"Private Key\": \"$private_key\""
edit_file "$hello_world_config" '"Registry": \"[^\"]*\"' "\"Registry\": \"$registry_address\""
edit_file "$hello_world_config" '"snapshot_sync": \{[^}]*\}' "\"snapshot_sync\": { \"sleep\": $snapshot_sleep, \"starting_sub_id\": 160000, \"batch_size\": $snapshot_batch_size, \"sync_period\": 30 }"
edit_file "$hello_world_config" '"trail_head_blocks": [0-9]*' "\"trail_head_blocks\": $trail_head_blocks"

# 3. Редактируем Deploy.s.sol
edit_file "$deploy_script" 'RPC URL: .*' "RPC URL: $rpc_url"
edit_file "$deploy_script" 'Private Key: .*' "Private Key: $private_key"
edit_file "$deploy_script" 'version: [0-9.]*' "version: $version"

# 4. Редактируем Makefile
edit_file "$makefile" '"Register_address": \"[^\"]*\"' "\"Register_address\": \"$registry_address\""

# 5. Внесение изменений в docker-compose.yaml (если необходимо, добавьте конкретные изменения здесь)
# Пример для редактирования (замените на нужную строку или настройку):
# edit_file "$docker_compose" 'старое_значение' 'новое_значение'

echo "Все изменения внесены. Выход из редакторов через Ctrl+X, Y, Enter"



