<div align="center">

# **DevOps Final Project**

### Kubernetes • GitOps • CI/CD

</div>


---


## **Опис проєкту**

Цей проєкт показує повний цикл доставки додатку: від змін у коді до автоматичного деплою в Kubernetes.

При зміні коду запускається pipeline:
- перевіряє код
- збирає Docker image
- пушить його в Docker Hub
- оновлює deployment

Далі ArgoCD автоматично підхоплює ці зміни і синхронізує їх з кластером.

Повний шлях виглядає так:
```text
git push → build → push image → update manifests → ArgoCD sync → deploy у Kubernetes
```

Додаток реалізований на FastAPI і повертає інформацію про pod (ім’я, IP, uptime), що дозволяє наочно показати балансування трафіку між pod у кластері.



---

## **Структура проєкту**


```
Final-Project/
├── app/                    # код додатку (FastAPI + frontend)
├── kubernetes/             # описують як додаток запускається у кластері 
│                           # (deployment, service, ingress)
├── terraform/              # інфраструктура як код
│                           # створення EKS, VPC, LoadBalancer, DNS
├── argocd/                 # GitOps (Application) конфігурація
│                           # Application, який зв’язує Git і кластер
├── .github/workflows/      # CI/CD pipeline
│                           # автоматизація: build → push → update → deploy
└── Dockerfile              # опис контейнера
                            # як збирається і запускається додаток

```
---

## **Архітектура доступу до додатку**

повний шлях запиту від користувача до додатку в kubernetes

```text
Client → Route53 → LoadBalancer → Ingress → Service → Pod
```


- **Client**  -  користувач відкриває додаток у браузері через DNS ім’я  

- **Route53**  - DNS сервіс AWS, який перетворює доменне ім’я у IP адресу LoadBalancer  

- **LoadBalancer (AWS ELB)** - приймає зовнішній трафік з інтернету і передає його в Kubernetes кластер  

- **Ingress (NGINX)**  - обробляє HTTP/HTTPS запити, маршрутизує їх до потрібного сервісу  

- **Service (ClusterIP)** - дає стабільний доступ до pod і балансирує трафік між ними  

- **Pod**  - обробляє запит 

---

## **Технології**


| Компонент | Призначення |
|----------|------------|
| Python (FastAPI) | Backend |
| Docker | Контейнеризація |
| Kubernetes | Оркестрація |
| Terraform | Інфраструктура |
| ArgoCD | GitOps |
| GitHub Actions | CI/CD |


---

## **CI/CD pipeline**


Pipeline налаштований так, щоб запускатися тільки при зміні коду додатку або docker-образу:
```text
app/**
Dockerfile
```

Таким чином::
- зміни в інфраструктурі (terraform, kubernetes) **не запускають pipeline**
- pipeline працює тільки тоді, коли реально потрібно перевірити та задеплоїти нову версію додатку

Це дозволяє:
- зменшується кількість зайвих запусків
- прискорюється робота CI/CD
- немає “шуму” у GitHub Actions


Pipeline ігнорує зміни у `kubernetes/deployment.yaml`, щоб уникнути зациклення.  
Оскільки pipeline сам оновлює цей файл (змінює тег Docker image), без цього він запускався б повторно після кожного commit від GitHub Actions.


---


## **Pipeline Flow**


У цьому проєкті реалізований повний CI/CD процес, який автоматично запускається при зміні коду додатку.

Послідовність етапів виглядає так:

```text
Lint → Build → Scan → Push → Update → ArgoCD Sync

```

- **Lint**  
  перевірка коду:
  - Python синтаксис  
  - Dockerfile (lint)  
  - пошук секретів у репозиторії  

  перевіряє код перед збіркою.

- **Build**  
  збирається Docker образ додатку.
  перевіряє, що додаток збирається і запускається.

- **Scan**  
  перевірка безпеки (security scan).
  шукає вразливості в залежностях.

- **Push**  
  готовий Docker образ пушиться в Docker Hub.
  після цього образ доступний для Kubernetes.

- **Update**  
  Pipeline автоматично оновлює файл:

  ```
  kubernetes/deployment.yaml
  ```

  змінюється тег образу на новий (commit SHA).

  це потрібно, щоб:
  - Kubernetes не оновлює pod без зміни образу
  - новий тег = новий rollout


- **ArgoCD Sync**  
  ArgoCD бачить зміну в Git і автоматично застосовує її до кластера.

  далі:
  - створюються нові pod
  - старі замінюються
  - додаток оновлюється без простою

```text
змінив код → git push → pipeline запустився → image зібрався → image залився в Docker Hub → deployment оновився → ArgoCD застосував зміни → pod перезапустились
```

В результаті:

- повністю автоматичний деплой  
- мінімум ручних дій  
- контроль через Git  
- передбачуваний результат  

