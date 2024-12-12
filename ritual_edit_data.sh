#!/bin/bash

# Пути к файлам config.json, Deploy.s.sol, Makefile и docker-compose.yaml
deploy_config="root/infernet-container-starter/deploy/config.json"
hello_world_config="root/infernet-container-starter/projects/hello-world/container/config.json"
deploy_script="root/infernet-container-starter/projects/hello-world/contracts/script/Deploy.s.sol"
makefile="root/infernet-container-starter/projects/hello-world/contracts/Makefile"
docker_compose="root/infernet-container-starter/deploy/docker-compose.yaml"

# Проверяем, существуют ли файлы
if [[ ! -f $deploy_config ]]; then
    echo "Файл $deploy_config не найден."
    exit 1
fi

if [[ ! -f $hello_world_config ]]; then
    echo "Файл $hello_world_config не найден."
    exit 1
fi

if [[ ! -f $deploy_script ]]; then
    echo "Файл $deploy_script не найден."
    exit 1
fi

if [[ ! -f $makefile ]]; then
    echo "Файл $makefile не найден."
    exit 1
fi

if [[ ! -f $docker_compose ]]; then
    echo "Файл $docker_compose не найден."
    exit 1
fi

# Запрос ввода приватного ключа и версии infernet-node у пользователя
read -p "Введите приватный ключ (с префиксом 0x): " private_key
read -p "Введите версию infernet-node (например, 1.4.0): " infernet_version

# Предустановленные значения
rpc_url="https://mainnet.base.org/"
registry_address="0x3B1554f346DFe5c482Bb4BA31b880c1C18412170"
trail_head_blocks=3
snapshot_sleep=3
snapshot_starting_sub_id=160000
snapshot_batch_size=800
snapshot_sync_period=30

# Функция для обновления JSON файла
update_config() {
    local config_file=$1

    jq --arg rpc_url "$rpc_url" \
       --arg private_key "$private_key" \
       --arg registry_address "$registry_address" \
       --argjson trail_head_blocks "$trail_head_blocks" \
       --argjson snapshot_sleep "$snapshot_sleep" \
       --argjson snapshot_starting_sub_id "$snapshot_starting_sub_id" \
       --argjson snapshot_batch_size "$snapshot_batch_size" \
       --argjson snapshot_sync_period "$snapshot_sync_period" \
       '
       .chain.rpc_url = $rpc_url |
       .chain.registry_address = $registry_address |
       .chain.trail_head_blocks = $trail_head_blocks |
       .chain.wallet.private_key = $private_key |
       .chain.snapshot_sync.sleep = $snapshot_sleep |
       .chain.snapshot_sync.starting_sub_id = $snapshot_starting_sub_id |
       .chain.snapshot_sync.batch_size = $snapshot_batch_size |
       .chain.snapshot_sync.sync_period = $snapshot_sync_period |
       del(.docker)
       ' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"

    echo "Файл $config_file успешно обновлен."
}

# Функция для обновления Deploy.s.sol
update_deploy_script() {
    local script_file=$1

    sed -i "s/address registry .*/address registry = $registry_address;/" "$script_file"

    echo "Файл $script_file успешно обновлен."
}

# Функция для обновления Makefile
update_makefile() {
    local makefile=$1

    sed -i "s/^sender.*/sender = $private_key/" "$makefile"
    sed -i "s/^RPC_URL.*/RPC_URL = $rpc_url/" "$makefile"

    echo "Файл $makefile успешно обновлен."
}

# Функция для обновления docker-compose.yaml
update_docker_compose() {
    local compose_file=$1

    sed -i "s|ritualnetwork/infernet-node:.*|ritualnetwork/infernet-node:$infernet_version|" "$compose_file"

    echo "Файл $compose_file успешно обновлен."
}

# Обновляем оба файла config.json
update_config "$deploy_config"
update_config "$hello_world_config"

# Обновляем Deploy.s.sol
update_deploy_script "$deploy_script"

# Обновляем Makefile
update_makefile "$makefile"

# Обновляем docker-compose.yaml
update_docker_compose "$docker_compose"




