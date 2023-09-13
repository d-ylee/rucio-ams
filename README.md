
# rucio-ams 
## Fermilab Rucio Deployment Framework 
### Scientific Data Management
#### Brandon White
bjwhite@fnal.gov

Once you have access to your Kubernetes cluster, you can deploy Rucio for a given overlay (found in overlays/[dev,prod,int,dune,etc...]) using the Makefile found in that overlay/xyz directory.

    make apply

This will run multiple steps, downloading Secrets from Vault, building K8s resourece manifests with Helm templates, ending by using Kustomize to create or update the Rucio application resources.

This framework uses `kustomize` to allow modification of Helm template outputs from the official Rucio Helm chart. This is used in particular to patch the environment of containers such that they are configured to have the database connection string passed in via the value of a `Secret`. This allows us to keep the Kubernetes resource manifests generated by the Helm templates under version control, without exposing a base64 encoded password as compared with a `--values` injection to the Helm template process.

Before deploying Rucio, the secrets and credentials needed for the application will need to be pushed to Vault. Vault-resident secrets will be downloaded when `make apply` is run and then loaded into the cluster via `SecretGenerator` definitions in the `kustomization.yaml` files.

The hostcert.pem, hostkey.pem, ca.pem, and db-connstr files should be placed in <rucio-ams>/overlays/<experiment>/rucio/etc/.secrets/

For selection of a policy package, simply add __init.py__, permission.py, and schema.py to
<rucio-ams>/overlays/<experiment>/etc/policy-package. No other configuration is required, as the files are
mounted as a secret. All policy packages will be referred to in the containers/config files as "fermilab",
regardless of the experiment-specific policy package implementation files mounted.
