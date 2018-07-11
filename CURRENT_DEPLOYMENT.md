roman:scripts rholzhause$ source deployAWS.sh
[debug] Created tunnel using local port: '61037'

[debug] SERVER: "127.0.0.1:61037"

[debug] Original chart version: ""
[debug] CHART PATH: /Users/rholzhause/workspace/qmc/core/keycloak/keycloak-ci/k8s

NAME:   keycloak
REVISION: 1
RELEASED: Thu Apr 26 14:13:28 2018
CHART: keycloak-0.2.2
USER-SUPPLIED VALUES:
hyperkube:
  image:
    pullPolicy: IfNotPresent
    repository: quay.io/coreos/hyperkube
    tag: v1.8.1_coreos.0
keycloak:
  additionalEnv: {}
  cli:
    custom: ""
    discovery: |
      /subsystem=infinispan/cache-container=keycloak/distributed-cache=sessions:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})
      /subsystem=infinispan/cache-container=keycloak/distributed-cache=authenticationSessions:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})
      /subsystem=infinispan/cache-container=keycloak/distributed-cache=offlineSessions:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})
      /subsystem=infinispan/cache-container=keycloak/distributed-cache=loginFailures:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})

      /subsystem=jgroups/stack=tcp:remove()
      /subsystem=jgroups/stack=tcp:add()
      /subsystem=jgroups/stack=tcp/transport=TCP:add(socket-binding="jgroups-tcp")
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING:add()
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=datasource_jndi_name:add(value=java:jboss/datasources/KeycloakDS)
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=clear_table_on_view_change:add(value=true)
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=break_on_coord_rsp:add(value=true)

      # Statements must be adapted for PostgreSQL. Additionally, we add a 'creation_timestamp' column.
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=initialize_sql:add(value="CREATE TABLE IF NOT EXISTS JGROUPSPING (own_addr varchar(200) NOT NULL, creation_timestamp timestamp NOT NULL, cluster_name varchar(200) NOT NULL, ping_data bytea, constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))")
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=insert_single_sql:add(value="INSERT INTO JGROUPSPING (own_addr, creation_timestamp, cluster_name, ping_data) values (?, NOW(), ?, ?)")

      /subsystem=jgroups/stack=tcp/protocol=MERGE3:add()
      /subsystem=jgroups/stack=tcp/protocol=FD_SOCK:add(socket-binding="jgroups-tcp-fd")
      /subsystem=jgroups/stack=tcp/protocol=FD:add()
      /subsystem=jgroups/stack=tcp/protocol=VERIFY_SUSPECT:add()
      /subsystem=jgroups/stack=tcp/protocol=pbcast.NAKACK2:add()
      /subsystem=jgroups/stack=tcp/protocol=UNICAST3:add()
      /subsystem=jgroups/stack=tcp/protocol=pbcast.STABLE:add()
      /subsystem=jgroups/stack=tcp/protocol=pbcast.GMS:add()
      /subsystem=jgroups/stack=tcp/protocol=pbcast.GMS/property=max_join_attempts:add(value=5)
      /subsystem=jgroups/stack=tcp/protocol=MFC:add()
      /subsystem=jgroups/stack=tcp/protocol=FRAG2:add()

      /subsystem=jgroups/channel=ee:write-attribute(name=stack, value=tcp)
      /subsystem=jgroups/stack=udp:remove()
      /socket-binding-group=standard-sockets/socket-binding=jgroups-mping:remove()
      /interface=private:write-attribute(name=nic, value=eth0)
      /interface=private:undefine-attribute(name=inet-address)
    logging: |
      # Allow log level to be configured via environment variable
      /subsystem=logging/console-handler=CONSOLE:write-attribute(name=level, value=${env.WILDFLY_LOGLEVEL:INFO})
      /subsystem=logging/root-logger=ROOT:write-attribute(name=level, value=${env.WILDFLY_LOGLEVEL:INFO})

      # Log only to console
      /subsystem=logging/root-logger=ROOT:write-attribute(name=handlers, value=[CONSOLE])
    nodeIdentifier: |
      # Makes node identifier unique getting rid of a warning in the logs
      /subsystem=transactions:write-attribute(name=node-identifier, value=${jboss.node.name})
    reverseProxy: |
      /socket-binding-group=standard-sockets/socket-binding=proxy-https:add(port=443)
      /subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=redirect-socket, value=proxy-https)
      /subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=proxy-address-forwarding, value=true)
  image:
    pullPolicy: IfNotPresent
    repository: jboss/keycloak
    tag: 4.0.0.Beta1
  ingress:
    annotations: {}
    enabled: false
    hosts:
    - auth.hms-dev.cloud
    path: /
    tls:
      enabled: false
      existingSecret: ""
      secretAnnotations: {}
      secretContents: {}
  nodeSelector: {}
  password: 4XWjEi7cfVsHSarTS3KjJjb5
  persistence:
    dbHost: mykeycloak
    dbName: keycloak
    dbPassword: yR&APSD+#xHBxFDmt?+N$2@e
    dbPort: 5432
    dbUser: keycloak
    dbVendor: H2
    deployPostgres: true
    existingSecret: ""
    existingSecretKey: password
  podAntiAffinity: soft
  replicas: 2
  resources:
    limits:
      cpu: "1"
      memory: 1024Mi
    requests:
      cpu: 500m
      memory: 512Mi
  service:
    annotations:
      getambassador.io/config: |
        ---
        apiVersion: ambassador/v0
        kind:  Mapping
        name:  keycloak_base_mapping
        prefix: /
        rewrite: /
        service: keycloak-keycloak-http
    labels: {}
    port: 80
    type: LoadBalancer
  tolerations: []
  username: hms-admin
