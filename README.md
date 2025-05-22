# PSB1 Helm Base Chart

A comprehensive base Helm chart for deploying applications to EKS.

## Overview

This chart is designed to be used as a library chart for deploying multiple containers in a Kubernetes cluster. It provides a standardized way to deploy applications with consistent configuration while allowing flexibility for individual container settings.

## Features

- Deploy multiple containers from a single values.yaml file
- Each container can individually manage:
  - Deployments
  - Services
  - Ingress resources (standard K8s Ingress or Traefik IngressRoute)
  - Multiple ConfigMaps
  - Secrets
  - Persistent Volume Claims
  - HPA and KEDA-based autoscaling
  - ServiceMonitors for Prometheus
  - Network Policies
- Global settings that can be overridden at the container level
- Support for init containers and sidecars
- AWS Secrets Store CSI Driver integration for secure secrets management
- Consistent labeling and resource management
- Custom manifest injection via extraDeploy templates

## Usage

### As a Dependency

Add this chart as a dependency in your application's Chart.yaml:

```yaml
dependencies:
  - name: psb1-helm-base-chart
    version: 0.1.0
    repository: <your-repo-url>
```

### Sample values.yaml

```yaml
global:
  namespace: my-app-namespace
  labels:
    environment: production
  serviceAccount:
    create: true
    annotations:
      eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/my-role

containers:
  api:
    enabled: true
    deployment:
      replicas: 2
    container:
      image:
        repository: my-api-image
        tag: latest
      resources:
        requests:
          cpu: 200m
          memory: 256Mi
    service:
      enabled: true
      type: ClusterIP
      ports:
        - port: 80
          targetPort: http
    ingress:
      enabled: true
      hosts:
        - host: api.example.com
          paths:
            - path: /
              pathType: Prefix
              backend:
                port: 80

  worker:
    enabled: true
    deployment:
      replicas: 3
    container:
      image:
        repository: my-worker-image
        tag: latest
      resources:
        requests:
          cpu: 500m
          memory: 512Mi
    keda:
      enabled: true
      minReplicaCount: 1
      maxReplicaCount: 10
      triggers:
        - type: aws-sqs-queue
          metadata:
            queueURL: https://sqs.us-east-1.amazonaws.com/123456789012/my-queue
            queueLength: "5"
            awsRegion: us-east-1
```

### Application Templates

In your application's templates directory, include the necessary resources by using the provided template functions:

```yaml
{{- range $containerName, $containerValues := .Values.containers }}
{{- if $containerValues.enabled }}
{{ include "psb1-helm-base-chart.deployment" (list $ $containerName) }}
{{ include "psb1-helm-base-chart.service" (list $ $containerName) }}
{{ include "psb1-helm-base-chart.ingress" (list $ $containerName) }}
{{ include "psb1-helm-base-chart.configmap" (list $ $containerName) }}
{{ include "psb1-helm-base-chart.secret" (list $ $containerName) }}
{{ include "psb1-helm-base-chart.pvc" (list $ $containerName) }}
{{ include "psb1-helm-base-chart.serviceaccount" (list $ $containerName) }}
{{ include "psb1-helm-base-chart.hpa" (list $ $containerName) }}
{{ include "psb1-helm-base-chart.kedascaledobject" (list $ $containerName) }}
{{ include "psb1-helm-base-chart.pdb" (list $ $containerName) }}
{{ include "psb1-helm-base-chart.networkpolicy" (list $ $containerName) }}
{{ include "psb1-helm-base-chart.servicemonitor" (list $ $containerName) }}
{{- end }}
{{- end }}
```

## Values Reference

### Global Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| global.namespace | Namespace for all resources | "default" |
| global.labels | Common labels for all resources | {} |
| global.annotations | Common annotations for all resources | {} |
| global.clusterName | Used for affinity/anti-affinity | "eks-cluster" |
| global.region | AWS region | "us-east-1" |
| global.nodeSelector | Default node selector | {} |
| global.tolerations | Default tolerations | [] |
| global.affinity | Default affinity rules | {} |
| global.securityContext | Default security context | {} |
| global.imagePullSecrets | Default image pull secrets | [] |
| global.serviceAccount.create | Whether to create service accounts | true |
| global.serviceAccount.annotations | Annotations for service accounts | {} |
| global.pdb.enabled | Enable pod disruption budget | false |
| global.pdb.minAvailable | Minimum available pods | 1 |
| global.pdb.maxUnavailable | Maximum unavailable pods | null |

