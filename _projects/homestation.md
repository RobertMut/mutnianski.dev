---
title: HomeStation
summary: Maecenas faucibus mollis interdum, donec sed odio dui.
code: Hmst
order: 2
commercial: false
---

Design and construction of a solution for the measurement and storage of environmental parameters in the home environment using ESP32, C++, ESP-IDF, MQTT, ASP.NET and containerisation.

<a href="https://github.com/RobertMut/HomeStation2" rel="permalink"><i class="fa-brands fa-github" aria-hidden="true" title="permalink"></i> Link to project</a>  

# Introduction

My purpose in creating this was to focus on connecting different environments and tools together to provide a solution to user to measure temperature, humidity, pressure and particulate matters (PM) levels.
Of course it didn't happen overnight and I had to quickly learn quickly many technologies just to run basic functionality (i.e connect device to Wi-Fi, subscribe and send hello world to mqtt broker). The concept changed a few times, but the maintain idea stayed intact.

## Used technologies
Let's be clear. Everything wasn't planned by obsessing over a lot of models and graphs. I had an initial concept in my mind:
- I need a device with a sensor that logs data
- I need to receive data
- I need to store data
- And finally I need to show data.

So, knowing the .NET environment and a little bit of Angular, I decided that they would be my go-to in this project.  
Much worse was the device. .NET nanoFramework, Python, Rust, C, C++? What should I choose? After looking at and toying with a few ([and messing with one for a bit longer](https://docs.esp-rs.org/book/)), I've decided to go with C/C++ with ESP.IDF (sorry Arduino).  
At this point I know which tools to use, but there are still two questions - where and how to store the data, and how to send this data from the device?  
  
The first question was easy to answer - MSSQL. Of course I could use the MySQL, Postgre, Mongo, etc., but first - I know MSSQL better than any other solution in this matter. Secondly, I don't need to use NoSQL, because the data is structured and this structure is immutable, so storing it as e.g JSON is a bit of overkill. Finally, [there is a pre-built container image](https://hub.docker.com/r/microsoft/mssql-server).  
  
The second question, was not simple as the first one. Should I use REST API? Well [ESP32 with ESP-IDF onboard can send POST requests](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-reference/protocols/esp_http_client.html), but what if I want to collect measurements from more than one device? For example - two, five, hundred, thousand? As you can see as the number of devices increases the problem grows, due to sending large amount of POST requests being sent. After googling and looking back and forth I stumbled upon [MQTT](https://mqtt.org/), and there is [a use-case describing the same situation as mine](https://www.ibm.com/docs/en/ibm-mq/9.4?topic=cases-telemetry-use-environment-sensing). I didn't want to add another layer just for maintenance (but it could be done), so i skipped solutions like [mosquitto](https://mosquitto.org/). In the end I came across [MQTTnet](https://github.com/dotnet/MQTTnet), which could be implemented alongside my REST API.  
  
The final tech stack should look like this:
- ASP.Net - I wanted to communicate with the UI somehow, REST API seemed the best,
- Entity Framework - ORM just to store/read data to/from database,
- MQTTnet - For device to subscribe and send message under topic
- ESP-IDF - IoT framework for device to communicate with sensors and a broker
- Angular + Angular Material - Framework and set of already prepared controls for the UI  
- Chart.js - Data needs to be presented as graph  

## Device
I knew exactly which environmental parameters I wanted to measure. I had two DHT22s in my drawer, but they didn't work at all.
I browsed the shops and ordered a Bosch BME280 (which will cause problems in the future), and a Plantower PMS3003.
I also added HD44780. The last thing left was the board, which ESP should I choose. I already had two Wemos D1 R32, but they're are quite big, so after some consideration I decided to buy ESP32-WROOM.  
  
### Physical connection
![]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_connection.png)  
The final connection went as follows. Everything is soldered on the prototyping board with longer cables to the BME280 to avoid heat from the ESP32 or other devices.
Overall I had to change my original connections due to that some of the pins are reserved and connecting to them causes that the device not to boot up.  
  
### Code
What I've googled the best solution was to assign MQTT client and PMS client to separate [tasks](https://www.freertos.org/Documentation/02-Kernel/02-Kernel-features/01-Tasks-and-co-routines/00-Tasks-and-co-routines). BME280 and printing data to HD44780 on the `main` method.  
The reason to staying on `main` was to less troubles with interrupts. From my observation when I am communicate with device on raw GPIO port if interrupt happens I will miss timings in milliseconds that are required by hardware.

### 3D Printing
Our cable-soldering mess needs protection if [devil creatures](https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Cat_March_2010-1.jpg/800px-Cat_March_2010-1.jpg) decide to destroy it. My options were limited for me, because I own a 3d printer, so I went for it.  
![]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_case.png)  
A hour or two in blender later and It's done. Time to print.
<video muted autoplay controls style="width: 100%; height: fit-content;">
    <source src="{{ site.url }}{{ site.baseurl }}/assets/videos/homestation2/homestation2_3dprinting.mp4" type="video/mp4">
</video>  

## Backend and Frontend
As I mentioned in *Used technologies*, I wanted to receive and store data. The device connects via WiFi and tries to subscribe to non existing MQTT broker.
This means that some kind of a broker, database is needed to process further. Of course raw readings mean nothing, if I can't present them in an easily readable form.

### Backend
At this point, I decided to play it safe and went with the known [clean architecture](https://jasontaylor.dev/clean-architecture-getting-started/) (but it's a bit overkill). Quickly created projects in my solution, and after reading MQTTnet documentation, deployed the broker.  
![]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_telnet.png)  
Eureka! I've connected to the MQTT broker. Time to flash device with specific connection parameters and try to send data.
![]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_mqtt.png) 
The readings have been sent and received via the API. So now all that's left on this side is to put it into database.
Quickly prepared [options pattern](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/configuration/options?view=aspnetcore-9.0) for the database's required values, and prepared [classes to create tables from them (code-first approach)](https://learn.microsoft.com/en-us/ef/ef6/modeling/code-first/workflows/new-database).
The database looks like this:
![]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_database.png)  
I added database migration and applied it to a local instance of Microsoft SQL Server.
After running API again:
![]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_dbreadings.png)  
At the moment, the device was communicating with API through this interface  
```json
    {
    "deviceid": 1 //number,
    "temperature": 24.9 //double,
    "humidity": 44 //double,
    "pressure": 100321.6 //double,
    "pm1_0": "5" //number,
    "pm2_5": "9" //number,
    "pm10": "9" //number
    }
```  
As you can see the read date property is missing here. The reason behind this approach is to avoid maintaning the clock as physical part of the device (the clock has to be part of the device with an additional power source from battery to 'hold' the date and time between reboots), or calling the NTP provider periodically/every time to send data.