postgresql:
  persistence:
    enabled: true
  postgresDatabase: keycloak
  postgresPassword: MG9uwyp3T8f^bVM?q#zQfJHC
  postgresUser: keycloak
rbac:
  create: true
serviceAccount:
  create: true
  name: ""
test:
  image:
    pullPolicy: IfNotPresent
    repository: unguiculus/docker-python3-phantomjs-selenium
    tag: v1

COMPUTED VALUES:
hyperkube:
  image:
    pullPolicy: IfNotPresent
    repository: quay.io/coreos/hyperkube
    tag: v1.8.1_coreos.0
keycloak:
  additionalEnv: {}
  cli:
    custom: ""
    discovery: |
      /subsystem=infinispan/cache-container=keycloak/distributed-cache=sessions:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})
      /subsystem=infinispan/cache-container=keycloak/distributed-cache=authenticationSessions:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})
      /subsystem=infinispan/cache-container=keycloak/distributed-cache=offlineSessions:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})
      /subsystem=infinispan/cache-container=keycloak/distributed-cache=loginFailures:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})

      /subsystem=jgroups/stack=tcp:remove()
      /subsystem=jgroups/stack=tcp:add()
      /subsystem=jgroups/stack=tcp/transport=TCP:add(socket-binding="jgroups-tcp")
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING:add()
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=datasource_jndi_name:add(value=java:jboss/datasources/KeycloakDS)
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=clear_table_on_view_change:add(value=true)
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=break_on_coord_rsp:add(value=true)

      # Statements must be adapted for PostgreSQL. Additionally, we add a 'creation_timestamp' column.
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=initialize_sql:add(value="CREATE TABLE IF NOT EXISTS JGROUPSPING (own_addr varchar(200) NOT NULL, creation_timestamp timestamp NOT NULL, cluster_name varchar(200) NOT NULL, ping_data bytea, constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))")
      /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=insert_single_sql:add(value="INSERT INTO JGROUPSPING (own_addr, creation_timestamp, cluster_name, ping_data) values (?, NOW(), ?, ?)")

      /subsystem=jgroups/stack=tcp/protocol=MERGE3:add()
      /subsystem=jgroups/stack=tcp/protocol=FD_SOCK:add(socket-binding="jgroups-tcp-fd")
      /subsystem=jgroups/stack=tcp/protocol=FD:add()
      /subsystem=jgroups/stack=tcp/protocol=VERIFY_SUSPECT:add()
      /subsystem=jgroups/stack=tcp/protocol=pbcast.NAKACK2:add()
      /subsystem=jgroups/stack=tcp/protocol=UNICAST3:add()
      /subsystem=jgroups/stack=tcp/protocol=pbcast.STABLE:add()
      /subsystem=jgroups/stack=tcp/protocol=pbcast.GMS:add()
      /subsystem=jgroups/stack=tcp/protocol=pbcast.GMS/property=max_join_attempts:add(value=5)
      /subsystem=jgroups/stack=tcp/protocol=MFC:add()
      /subsystem=jgroups/stack=tcp/protocol=FRAG2:add()

      /subsystem=jgroups/channel=ee:write-attribute(name=stack, value=tcp)
      /subsystem=jgroups/stack=udp:remove()
      /socket-binding-group=standard-sockets/socket-binding=jgroups-mping:remove()
      /interface=private:write-attribute(name=nic, value=eth0)
      /interface=private:undefine-attribute(name=inet-address)
    logging: |
      # Allow log level to be configured via environment variable
      /subsystem=logging/console-handler=CONSOLE:write-attribute(name=level, value=${env.WILDFLY_LOGLEVEL:INFO})
      /subsystem=logging/root-logger=ROOT:write-attribute(name=level, value=${env.WILDFLY_LOGLEVEL:INFO})

      # Log only to console
      /subsystem=logging/root-logger=ROOT:write-attribute(name=handlers, value=[CONSOLE])
    nodeIdentifier: |
      # Makes node identifier unique getting rid of a warning in the logs
      /subsystem=transactions:write-attribute(name=node-identifier, value=${jboss.node.name})
    reverseProxy: |
      /socket-binding-group=standard-sockets/socket-binding=proxy-https:add(port=443)
      /subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=redirect-socket, value=proxy-https)
      /subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=proxy-address-forwarding, value=true)
  image:
    pullPolicy: IfNotPresent
    repository: jboss/keycloak
    tag: 4.0.0.Beta1
  ingress:
    annotations: {}
    enabled: false
    hosts:
    - auth.hms-dev.cloud
    path: /
    tls:
      enabled: false
      existingSecret: ""
      secretAnnotations: {}
      secretContents: {}
  nodeSelector: {}
  password: 4XWjEi7cfVsHSarTS3KjJjb5
  persistence:
    dbHost: mykeycloak
    dbName: keycloak
    dbPassword: yR&APSD+#xHBxFDmt?+N$2@e
    dbPort: 5432
    dbUser: keycloak
    dbVendor: H2
    deployPostgres: true
    existingSecret: ""
    existingSecretKey: password
  podAntiAffinity: soft
  replicas: 2
  resources:
    limits:
      cpu: "1"
      memory: 1024Mi
    requests:
      cpu: 500m
      memory: 512Mi
  service:
    annotations:
      getambassador.io/config: |
        ---
        apiVersion: ambassador/v0
        kind:  Mapping
        name:  keycloak_base_mapping
        prefix: /
        rewrite: /
        service: keycloak-keycloak-http
    labels: {}
    port: 80
    type: LoadBalancer
  tolerations: []
  username: hms-admin