### Container Settings

Each container in the `containers` map can have the following settings:

| Parameter | Description | Default |
|-----------|-------------|---------|
| enabled | Enable this container | true |
| deployment.replicas | Number of replicas | 1 |
| deployment.strategy | Deployment strategy | RollingUpdate |
| deployment.revisionHistoryLimit | Revision history limit | 10 |
| deployment.annotations | Deployment annotations | {} |
| deployment.labels | Deployment labels | {} |
| deployment.podAnnotations | Pod annotations | {} |
| deployment.podLabels | Pod labels | {} |
| deployment.terminationGracePeriodSeconds | Termination grace period | 30 |
| deployment.nodeSelector | Node selector (overrides global) | {} |
| deployment.tolerations | Tolerations (overrides global) | [] |
| deployment.affinity | Affinity rules (overrides global) | {} |
| deployment.securityContext | Pod security context (overrides global) | {} |
| deployment.imagePullSecrets | Image pull secrets (overrides global) | [] |
See values.yaml for a complete list of available settings.

## Custom Resources with extraDeploy

You can add custom Kubernetes manifests using the `extraDeploy` parameter:

```yaml
extraDeploy:
  - apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: pod-reader
    rules:
      - apiGroups: [""]
        resources: ["pods"]
        verbs: ["get", "watch", "list"]

  - apiVersion: batch/v1
    kind: CronJob
    metadata:
      name: api-cleanup
      namespace: {{ .Values.global.namespace | default "default" }}
    spec:
      schedule: "0 0 * * *"
      jobTemplate:
        spec:
          template:
            spec:
              containers:
                - name: cleanup
                  image: my-api-image:latest
                  args: ["cleanup"]
              restartPolicy: OnFailure
```

See examples/values-with-extra-deploy.yaml for more examples.

## Multiple ConfigMaps

The chart supports defining multiple ConfigMaps for a single container:

```yaml
containers:
  api:
    # Volume mounts for the configmaps
    container:
      volumeMounts:
        - name: api-config-config
          mountPath: /app/config
          readOnly: true
        - name: api-logging-config
          mountPath: /app/logging
          readOnly: true
    
    # Multiple ConfigMaps for the same container
    configMaps:
      # Main application config
      config:
        enabled: true
        data:
          application.properties: |
            app.name=My API
            app.version=1.0.0
          config.json: |
            {
              "features": {
                "featureA": true
              }
            }
      
      # Logging configuration
      logging:
        enabled: true
        data:
          logback.xml: |
            <configuration>
              <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
                <encoder>
                  <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
                </encoder>
              </appender>
            </configuration>
```

See examples/values-multiple-configmaps.yaml for a complete example.

## Traefik IngressRoute

The chart supports Traefik v3 IngressRoute resources as an alternative to standard Kubernetes Ingress:

```yaml
containers:
  api:
    # Standard Kubernetes Ingress - not enabled when using IngressRoute
    ingress:
      enabled: false
    
    # Traefik IngressRoute configuration
    ingressroute:
      enabled: true
      entryPoints:
        - web
        - websecure
      routes:
        - match: "Host(`api.example.com`) && PathPrefix(`/`)"
          kind: Rule
          services:
            - port: 80
          middlewares:
            - name: strip-prefix
      # TLS configuration with certResolver
      tls:
        certResolver: le
        options:
          name: modern-tls
        domains:
          - main: api.example.com
            sans:
              - api-staging.example.com
```

You can use either the standard Kubernetes Ingress or Traefik IngressRoute (or both) for each container. See examples/values-with-traefik-ingressroute.yaml for more detailed examples.

## AWS Secrets Store CSI Driver Integration

The chart supports the AWS Secrets Store CSI Driver Provider (ASCP) for securely fetching and mounting secrets from AWS Secrets Manager and Parameter Store:

