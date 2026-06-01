# Ansible Playbook: развертывание инфраструктуры (HW-03)

 Этот проект содержит Ansible-playbook для развертывания полного стека систем логирования и веб-визуализации:

- ClickHouse (серверная часть для хранения журналов)
- Vector (сборщик и обработчик журналов)
- Nginx (веб-сервер)
- Lighthouse (веб-интерфейс для данных ClickHouse)

---

## Действия выполнения playbook

Playbook `site.yml` выполняет следующие действия:

### 1. Настройка ClickHouse
- Устанавливает пакеты ClickHouse
- Настраивает репозиторий
- Применяет шаблоны конфигурации
- Создает базу данных и таблицу
- Открывает и проверяет HTTP и собственные порты (8123/9000)
- Ожидает, когда ClickHouse станет доступен

---

### 2. Настройка Vector
- Устанавливает сборщик журналов Vector
- Настраивает репозиторий
- Развертывает шаблон Vector конфигурации
- Собирает логи доступа nginx
- Отправляет логи в ClickHouse

---

### 3. Настройка Nginx + Lighthouse
- Устанавливает веб-сервер Nginx
- Клонирует репозиторий Lighthouse
- Развертывает конфигурацию Nginx
- Настраивает корневой каталог веб-сайта
- Обслуживает пользовательский интерфейс Lighthouse через Nginx

---

## Inventory

Playbook предполагает наличие следующих групп хостов:

- `clickhouse` — сервер ClickHouse
- `vector` — сервер сбора журналов
- `nginx` — веб-сервер

Пример:

```yaml id="inv1"
clickhouse:
  hosts:
    clickhouse-01:

vector:
  hosts:
    web-01:

nginx:
  хосты:
    web-01:
```
## Структура плейбука

Плейбук содержит 3 основных этапа:

Установка и настройка ClickHouse
Установка Vector и настройка переадресации журналов
Развертывание Nginx + Lighthouse

## Tags
Вы можете запускать отдельные части playbook с помощью тега:
ClickHouse
```
ansible-playbook -i inventory/site.yml prod.yml --tags clickhouse
```
Vector
```
ansible-playbook -i inventory/site.yml prod.yml --tags vector
```
Nginx + Lighthouse
```
ansible-playbook -i inventory/site.yml prod.yml --tags nginx
```

## Переменные

### Переменные ClickHouse
- clickhouse_db_name — имя базы данных (по умолчанию: nginx)
- clickhouse_table_name — имя таблицы для журналов
- clickhouse_http_port — HTTP-порт (по умолчанию: 8123)
- clickhouse_nativ_port — собственный порт (по умолчанию: 9000)
- clickhouse_version — версия пакета
- clickhouse_repo_baseurl — URL репозитория

### Переменные Vector
- vector_include_logs — путь к журналам nginx
- vector_template_dest — путь назначения конфигурации
- vector_repo_url — репозиторий пакетов
- vector_timeout — время ожидания службы

### Переменные Nginx / Lighthouse
- nginx_template_test - путь к конфигурации  
- nginx_root_dir - корневой веб-каталог
- lighthouse_git_repo - URL репозитория Git Lighthouse
- lighthouse_git_dest - путь распаковки clone

## Примечания
- Этот проект предназначен для образовательных целей.
- Для всех управляемых узлов требуется доступ по SSH.
- Порты ClickHouse должны быть доступны с хоста Vector.
- Перед выполнением необходимо правильно настроить Inventory.
- Для развертывания инфраструктуры в проекте присутствует terraform из 2-х instance, VPC (vpc gateway, vpc network, vpc subnet, vpc route table), image family rocky-9-oslogin