postgresql:
  affinity: {}
  global: {}
  image: postgres
  imageTag: 9.6.2
  metrics:
    enabled: false
    image: wrouesnel/postgres_exporter
    imagePullPolicy: IfNotPresent
    imageTag: v0.1.1
    resources:
      requests:
        cpu: 100m
        memory: 256Mi
  networkPolicy:
    allowExternal: true
    enabled: false
  nodeSelector: {}
  persistence:
    accessMode: ReadWriteOnce
    enabled: true
    mountPath: /var/lib/postgresql/data/pgdata
    size: 4Gi
    storageClass: ci-storage
    subPath: postgresql-db
  postgresDatabase: keycloak
  postgresPassword: MG9uwyp3T8f^bVM?q#zQfJHC
  postgresUser: keycloak
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
  service:
    externalIPs: []
    port: 5432
    type: ClusterIP
  tolerations: []
rbac:
  create: true
serviceAccount:
  create: true
  name: ""
test:
  image:
    pullPolicy: IfNotPresent
    repository: unguiculus/docker-python3-phantomjs-selenium
    tag: v1

HOOKS:
---
# keycloak-keycloak-test
apiVersion: v1
kind: Pod
metadata:
  name: keycloak-keycloak-test
  labels:
    app: keycloak
    chart: "keycloak-0.2.2"
    release: "keycloak"
    heritage: "Tiller"
  annotations:
    "helm.sh/hook": test-success
