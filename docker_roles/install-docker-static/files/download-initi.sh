#!/bin/bash

# --- Настройки ---
distrib_path="/opt/distrib"
link="https://prod.initi.ru/share/dockers.3.0.6b/"

# --- Списки файлов ---
declare -a images=("solodb.tar" "platform.tar" "gui.tar" "collector.tar" "integration.tar")
declare -a run_scripts=("solodb.sh" "platform.sh" "gui.sh" "collector.sh" "integration.sh")
declare -a compose_files=("docker-compose.yml")
declare -a docs=("installation-guide.md" "update-guide.md")

# --- Определение актуальной версии ---
# Парсим "Дата релиза:" со страницы, убираем HTML-теги, пробелы и точки
actual_version=$(curl --retry 5 -k -s "$link" \
    | grep 'Дата релиза:' \
    | sed -e 's/Дата релиза: <strong>//g' \
          -e 's/<\/strong>//g' \
          -e 's/^[ \t]*//g' \
          -e 's/\.//g')

# --- Функция загрузки одного файла ---
dwnld(){
    local file="${1}"
    local target_dir="${distrib_path}/${actual_version}"

    # Если файл уже существует — пропускаем
    if [ -f "${target_dir}/${file}" ]; then
        echo "Файл ${file} уже существует в ${target_dir}. Пропускаю."
        return 0
    fi

    echo "Загружаю ${file} ..."
    curl --retry 5 -L -f -k -o "${target_dir}/${file}-dwnld" "${link}${file}"

    if [ $? -eq 0 ]; then
        mv "${target_dir}/${file}-dwnld" "${target_dir}/${file}"
        echo "Файл ${file} загружен в ${target_dir}"
        return 0
    else
        echo "Ошибка при загрузке файла ${file}"
        rm -f "${target_dir}/${file}-dwnld"
        return 1
    fi
}

# --- Основная логика ---
if [ -z "${actual_version}" ]; then
    echo "Ошибка подключения к порталу или не удалось определить версию."
    exit 1
fi

echo "Актуальная на портале версия сборки: ${actual_version}"

# Создаём каталог версии, если его нет
if [ ! -d "${distrib_path}/${actual_version}" ]; then
    echo "Каталог ${distrib_path}/${actual_version} не существует. Создаю..."
    mkdir -p "${distrib_path}/${actual_version}"
fi

# Скачиваем архивы с образами
echo "Начинаю загрузку архивов с образами..."
for file in "${images[@]}"; do
    dwnld "${file}"
done

# Скачиваем shell-скрипты
echo "Начинаю загрузку shell-скриптов..."
for file in "${run_scripts[@]}"; do
    dwnld "${file}"
done

# Скачиваем docker-compose
echo "Начинаю загрузку docker-compose..."
for file in "${compose_files[@]}"; do
    dwnld "${file}"
done

# Скачиваем документацию
echo "Начинаю загрузку документации..."
for file in "${docs[@]}"; do
    dwnld "${file}"
done

echo "Готово. Файлы находятся в ${distrib_path}/${actual_version}"