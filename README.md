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


Error: template: psb1-helm-base-chart/templates/main.yaml:7:3: executing "psb1-helm-base-chart/templates/main.yaml" at <include "psb1-helm-base-chart.deployment" (list $ $containerName)>: error calling include: template: psb1-helm-base-chart/templates/deployment.yaml:109:33: executing "psb1-helm-base-chart.deployment" at <$containerValues.container.livenessProbe.enabled>: nil pointer evaluating interface {}.enabled
helm.go:92: 2025-05-21 23:51:08.196259215 +0000 UTC m=+0.054009443 [debug] template: psb1-helm-base-chart/templates/main.yaml:7:3: executing "psb1-helm-base-chart/templates/main.yaml" at <include "psb1-helm-base-chart.deployment" (list $ $containerName)>: error calling include: template: psb1-helm-base-chart/templates/deployment.yaml:109:33: executing "psb1-helm-base-chart.deployment" at <$containerValues.container.livenessProbe.enabled>: nil pointer evaluating interface {}.enabled
Cleaning up project directory and file base
Copyright © 2023