```yaml
containers:
  api:
    # AWS Secrets Store CSI Driver configuration
    awsSecrets:
      enabled: true
      region: us-east-1          # Optional (defaults to global.region)
      failoverRegion: us-west-2  # Optional for high availability
      mountPath: "/mnt/secrets"  # Path where secrets are mounted in container
      pathPermissions: "0640"    # Optional permissions for mounted files
      
      # Secrets to mount from AWS Secrets Manager/Parameter Store
      secrets:
        # Mount entire secret as a file
        - name: "app/database-credentials"
          type: "secretsmanager"
          fileName: "db-credentials.json"
        
        # Extract specific fields from a JSON secret
        - name: "app/api-config"
          jmesPath:
            apiKey: "api-key-file"
            endpoint: "endpoint-file"
      
      # Optionally sync AWS Secrets to Kubernetes Secret objects
      syncSecrets:
        - name: "app-database-secret"
          type: "Opaque"
          data:
            USERNAME:
              objectName: "app/database-credentials"
              objectKey: "username"
            PASSWORD:
              objectName: "app/database-credentials"
              objectKey: "password"
```

This configuration supports two methods of working with AWS Secrets:

1. **Direct File Mounting**: Secrets are mounted as files at the specified `mountPath`
2. **Kubernetes Secret Syncing**: AWS Secrets are synced to Kubernetes Secret objects, which can be used as environment variables or volume mounts

**Requirements:**
- The Secrets Store CSI Driver and AWS Provider must be installed in your cluster
- IAM permissions must be configured via IAM Roles for Service Accounts (IRSA) or EKS Pod Identity

See examples/values-with-aws-secrets.yaml for a complete example.

## CI/CD Integration

This chart includes a GitLab CI configuration for validating, packaging, and publishing:

- **Validate Stage**:
  - Lints the Helm chart
  - Tests template rendering 
  - Validates YAML syntax
  - Tests package creation

- **Package Stage**:
  - Creates a versioned Helm package

- **Publish Stage**:
  - Pushes the package to a Nexus Helm repository

To use with GitLab CI, set the following variables in your GitLab project:
- `NEXUS_URL`: Base URL of your Nexus instance
- `NEXUS_HELM_REPO`: Name of the Helm repository in Nexus
- `AWS_SECRET_ID`: Path to the secret in AWS Secrets Manager (default: "helm/nexus-credentials")
- `AWS_REGION`: AWS region where your secrets are stored (default: "us-east-1")

The AWS secret should be structured as a JSON with the following format:
```json
{
  "NEXUS_USER": "nexus-user",
  "NEXUS_PASSWORD": "nexus-password"
}
```

This approach assumes the GitLab runner is running on an EC2 instance with an IAM role that has permission to access the specified secret in AWS Secrets Manager.

## License


remote: INFO: GL-HOOK-ERR: Commit Rejected because the following secrets were detected: INFO: Finding 1 - Commit:45b054950fcbb1156a15deb3135fd9f200396c6f, File:sample-values.yaml, Line:346. Finding 2 - Commit:45b054950fcbb1156a15deb3135fd9f200396c6f, File:sample-values.yaml, Line:347. . Refer to "Secrets Management: Pushing a branch blocked by push protection" article in the DAB wiki. To view a complete report of findings, you are required to use


```yaml
psb1-helm-base-chart:
    containers:
      yourapp:
        enabled: true
        deployment:
          replicas: 1
          # Required minimal structure
          strategy:
            type: RollingUpdate
          terminationGracePeriodSeconds: 30

        container:
          image:
            repository: your-image
            tag: latest
            pullPolicy: IfNotPresent
          # Required probes
          livenessProbe:
            enabled: false
          readinessProbe:
            enabled: false
          startupProbe:
            enabled: false
          # Empty arrays for optional lists
          ports: []
          env: []
          volumeMounts: []

        # Required sections
        service:
          enabled: false
          ports: []

        # All these need to exist with enabled: false
        secret:
          enabled: false
        ingress:
          enabled: false
        persistentVolumeClaim:
          enabled: false
        hpa:
          enabled: false
        keda:
          enabled: false
        serviceMonitor:
          enabled: false
        networkPolicy:
          enabled: false

        # ConfigMaps need special structure
        configMaps:
          default:
            enabled: false
```
Copyright © 2023
 k get endpoints frontend -npsb-sample -o yaml