spec:
  containers:
    - name: keycloak-test
      image: "unguiculus/docker-python3-phantomjs-selenium:v1"
      imagePullPolicy: IfNotPresent
      command:
        - python3
        - /tests/test.py
      env:
        - name: KEYCLOAK_USER
          value: hms-admin
        - name: KEYCLOAK_PASSWORD
          valueFrom:
            secretKeyRef:
              name: keycloak-keycloak-http
              key: password
      volumeMounts:
        - name: tests
          mountPath: /tests
  volumes:
    - name: tests
      configMap:
        name: keycloak-keycloak-test
  restartPolicy: Never
MANIFEST:

---
# Source: keycloak/charts/postgresql/templates/secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: keycloak-postgresql
  labels:
    app: keycloak-postgresql
    chart: "postgresql-0.9.3"
    release: "keycloak"
    heritage: "Tiller"
type: Opaque
data:

  postgres-password:  "TUc5dXd5cDNUOGZeYlZNP3EjelFmSkhD"
---
# Source: keycloak/templates/keycloak-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: keycloak-keycloak-http
  labels:
    app: keycloak
    chart: "keycloak-0.2.2"
    release: "keycloak"
    heritage: "Tiller"
type: Opaque
data:
  password: "NFhXakVpN2NmVnNIU2FyVFMzS2pKamI1"
---
# Source: keycloak/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: keycloak-keycloak
  labels:
    app: keycloak
    chart: "keycloak-0.2.2"
    release: "keycloak"
    heritage: "Tiller"
data:
  wait_for_postgresql.sh: |
    #!/usr/bin/env bash

    set -eu

    pod_labels="${1?Please specify PostgreSQL labels}"
    max_retries=30
    retry_count=0
    sleep_secs=2
    ready_pods=

    echo 'Polling for PostgreSQL readiness...'

    while [ -z "$ready_pods" ] && [ "$retry_count" -lt "$max_retries" ]; do
        ready_pods=$(kubectl get pods -l "$pod_labels" -o jsonpath="{.items[*].status.containerStatuses[?(@.ready==true)].name}")
        retry_count=$((retry_count + 1))
        sleep "$sleep_secs"
    done

    if [ -z "$ready_pods" ]; then
        echo "ERROR: Timeout waiting for PostgreSQL to start up." >&2
        exit 1
    fi

    echo "PostgreSQL ready!"

  keycloak.sh: |
    #!/usr/bin/env bash

    set -eu

    /opt/jboss/keycloak/bin/jboss-cli.sh --file=/scripts/keycloak.cli

    args=(-b 0.0.0.0 --server-config standalone-ha.xml)

    exec /opt/jboss/docker-entrypoint.sh "${args[@]}"
    exit "$?"

  keycloak.cli: |
    embed-server --server-config=standalone-ha.xml --std-out=echo

    # Makes node identifier unique getting rid of a warning in the logs
    /subsystem=transactions:write-attribute(name=node-identifier, value=${jboss.node.name})


    # Allow log level to be configured via environment variable
    /subsystem=logging/console-handler=CONSOLE:write-attribute(name=level, value=${env.WILDFLY_LOGLEVEL:INFO})
    /subsystem=logging/root-logger=ROOT:write-attribute(name=level, value=${env.WILDFLY_LOGLEVEL:INFO})

    # Log only to console
    /subsystem=logging/root-logger=ROOT:write-attribute(name=handlers, value=[CONSOLE])


    /socket-binding-group=standard-sockets/socket-binding=proxy-https:add(port=443)
    /subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=redirect-socket, value=proxy-https)
    /subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=proxy-address-forwarding, value=true)

    /subsystem=infinispan/cache-container=keycloak/distributed-cache=sessions:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})
    /subsystem=infinispan/cache-container=keycloak/distributed-cache=authenticationSessions:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})
    /subsystem=infinispan/cache-container=keycloak/distributed-cache=offlineSessions:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})
    /subsystem=infinispan/cache-container=keycloak/distributed-cache=loginFailures:write-attribute(name=owners, value=${env.CACHE_OWNERS:2})

    /subsystem=jgroups/stack=tcp:remove()
    /subsystem=jgroups/stack=tcp:add()
    /subsystem=jgroups/stack=tcp/transport=TCP:add(socket-binding="jgroups-tcp")
    /subsystem=jgroups/stack=tcp/protocol=JDBC_PING:add()
    /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=datasource_jndi_name:add(value=java:jboss/datasources/KeycloakDS)
    /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=clear_table_on_view_change:add(value=true)
    /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=break_on_coord_rsp:add(value=true)

    # Statements must be adapted for PostgreSQL. Additionally, we add a 'creation_timestamp' column.
    /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=initialize_sql:add(value="CREATE TABLE IF NOT EXISTS JGROUPSPING (own_addr varchar(200) NOT NULL, creation_timestamp timestamp NOT NULL, cluster_name varchar(200) NOT NULL, ping_data bytea, constraint PK_JGROUPSPING PRIMARY KEY (own_addr, cluster_name))")
    /subsystem=jgroups/stack=tcp/protocol=JDBC_PING/property=insert_single_sql:add(value="INSERT INTO JGROUPSPING (own_addr, creation_timestamp, cluster_name, ping_data) values (?, NOW(), ?, ?)")

    /subsystem=jgroups/stack=tcp/protocol=MERGE3:add()
    /subsystem=jgroups/stack=tcp/protocol=FD_SOCK:add(socket-binding="jgroups-tcp-fd")
    /subsystem=jgroups/stack=tcp/protocol=FD:add()
    /subsystem=jgroups/stack=tcp/protocol=VERIFY_SUSPECT:add()
    /subsystem=jgroups/stack=tcp/protocol=pbcast.NAKACK2:add()
    /subsystem=jgroups/stack=tcp/protocol=UNICAST3:add()
    /subsystem=jgroups/stack=tcp/protocol=pbcast.STABLE:add()
    /subsystem=jgroups/stack=tcp/protocol=pbcast.GMS:add()
    /subsystem=jgroups/stack=tcp/protocol=pbcast.GMS/property=max_join_attempts:add(value=5)
    /subsystem=jgroups/stack=tcp/protocol=MFC:add()
    /subsystem=jgroups/stack=tcp/protocol=FRAG2:add()

    /subsystem=jgroups/channel=ee:write-attribute(name=stack, value=tcp)
    /subsystem=jgroups/stack=udp:remove()
    /socket-binding-group=standard-sockets/socket-binding=jgroups-mping:remove()
    /interface=private:write-attribute(name=nic, value=eth0)
    /interface=private:undefine-attribute(name=inet-address)


    stop-embedded-server
