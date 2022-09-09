# Installation of RabbitMQ across multiple K8's clusters using skupper

## Pre Requisites

1. Skupper installed across both the clusters and linked with each other

## Steps

1. This installation of RabbitMQ clustering uses the "Classic discovery Clustering model" available from RabbitMQ.
2. Classic discovery clustering requires nodes names to be prepopulated in the RabbitMQ.conf file for all the nodes
3. names of the sites(clusters) are mentioned in the values file Values.yaml file. This is very important because the deployment uses these names to understand, Where the nodes are getting deployed.

```
site1: cluster1
site2: cluster2
```
4. The deployment in both the clusters should happen sequentially and not parallely. This requirment is to stop creating the nodes with the same name across both the clusters.
5. Installation the helm chart in both the clusters one at a time, using the command below. This will deploy 2 nodes in each cluster with clustername appended in the name.

```
helm upgrade --install skupperrabbitmq ./skupper-rabbitmq-chart
```

### Cluster1
```
$oc get pods | grep skupper-rabbit
skupper-rabbit-cluster1-0-7449f7fd6b-5l6cw        1/1     Running   0          3h7m
skupper-rabbit-cluster1-1-d4f564864-qpmxq         1/1     Running   0          3h7m
```
### Cluster2

```
$oc get pods | grep rabbit
skupper-rabbit-cluster2-0-7fd9bdbcfb-4g67q                        1/1     Running           0          52m
skupper-rabbit-cluster2-1-6c84645ddb-s2fcv                        1/1     Running           0          50m

```
if you notice the services, Services from both the clusters will be visible across both the clusters, This is because of skupper expose them to the remote clusters.

```
$oc get svc | grep rabbit
skupper-rabbit-cluster1-0                         ClusterIP   100.119.157.245   <none>        15672/TCP,4369/TCP,5671/TCP,15671/TCP,5672/TCP,25672/TCP   3h10m
skupper-rabbit-cluster1-1                         ClusterIP   100.119.249.69    <none>        5672/TCP,25672/TCP,15672/TCP,4369/TCP,5671/TCP,15671/TCP   3h11m
skupper-rabbit-cluster2-0                         ClusterIP   100.119.201.189   <none>        15672/TCP,4369/TCP,5671/TCP,15671/TCP,5672/TCP,25672/TCP   55m
skupper-rabbit-cluster2-1                         ClusterIP   100.119.179.165   <none>        5672/TCP,25672/TCP,15672/TCP,4369/TCP,5671/TCP,15671/TCP   55m
skupperrabbit-cluster2-0                          ClusterIP   100.119.121.146   <none>        5672/TCP,25672/TCP,15672/TCP,4369/TCP,5671/TCP,15671/TCP   55m
skupperrabbit-cluster2-1                          ClusterIP   100.119.55.250    <none>        5672/TCP,25672/TCP,15672/TCP,4369/TCP,5671/TCP,15671/TCP   55m
skupperrabbitmq                                   ClusterIP   100.119.173.215   <none>        5672/TCP,25672/TCP,15672/TCP,4369/TCP,5671/TCP,15671/TCP   3h11m
```
Expose the http-stats port on one the services shown above in any of the clusters, All the nodes deployed on both the clusters will be visible .

![Alt text](./images/Rabbitmqcluster.png?raw=true "Rabbitmqcluster")

## Consuming RabbitMQ services

A service names ***"skupperrabbitmq"*** gets exposed which will point to all the nodes of rabbitmq. This should be used to send and recieve messages from RabbitMQ.