### Frontend
The data can be stored and received as JSON, which isn't very pleasant to read it when there is a large amount of data.
The UI was a must from the start. After a while I added a sidebar with device management, a page with current readings, and tabs with graphs.
The data could be displayed now, but what if the user wants to look at the long-term data? Not a day or two, but say - ten or even a hundred?
It's worth using [zoom plugin for chart.js](https://www.chartjs.org/chartjs-plugin-zoom/latest/), which solves this problem.
After a few days of testing and tweaking the code it resulted in this layout:
![Latest reading and device management]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_current.png)  
![Temperature and humidity tab no data]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_temperaturehumidity_nodata.png)  
![Pressure tab]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_pressure.png)  
![Air quality tab]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_airquality.png)  

## Containerisation
After all I could call it a day, but I didn't know which system or even cloud I was going to use to deploy it. So, there are two answers, either I going to build and test on every system possible or use containerisation. I tend to stick to the second options, due to effiency.
This time I prepared files for [Docker containerisation platform](https://docs.docker.com/get-started/docker-overview/#the-docker-platform) and [Kubernetes for running and managing containers](https://kubernetes.io/docs/concepts/overview/).

### Docker
There are an two docker files. One for the UI and one for the backend. Resource-intensive containers weren't what i wanted, so UI is uses nginx, and backend aspnet:8.0 (it can be changed to alpine). Both dockerfiles are multi-stage - I've created them to prepare environment, build and deploy. A one-click solution to deploy needed, so both files could be run from docker compose.
```yaml
volumes:
    sqlserver_data:
networks:
    homestation:
        driver: bridge

services:
    homestation_db:
        container_name: homestationDb
        image: mcr.microsoft.com/mssql/server:2022-latest
        environment:
            MSSQL_SA_PASSWORD: "<StrongPass>"
            ACCEPT_EULA: "Y"
        ports:
            - "1433:1433"
        networks:
            - homestation
        volumes:
            - sqlserver_data:/var/opt/mssql
        restart: always
        healthcheck:
            test: /opt/mssql-tools18/bin/sqlcmd -S localhost -C -I -U sa -P $$MSSQL_SA_PASSWORD -Q "IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'homestation') BEGIN CREATE DATABASE homestation; END; SELECT 1;" -b -o /dev/null 
            interval: 5s
            timeout: 30s
            retries: 30
            start_period: 5s
    
    homestation_api:
        container_name: homestationApi
        environment:
            ASPNETCORE_HTTP_PORTS: "80"
            Database__ConnectionString: "Data Source=homestationDb,1433;Database=homestation;User Id=sa;Password=<StrongPass>;Encrypt=False;TrustServerCertificate=True"
        build:
            context: ./Web
            dockerfile: Dockerfile
        ports:
            - "1883:1883"
            - "8180:80"
        networks:
            - homestation
        depends_on:
            homestation_db:
                condition: service_started
        restart: always
    
    homestation_web:
        container_name: homestationWeb
        build:
            context: ./Web/web.client
            args:
                - HREF=/homestation/ #If you want to use /homestation/ suffix to address otherwise replace with /
        ports:
            - "8080:80"
            - "8443:443"
        depends_on:
            - homestation_api
        networks:
            - homestation
        restart: always
```  
After a few tweaks the whole solution can be deployed with   `docker compose -f compose.yaml up -d`  

### I want to be elegant - Kubernetes
At this point the project is ready to run on a containerisation platform, but I wanted to go further. So i set up the [k3s kubernetes distribution](https://k3s.io/), and started developing yaml files. After much trial and error, and installing `ingress-nginx` via helm ([yes, on k3s you have to disable traefik, if you want to use `ingress-nginx` like I do](https://docs.k3s.io/networking/networking-services#traefik-ingress-controller)), I've got it working on my kubernetes instance.
So let's dive in:
 - Created logal image registry
 - Uploaded image into registry 
 - Created namespace - `kubectl create namespace homestation`
 - Added secrets: 
    ```yaml
    #secrets have to be in base64
    apiVersion: v1
    kind: Secret
    metadata:
    name: homestation-secrets
    namespace: homestation
    data:
    #Data Source=homestationDb,1433;Database=homestation;User Id=sa;Password=<StrongPass>;Encrypt=False;TrustServerCertificate=True
    ConnectionString: 
    RGF0YSBTb3VyY2U9aG9tZXN0YXRpb25EYiwxNDMzO0RhdGFiYXNlPWhvbWVzdGF0aW9uO1VzZXIgSWQ9c2E7UGFzc3dvcmQ9PEF3ZXNvbWVQYXNzd29yZD47RW5jcnlwdD1GYWxzZTtUcnVzdFNlcnZlckNlcnRpZmljYXRlPVRydWU=
    # P@StrongPass
    DbPassword: U3Ryb25nUGFzcw==
    ```
 - Deployed database server:
    ```yaml
    apiVersion: v1
    kind: PersistentVolume
    metadata:
    name: sqlserver-data
    namespace: homestation
    spec:
    accessModes:
        - ReadWriteOnce
    capacity:
        storage: 5Gi
    hostPath:
        path: "/var/opt/mssql"
    ---
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
    name: sqlserver-claim
    namespace: homestation
    spec:
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
        storage: 5Gi
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    annotations:
        kompose.cmd: kompose -f compose.yaml convert
        kompose.version: 1.35.0 (9532ceef3)
    labels:
        app.kubernetes.io/name: homestationdb-deployment
    name: homestationdb-deployment
    namespace: homestation
    spec:
    replicas: 1
    selector:
        matchLabels:
        app.kubernetes.io/name: homestationdb
    strategy:
        type: Recreate
    template:
        metadata:
        annotations:
            kompose.cmd: kompose -f compose.yaml convert
            kompose.version: 1.35.0 (9532ceef3)
        labels:
            app.kubernetes.io/name: homestationdb
        spec:
        containers:
            - name: homestationdb
            image: mcr.microsoft.com/mssql/rhel/server:2022-latest
            ports:
                - name: "1433port" #Customize SQL Server port
                containerPort: 1433
                - name: "1434port" #Customize SQL Server port
                containerPort: 1434
            env:
                - name: ACCEPT_EULA
                value: "Y"
                - name: MSSQL_DATA_DIR
                value: /var/opt/mssql/data
                - name: MSSQL_SA_PASSWORD #SA_PASSWORD is deprecated - https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver16&tabs=cli&pivots=cs1-bash#run-the-container-2
                valueFrom:
                    secretKeyRef:
                    key: DbPassword
                    name: homestation-secrets #Specify other secret if needed, or remove everything under valueFrom: and replace with `value: "<your password>"`
            volumeMounts:
                - name: sqlserver-data
                mountPath: "/var/opt/mssql"
        volumes:
            - name: sqlserver-data
            persistentVolumeClaim:
                claimName: sqlserver-claim
        restartPolicy: Always
    ---
    apiVersion: v1
    kind: Service
    metadata:
    annotations:
        kompose.cmd: kompose -f compose.yaml convert
        kompose.version: 1.35.0 (9532ceef3)
    labels:
        app.kubernetes.io/name: homestationdb
    name: homestationdb
    namespace: homestation
    spec:
    ports:
        - name: "1433port" #Customize SQL Server port
        port: 1433 #Used for communication between pods, ingresses etc.
        targetPort: 1433 #Same as container port
        protocol: TCP
        - name: "1434port" #Customize SQL Server port
        port: 1434 #Used for communication between pods, ingresses etc.
        targetPort: 1434 #Same as container port
        protocol: UDP
    selector:
        app.kubernetes.io/name: homestationdb
    ```
 - Created database:
    ```yaml
    apiVersion: batch/v1 #This job should be run after the database is up
    kind: Job
    metadata:
    name: homestationdb-prepare
    namespace: homestation
    spec:
    template:
        spec:
        containers:
            - name: homestationdb-prepare
            image: mcr.microsoft.com/mssql-tools
            command: ["/opt/mssql-tools/bin/sqlcmd"]
            env:
                - name: DbPassword
                valueFrom:
                    secretKeyRef:
                    key: DbPassword
                    name: homestation-secrets #Specify secret name or replace with `value: "<your password>"`, after removing valueFrom:
            args: [ "-S", "homestationDb", "-U", "sa", "-P", "$(DbPassword)", "-C", "-I", "-Q", "IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'homestation') BEGIN CREATE DATABASE homestation; END;" ]
        restartPolicy: Never
    backoffLimit: 4
    ```
  - Deployed backend:
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    annotations:
        kompose.cmd: kompose -f compose.yaml convert
        kompose.version: 1.35.0 (9532ceef3)
    name: homestationapi-deployment
    namespace: homestation
    spec:
    replicas: 1
    selector:
        matchLabels:
        app.kubernetes.io/name: homestationapi
    template:
        metadata:
        labels:
            app.kubernetes.io/name: homestationapi
        spec:
        containers:
            - env:
                - name: MQTT__Port
                value: "1883" #Pod Internal MQTT Port
                - name: MQTT__Address
                value: "0.0.0.0" #Listen on all
                - name: ASPNETCORE_HTTP_PORTS
                value: "80" #Pod internal HTTP port
                - name: Database__ConnectionString
                valueFrom:
                    secretKeyRef:
                    key: ConnectionString
                    name: homestation-secrets
            image: 127.0.0.1:5000/homestation2-homestation_api:latest #specify image registry
            name: homestationapi
            ports:
                - containerPort: 1883 #Customize MQTT port
                protocol: TCP
                - containerPort: 8180 #Customize HTTP port
                protocol: TCP
        restartPolicy: Always
    ---
    apiVersion: v1
    kind: Service
    metadata:
    labels:
        app.kubernetes.io/name: homestationapi
    name: homestationapi
    namespace: homestation
    spec:
    ports:
        - name: "1883" #Customize MQTT port
        port: 1883 #Service port to communication, should be the same in a ingress
        protocol: TCP
        targetPort: 1883 #Container port should be the same as target port
        - name: "80" #Customize HTTP port, rules same as above
        port: 8180
        protocol: TCP
        targetPort: 80
    selector:
        app.kubernetes.io/name: homestationapi
    ---
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
    name: homestationapiingress
    namespace: homestation
    annotations:
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/rewrite-target: /api/$1
    spec:
    rules:
        - http:
            paths:
            - path: /api/(.*)
                backend:
                service:
                    name: homestationapi
                    port:
                    number: 8180 #HTTP port
                pathType: ImplementationSpecific
    ingressClassName: nginx
    ```
 - Deployed Frontend:
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    namespace: homestation
    annotations:
        kompose.cmd: kompose -f compose.yaml convert
        kompose.version: 1.35.0 (9532ceef3)
    name: homestationweb-deployment
    spec:
    replicas: 1
    selector:
        matchLabels:
        app.kubernetes.io/name: homestationweb
    template:
        metadata:
        annotations:
            kompose.cmd: kompose -f compose.yaml convert
            kompose.version: 1.35.0 (9532ceef3)
        labels:
            app.kubernetes.io/name: homestationweb
        spec:
        containers:
            - image: 127.0.0.1:5000/homestation2-homestation_web:latest #specify registry
            name: homestationweb
            env:
                - name: TARGET_URL
                value: "http://homestationApi/homestation/"
            ports:
                - name: "https"
                containerPort: 8443 #Customize HTTPS port - will be deleted in future, ingress configuration uses HTTP
                - name: "http"
                containerPort: 8080 #Customzize HTTP port
        restartPolicy: Always
    ---
    apiVersion: v1
    kind: Service
    metadata:
    namespace: homestation
    annotations:
        kompose.cmd: kompose -f compose.yaml convert
        kompose.version: 1.35.0 (9532ceef3)
    labels:
        io.kompose.service: homestationweb
    name: homestationweb
    spec:
    ports:
        - name: "http" #customize HTTP port
        port: 8080 #Service port to communication, should be the same in a ingress
        protocol: TCP
        targetPort: 80
        - name: "https" #customize HTTPS port
        port: 8443 #Service port to communication, should be the same in a ingress
        protocol: TCP
        targetPort: 443
    selector:
        app.kubernetes.io/name: homestationweb
    ---
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
    name: homestationwebingress
    namespace: homestation
    annotations:
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/rewrite-target: /homestation/
    spec:
    rules:
        - http:
            paths:
            - path: /homestation/
                backend:
                service:
                    name: homestationweb
                    port:
                    number: 8080 #Exposed HTTP port, should be the same as service port
                pathType: Prefix
    ingressClassName: nginx
    ```
  
Then, after executing `kubectl get pods -n homestation` I've received this:
![]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_pods.png)  

## Summary?
Overall, the project expanded the knowledge of IoT devices, how they work and how to build software on microcontrollers.
Notable is kubernetes, which stopped being a 'black-box that works thanks to CI/CD', and started being a container management platform with services, deployments, ingresses etc.
Lastly, 3D printing - finally I have the opportunity to use it in a real project, not only to print useless stuff that wil end up in a drawer for years.
![]({{ site.url }}{{ site.baseurl }}/assets/img/homestation2/homestation2_final.jpg)  

### Mistakes
**BME280 heating**  
You should be aware that this sensor is self-heating to provide accurate humidity and/or pressure readings, so consider setting oversampling to 1X, and using it through force mode. If you can consider different sensor.

**Try to being modular**  
I've tried putting goldpins everywhere *to quickly replace broken parts*, but you have to know that there are many manufacturers of these, and they vary in quality. In particular, it quickly became annoying when the HD44780 display sometimes disconnected.

**No cache**  
If I select about 30 days in the UI with the detailed view and try to download data, I'm going to wait for a while (and even longer if my computer couldn't render all the points). It's good to have a proxy between the UI and the backend.

**.Include().ThenInclude().Include()**  
`SELECT` is so much faster than doing multiple includes. Entity framework translated them to many left joins, and they cause terrible performance.

## Appendices
### HD44780
After some time of use I've disconnected the display, and removed code from repository. Now I'm reading data from the web.
The reason is simple - poor quality of my goldpins, and I want to avoid soldering prototype board again.
There is last working version with display - [click](https://github.com/RobertMut/HomeStation2/tree/662a4fe112310f9eb608351bad2f9f5a8cfbb837)