---
# Source: keycloak/templates/test/test-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: keycloak-keycloak-test
  labels:
    app: keycloak
    chart: "keycloak-0.2.2"
    release: "keycloak"
    heritage: "Tiller"
data:
  test.py: |
    import os
    from selenium import webdriver
    from urllib.parse import urlparse

    print('Creating PhantomJS river...')
    driver = webdriver.PhantomJS()

    base_url = 'http://keycloak-keycloak-http'

    print('Opening Keycloak...')
    driver.get('{0}/auth/admin/'.format(base_url))

    username = os.environ['KEYCLOAK_USER']
    password = os.environ['KEYCLOAK_PASSWORD']

    print('Entering username...')
    driver.find_element_by_id('username').send_keys(username)

    print('Entering password...')
    driver.find_element_by_id('password').send_keys(password)

    print('Clicking login button...')
    driver.find_element_by_id('kc-login').click()

    current_url = urlparse(driver.current_url)
    expected_url = urlparse('{0}/auth/admin/master/console/'.format(base_url))

    print('Current URL: {0}'.format(current_url))
    print('Expected URL: {0}'.format(expected_url))

    if current_url.path != expected_url.path:
      print('Login failed. Current url is not expected url')
      exit(1)

    print('URLs match. Login successful.')

    driver.quit()
---
# Source: keycloak/charts/postgresql/templates/pvc.yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: keycloak-postgresql
  labels:
    app: keycloak-postgresql
    chart: "postgresql-0.9.3"
    release: "keycloak"
    heritage: "Tiller"
spec:
  accessModes:
    - "ReadWriteOnce"
  resources:
    requests:
      storage: "4Gi"
  storageClassName: "ci-storage"
---
# Source: keycloak/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: keycloak-keycloak
  labels:
    app: keycloak-keycloak
    chart: keycloak-0.2.2
    heritage: Tiller
    release: keycloak
