# Hairpin Docker/Kubernetes Demo

POC showing hairpin connectivity over (self-signed) TLS. This sample uses a [sample Web API application](https://github.com/ckriutz/HairpinConsole) to make HTTPS requests (self-signed certificate) to a `ClusterIP` service to test for loopback connectivity issues. 

**THIS IS NOT PRODUCTION CODE.**

## Instructions

Modify the contents of [setup.ps1](setup.ps1) to set a resource group and cluster name. The script will create the resource group and the cluster. You will need to retrieve the ClusterIP of the service deployed and update the `API_IP_ADDRESS` environment variable in [deployment.yaml](deployment.yaml) with this ClusterIP. 

```powershell
# invoke the setup script
.\setup.ps1

# create the service
kubectl apply -f .\service.yaml

# get the cluster IP of the service
kubectl get svc hairpin -o jsonpath="{.spec.clusterIP}"

# update deployment.yaml with the IP and deploy
kubectl apply -f .\deployment.yaml
```

## Generate Certificates

The Web API application looks for a `.pfx` file in the `./certs` directory. It also uses a hard-coded password of "123456". **Again, this is not production code.**

```bash
# generate the private key
openssl genrsa -out tls.key 2048

# create the CSR
openssl req -new -key tls.key -out tls.csr

# create the cert
openssl x509 -req -days 365 -in tls.csr -signkey tls.key -out tls.crt

# convert to PFX
openssl pkcs12 -export -out tls.pfx -inkey tls.key -in tls.crt -passout pass:123456
```