apiVersion: v1
kind: Endpoints
metadata:
  creationTimestamp: "2025-05-22T00:59:43Z"
  labels:
    app: sample-app
    app.kubernetes.io/instance: psb-sample
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: frontend
    environment: dev
    helm.sh/chart: psb1-helm-base-chart-0.2.2
    tier: services
  name: frontend
  namespace: psb-sample
  resourceVersion: "3177297"
  uid: 52f5ff2f-8554-4bbd-84a0-53f297325afd
subsets:
- addresses:
  - ip: 10.201.26.27
    nodeName: ip-10-201-26-46.ec2.internal
    targetRef:
      kind: Pod
      name: frontend-59f9d8bcfd-ztlt9
      namespace: psb-sample
      uid: 3aec7c9a-8d10-43b5-ac75-cd98eb7e73be
  ports:
  - name: http
    port: 8080
    protocol: TCP
[ec2-user@ip-10-201-26-39 ~]$ k get pods -npsb-smple
No resources found in psb-smple namespace.
[ec2-user@ip-10-201-26-39 ~]$ k get pods -npsb-sample
NAME                        READY   STATUS    RESTARTS   AGE
backend-6d9dd58644-wz8kl    1/1     Running   0          9h
frontend-59f9d8bcfd-ztlt9   1/1     Running   0          9h
[ec2-user@ip-10-201-26-39 ~]$ k get ingressroute frontend -o yaml
Error from server (NotFound): ingressroutes.traefik.io "frontend" not found
[ec2-user@ip-10-201-26-39 ~]$ k get ingressroute frontend -o yaml -npsb-sample
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"traefik.io/v1alpha1","kind":"IngressRoute","metadata":{"annotations":{},"labels":{"app":"sample-app","app.kubernetes.io/instance":"psb-sample","app.kubernetes.io/managed-by":"Helm","app.kubernetes.io/name":"frontend","environment":"dev","helm.sh/chart":"psb1-helm-base-chart-0.2.2","tier":"services"},"name":"frontend","namespace":"psb-sample"},"spec":{"entryPoints":["web"],"routes":[{"kind":"Rule","match":"Host(`frontned.psb.awslab.uspto.gov`) \u0026\u0026 PathPrefix(`/`)","services":[{"name":"frontend","port":80}]}]}}
  creationTimestamp: "2025-05-22T09:32:20Z"
  generation: 1
  labels:
    app: sample-app
    app.kubernetes.io/instance: psb-sample
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: frontend
    environment: dev
    helm.sh/chart: psb1-helm-base-chart-0.2.2
    tier: services
  name: frontend
  namespace: psb-sample
  resourceVersion: "3181546"
  uid: 429d7839-37cf-4c17-b249-6b8e304fc006
spec:
  entryPoints:
  - web
  routes:
  - kind: Rule
    match: Host(`frontned.psb.awslab.uspto.gov`) && PathPrefix(`/`)
    services:
    - name: frontend
      port: 80
[ec2-user@ip-10-201-26-39 ~]$ k ddescribe svc frontend -n psb-sample
error: unknown command "ddescribe" for "kubectl"

Did you mean this?
        describe
[ec2-user@ip-10-201-26-39 ~]$ k describe svc frontend -n psb-sample
Name:              frontend
Namespace:         psb-sample
Labels:            app=sample-app
                   app.kubernetes.io/instance=psb-sample
                   app.kubernetes.io/managed-by=Helm
                   app.kubernetes.io/name=frontend
                   environment=dev
                   helm.sh/chart=psb1-helm-base-chart-0.2.2
                   tier=services
Annotations:       <none>
Selector:          app.kubernetes.io/instance=psb-sample,app.kubernetes.io/name=frontend
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                172.20.104.79
IPs:               172.20.104.79
Port:              http  80/TCP
TargetPort:        http/TCP
Endpoints:         10.201.26.27:8080
Session Affinity:  None
Events:            <none>
[ec2-user@ip-10-201-26-39 ~]$ k get svc -n traefik -o wide
NAME      TYPE           CLUSTER-IP       EXTERNAL-IP                                                PORT(S)                      AGE     SELECTOR
traefik   LoadBalancer   172.20.196.255   traefik-nlb-5c6d0cf5a7a99ac5.elb.us-east-1.amazonaws.com   80:30080/TCP,443:30443/TCP   2d16h   app.kubernetes.io/instance=traefik-traefik,app.kubernetes.io/name=traefik