---
# Source: keycloak/templates/rbac.yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: Role
metadata:
  name: keycloak-keycloak
  labels:
    app: keycloak-keycloak
    chart: keycloak-0.2.2
    heritage: Tiller
    release: keycloak
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list"]
---
# Source: keycloak/templates/rbac.yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: RoleBinding
metadata:
  name: keycloak-keycloak
  labels:
    app: keycloak-keycloak
    chart: keycloak-0.2.2
    heritage: Tiller
    release: keycloak
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: keycloak-keycloak
subjects:
- kind: ServiceAccount
  name: keycloak-keycloak
---
# Source: keycloak/charts/postgresql/templates/svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: keycloak-postgresql
  labels:
    app: keycloak-postgresql
    chart: "postgresql-0.9.3"
    release: "keycloak"
    heritage: "Tiller"
spec:
  type: ClusterIP
  ports:
  - name: postgresql
    port: 5432
    targetPort: postgresql
  selector:
    app: keycloak-postgresql
---
# Source: keycloak/templates/headless-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: keycloak-keycloak-headless
  labels:
    app: keycloak
    chart: "keycloak-0.2.2"
    release: "keycloak"
    heritage: "Tiller"
spec:
  type: ClusterIP
  clusterIP: None
  ports:
    - name: http
      port: 80
      targetPort: http
      protocol: TCP
  selector:
    app: keycloak
    release: "keycloak"
---
# Source: keycloak/templates/http-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: keycloak-keycloak-http
  annotations:
    getambassador.io/config: |
      ---
      apiVersion: ambassador/v0
      kind:  Mapping
      name:  keycloak_base_mapping
      prefix: /
      rewrite: /
      service: keycloak-keycloak-http

  labels:
    app: keycloak
    chart: "keycloak-0.2.2"
    release: "keycloak"
    heritage: "Tiller"
spec:
  type: LoadBalancer
  ports:
    - name: http
      port: 80
      targetPort: http
      protocol: TCP
  selector:
    app: keycloak
    release: "keycloak"
---
# Source: keycloak/charts/postgresql/templates/deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: keycloak-postgresql
  labels:
    app: keycloak-postgresql
    chart: "postgresql-0.9.3"
    release: "keycloak"
    heritage: "Tiller"
spec:
  template:
    metadata:
      labels:
        app: keycloak-postgresql
    spec:
      containers:
      - name: keycloak-postgresql
        image: "postgres:9.6.2"
        imagePullPolicy: ""
        args:
        env:
        - name: POSTGRES_USER
          value: "keycloak"
          # Required for pg_isready in the health probes.
        - name: PGUSER
          value: "keycloak"
        - name: POSTGRES_DB
          value: "keycloak"
        - name: POSTGRES_INITDB_ARGS
          value: ""
        - name: PGDATA
          value: /var/lib/postgresql/data/pgdata
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: keycloak-postgresql
              key: postgres-password
        - name: POD_IP
          valueFrom: { fieldRef: { fieldPath: status.podIP } }
        ports:
        - name: postgresql
          containerPort: 5432
        livenessProbe:
          exec:
            command:
            - sh
            - -c
            - exec pg_isready --host $POD_IP
          initialDelaySeconds: 120
          timeoutSeconds: 5
          failureThreshold: 6
        readinessProbe:
          exec:
            command:
            - sh
            - -c
            - exec pg_isready --host $POD_IP
          initialDelaySeconds: 5
          timeoutSeconds: 3
          periodSeconds: 5
        resources:
          requests:
            cpu: 100m
            memory: 256Mi

        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data/pgdata
          subPath: postgresql-db
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: keycloak-postgresql
---
# Source: keycloak/templates/statefulset.yaml
apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: keycloak-keycloak
  annotations:
    checksum/config: 3f3fbae8db3332dac34d685fffb08a9c09c13eae55730398c7d4be3d69e5a7ef
  labels:
    app: keycloak
    chart: "keycloak-0.2.2"
    release: "keycloak"
    heritage: "Tiller"
