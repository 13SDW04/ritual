#!/bin/bash

# Функция для редактирования файла с использованием sed
edit_file() {
    local file=$1
    local search=$2
    local replace=$3

    if [[ -f "$file" ]]; then
        # Используем sed для замены строки в файле
        sed -i "s|$search|$replace|g" "$file"
    else
        echo "Файл $file не найден. Пропускаю..."
    fi
}

# Путь к файлам конфигурации
deploy_config=~/infernet-container-starter/deploy/config.json
hello_world_config=~/infernet-container-starter/projects/hello-world/container/config.json

# Запрос ввода значений у пользователя
read -p "Введите RPC URL (например, https://mainnet.base.org/): " rpc_url
read -p "Введите приватный ключ (с префиксом 0x): " private_key
read -p "Введите Registry адрес (например, 0x3B1554f346DFe5c482Bb4BA31b880c1C18412170): " registry_address
read -p "Введите значение sleep для snapshot_sync (например, 3): " snapshot_sleep
read -p "Введите значение starting_sub_id для snapshot_sync (например, 160000): " snapshot_starting_sub_id
read -p "Введите значение batch_size для snapshot_sync (например, 800): " snapshot_batch_size
read -p "Введите значение sync_period для snapshot_sync (например, 30): " snapshot_sync_period

# 1. Редактируем config.json в папке hello-world
# Упрощаем работу с JSON-полями
if [[ -f "$hello_world_config" ]]; then
    sed -i "s|\"RPC URL\": \".*\"|\"RPC URL\": \"$rpc_url\"|g" "$hello_world_config"
    sed -i "s|\"Private Key\": \".*\"|\"Private Key\": \"$private_key\"|g" "$hello_world_config"
    sed -i "s|\"Registry\": \".*\"|\"Registry\": \"$registry_address\"|g" "$hello_world_config"
    sed -i "s|\"snapshot_sync\": {.*}|\"snapshot_sync\": { \"sleep\": $snapshot_sleep, \"starting_sub_id\": $snapshot_starting_sub_id, \"batch_size\": $snapshot_batch_size, \"sync_period\": $snapshot_sync_period }|g" "$hello_world_config"
else
    echo "Файл $hello_world_config не найден. Пропускаю..."
fi