---

## **Розгортання**


### 1. Підготовка Terraform backend (DynamoDB lock)

```bash
aws dynamodb create-table \
  --table-name <table name> --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region eu-central-1
```

Cтворює DynamoDB таблицю для Terraform lock. Terraform використовує її для блокування state, запобігає одночасному виконанню terraform apply та захищає від пошкодження state.



### 2. Terraform

```bash
terraform init
terraform apply
```

створює інфраструктуру (EKS, VPC, Ingress)



### 3. Підключення до кластера

```bash
aws eks update-kubeconfig --region eu-central-1 --name <cluster>
```

дозволяє працювати через kubectl


### 4. ArgoCD

```bash
kubectl apply -f argocd/application.yaml
```

запускає GitOps


## Перевірка системи


### pods

```bash
kubectl get pods -n python-app
```

показує чи працює додаток


### service

```bash
kubectl get svc -n python-app
```

показує як трафік доходить до pod


### ingress

```bash
kubectl get ingress -n python-app
```

показує DNS та LoadBalancer


### endpoints

```bash
kubectl get endpoints -n python-app
```

якщо пусто → буде 503

---

## Тест помилки


```bash
kubectl scale deployment python-app -n python-app --replicas=0
```

результат:

```
503 Service Unavailable
```

---

## Debug Commands


```bash
kubectl get pods -n python-app
```
показує всі pod у namespace `python-app`  
показує:
- чи запущений додаток
- скільки pod працює
- їх статус (Running / CrashLoopBackOff / Pending)


```bash
kubectl get svc -n python-app
```
показує Kubernetes Service  
показує:
- через який порт доступний додаток
- як трафік маршрутизується до pod


```bash
kubectl get ingress -n python-app
```
показує Ingress ресурс  
показує:
- DNS ім’я додатку
- адресу LoadBalancer
- чи доступний додаток ззовні



```bash
aws eks update-kubeconfig --region eu-central-1 --name <cluster>
```
додає кластер у kubeconfig  
дозволяє використовувати kubectl  

після цього можна використовувати kubectl


```bash
kubectl apply -f argocd/application.yaml
```
створює Application в ArgoCD  

- ArgoCD починає відслідковувати Git репозиторій
- автоматично синхронізує Kubernetes


```
*kubectl* → перевірка стану Kubernetes  
*terraform* → створення інфраструктури  
*aws eks update-kubeconfig* → підключення до кластера  
*kubectl apply* → запуск GitOps через ArgoCD
```

---

## Висновок


У цьому проєкті реалізовано повний цикл доставки додатку - від змін у коді до автоматичного деплою в Kubernetes.

Тут реалізовано кілька ключових речей:

- **CI/CD pipeline**  
  Коли в репозиторій потрапляють зміни, pipeline автоматично запускається: перевіряє код, збирає Docker image, пушить його в Docker Hub і оновлює deployment у Kubernetes.  
  Весь процес відбувається автоматично.

- **GitOps підхід через ArgoCD**  
  Кластер не налаштовується вручну - він "дивиться" на Git.  
  Як тільки змінюється deployment у репозиторії, ArgoCD підтягує ці зміни і Приводить кластер у відповідний стан.  
  Кластер завжди відповідає стану в Git.

- **Kubernetes як платформа запуску**  
  Додаток працює в EKS-кластері з використанням:
  - Deployment - керує pod і їх кількістю  
  - Service - відповідає за доступ всередині кластера  
  - Ingress - дає доступ ззовні через DNS  
  - health checks - дозволяють Kubernetes розуміти, чи живий додаток  

  Додаток можна масштабувати і він продовжує працювати навіть при падінні pod.

- **Інфраструктура через Terraform**  
  Вся інфраструктура описана як код:
  - створюється EKS кластер  
  - налаштовується мережа (VPC)  
  - піднімається Load Balancer  
  - працює DNS через Route53  
  - використовується TLS через ACM  

  Інфраструктуру можна підняти з нуля однією командою.



У підсумку виходить повний цикл:

```text
змінив код → запушив → pipeline зібрав → ArgoCD задеплоїв → додаток оновився

```


Фінальний проект демонструє

- як автоматизується доставка (CI/CD)  
- як керується кластер через Git (GitOps)  
- як працює Kubernetes у реальному сценарії  
- як усе це інтегрується в AWS  
---





## Demo

Додаток доступний за адресою:
https://app.allex-devops.devops11.test-danit.com

Відео демонстрації:

[▶️ Demo video](https://raw.githubusercontent.com/allex-git/azigman/33c2548b44a70304ab85c73fed7cc595fa4057dc/Final%20project/screens/demo_app_work.mp4)

---


<div align="center">
Дякую за увагу :)

</div>