spec:
  replicas: 2
  serviceName: keycloak-keycloak-headless
  podManagementPolicy: Parallel
  updateStrategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: keycloak
        release: "keycloak"
    spec:
      serviceAccountName: keycloak-keycloak
      initContainers:
        - name: wait-for-postgresql
          image: "quay.io/coreos/hyperkube:v1.8.1_coreos.0"
          imagePullPolicy: "IfNotPresent"
          command:
            - "bash"
            - "-c"
            - "/scripts/wait_for_postgresql.sh app=keycloak-postgresql"
          volumeMounts:
            - name: scripts
              mountPath: /scripts
      containers:
        - name: keycloak
          image: "jboss/keycloak:4.0.0.Beta1"
          imagePullPolicy: IfNotPresent
          command:
            - /scripts/keycloak.sh
          env:
            - name: KEYCLOAK_USER
              value: hms-admin
            - name: KEYCLOAK_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: keycloak-keycloak-http
                  key: password
            - name: POSTGRES_PORT_5432_TCP_ADDR
              value: keycloak-postgresql
            - name: POSTGRES_USER
              value: "keycloak"
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: keycloak-postgresql
                  key: postgres-password
            - name: POSTGRES_DATABASE
              value: "keycloak"
#additionalEnv
          volumeMounts:
            - name: scripts
              mountPath: /scripts
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /auth/
              port: http
            initialDelaySeconds: 120
            timeoutSeconds: 5
          readinessProbe:
            httpGet:
              path: /auth/
              port: http
            initialDelaySeconds: 12
            timeoutSeconds: 2
          resources:
            limits:
              cpu: "1"
              memory: 1024Mi
            requests:
              cpu: 500m
              memory: 512Mi

      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 1
              podAffinityTerm:
                topologyKey: kubernetes.io/hostname
                labelSelector:
                  matchLabels:
                    app: "keycloak-keycloak"
                    release: "keycloak"
      terminationGracePeriodSeconds: 60
      volumes:
        - name: scripts
          configMap:
            name: keycloak-keycloak
            defaultMode: 0755
LAST DEPLOYED: Thu Apr 26 14:13:28 2018
NAMESPACE: core
STATUS: DEPLOYED

RESOURCES:
==> v1/PersistentVolumeClaim
NAME                 STATUS  VOLUME                                    CAPACITY  ACCESS MODES  STORAGECLASS  AGE
keycloak-postgresql  Bound   pvc-3a8fb8c5-494b-11e8-9e75-02d1c7aaaf8e  4Gi       RWO           ci-storage    2s

==> v1/ServiceAccount
NAME               SECRETS  AGE
keycloak-keycloak  1        2s

==> v1beta1/Role
NAME               AGE
keycloak-keycloak  2s

==> v1beta1/StatefulSet
NAME               DESIRED  CURRENT  AGE
keycloak-keycloak  2        2        2s

==> v1/Pod(related)
NAME                                  READY  STATUS             RESTARTS  AGE
keycloak-postgresql-55c8df9745-v2fck  0/1    ContainerCreating  0         1s
keycloak-keycloak-0                   0/1    Init:0/1           0         1s
keycloak-keycloak-1                   0/1    Init:0/1           0         1s

==> v1/Secret
NAME                    TYPE    DATA  AGE
keycloak-postgresql     Opaque  1     2s
keycloak-keycloak-http  Opaque  1     2s

==> v1/ConfigMap
NAME                    DATA  AGE
keycloak-keycloak       3     2s
keycloak-keycloak-test  1     2s

==> v1beta1/RoleBinding
NAME               AGE
keycloak-keycloak  2s

==> v1/Service
NAME                        TYPE          CLUSTER-IP      EXTERNAL-IP  PORT(S)       AGE
keycloak-postgresql         ClusterIP     10.100.200.107  <none>       5432/TCP      2s
keycloak-keycloak-headless  ClusterIP     None            <none>       80/TCP        2s
keycloak-keycloak-http      LoadBalancer  10.100.200.86   <pending>    80:30909/TCP  2s

==> v1beta1/Deployment
NAME                 DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
keycloak-postgresql  1        1        1           0          2s


NOTES:

1. Keycloak can be accessed:

   * Within your cluster, at the following DNS name at port 80:

     keycloak-keycloak.core.svc.cluster.local

   * From outside the cluster, run these commands in the same shell:

      NOTE: It may take a few minutes for the LoadBalancer IP to be available.
            You can watch the status of by running 'kubectl get svc -w keycloak-keycloak'

     export SERVICE_IP=$(kubectl get svc --namespace core keycloak-keycloak -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
     echo http://$SERVICE_IP:80

2. Login with the following credentials:

   Username: hms-admin

   To retrieve the initial user password run:
   kubectl get secret --namespace core keycloak-keycloak-http -o jsonpath="{.data.password}" | base64 --decode; echo
