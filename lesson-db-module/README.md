# Lesson-8-9 Terraform Infrastructure

## 📂 Структура проєкту

```
Lesson-8-9/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальні виводи ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf       # Виводи VPC
│   │
│   ├── ecr/                 # Модуль для ECR
│   │   ├── ecr.tf           # Створення ECR репозиторію
│   │   ├── variables.tf     # Змінні для ECR
│   │   └── outputs.tf       # Виведення URL репозиторію
│   │
│   ├── eks/                 # Модуль для Kubernetes кластера
│   │   ├── eks.tf           # Створення кластера
│   │   ├── aws_ebs_csi_driver.tf # Встановлення плагіну csi driver
│   │   ├── variables.tf     # Змінні для EKS
│   │   └── outputs.tf       # Виводи інформації про кластер
│   │
│   ├── jenkins/             # Модуль для Helm-установки Jenkins
│   │   ├── jenkins.tf       # Helm release для Jenkins
│   │   ├── variables.tf     # Змінні (ресурси, креденшели, values)
│   │   ├── providers.tf     # Оголошення провайдерів
│   │   ├── values.yaml      # Конфігурація Jenkins
│   │   └── outputs.tf       # Виводи (URL, пароль адміністратора)
│   │
│   └── argo_cd/             # Модуль для Helm-установки Argo CD
│       ├── argo_cd.tf       # Helm release для Argo CD
│       ├── variables.tf     # Змінні (версія чарта, namespace, repo URL)
│       ├── providers.tf     # Kubernetes + Helm
│       ├── values.yaml      # Кастомна конфігурація Argo CD
│       ├── outputs.tf       # Виводи (hostname, initial admin password)
│       └── charts/          # Helm-чарт для створення app'ів
│           ├── Chart.yaml
│           ├── values.yaml  # Список applications, repositories
│           └── templates/
│               ├── application.yaml
│               └── repository.yaml
│
├── charts/
│   └── django-app/          # Helm-чарт для Django застосунку
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml      # ConfigMap зі змінними середовища
```

---

## 🚀 Команди для запуску

```bash
# Ініціалізація Terraform
terraform init

# Перевірка плану змін
terraform plan

# Застосування конфігурації
terraform apply

# Видалення створених ресурсів
terraform destroy

📌 Опис модулів
1. s3-backend
Створює S3 bucket для збереження стейт-файлів Terraform.
Вмикає версіонування для збереження історії змін.
Створює DynamoDB таблицю для блокування стейтів (щоб уникнути конфліктів при одночасному запуску).
Виводить URL S3-бакета та ім’я таблиці DynamoDB.

2. vpc
Створює VPC з заданим CIDR блоком.
Додає 3 публічні та 3 приватні підмережі.
Налаштовує Internet Gateway для публічних підмереж.
Створює NAT Gateway для приватних підмереж.
Конфігурує Route Tables для маршрутизації.
Виводить ID VPC та списки підмереж.

3. ecr
Створює Elastic Container Registry (ECR) для зберігання Docker-образів.
Вмикає автоматичне сканування образів при завантаженні.
Налаштовує політику доступу.
Виводить URL репозиторію.

✅ Використання
Переконайтесь, що у вас налаштований AWS CLI та доступні креденшали.
Запустіть terraform init для ініціалізації бекенду.
Виконайте terraform apply для створення інфраструктури.
Використовуйте вихідні дані з outputs.tf для інтеграції з іншими сервісами.

4. eks
Створює Amazon EKS кластер.
Налаштовує Node Group з параметрами (instance type, desired/min/max size).
Встановлює AWS EBS CSI Driver для роботи з persistent volumes.
Виводить endpoint кластера, сертифікати та ім’я.

5. jenkins
Встановлює Jenkins через Helm‑чарт.
Використовує Kubernetes‑агенти для запуску job’ів.
Конфігурація зберігається у values.yaml.
Виводить URL Jenkins та пароль адміністратора.

6. argo_cd
Встановлює Argo CD через Helm‑чарт.
Використовує кастомний values.yaml для конфігурації.
Має власний каталог charts/ для створення Argo CD applications та repositories.
Виводить hostname та початковий пароль адміністратора.

🔑 Використання
Переконайтесь, що у вас налаштований AWS CLI та доступні креденшели.

Запустіть:
terraform init
terraform apply
Перевірте, що Argo CD запущений:

kubectl get pods -n argocd
Отримайте початковий пароль адміністратора:

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
Використовуйте вихідні дані з outputs.tf для інтеграції з іншими сервісами.
```
