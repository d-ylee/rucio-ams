
# Fermilab Rucio OKD Cluster Deployment 
## Scientific Data Management
### Brandon White
bjwhite@fnal.gov

Use this to deploy Rucio for an experiment. First source an experiments environment file and deploy with the experiment generic rucio-fnal framework.
In particular please make sure that the following are set by the sourcing of the environment file:
~~~~
    EXPERIMENT: Name of the experiment that configuration files are being generated for. Used when generating helm deployment configurations.
    FNAL_RUCIO_DIR: Set to the top level directory of the rucio-fnal repository (i.e. the directory this README resides in). Enables configuration files to be found in the directory structure detailed below.
    FNAL_EXP_RUCIO_CERT: Certificate for service authentication.
    FNAL_EXP_RUCIO_KEY: Key for service authentication.
    FNAL_EXP_RUCIO_CA_BUNDLE: CA certificates for service authentication.
    FNAL_EXP_RUCIO_CERT_KEY_COMBINED: Certificate and key concatenated. Needed for the Web UI.
    FNAL_RUCIO_VERSION: Use this when building fnal-rucio-* images to select the desired Rucio version for installation into the image. 
~~~~

## Before Deployment To-Do List
~~~~
    0. Have a database created for the new deployment to use. (Duh)
    1. Create rucio-<experiment> project in OKD
    2. Make sure you have the certificate and key for the Rucio service, and create the combined certificate+key PEM file.
    3. Edit <experiment>/setup_rucio_env.sh to set the required environment variables
    5. Have the FNAL OKD cluster administrators create the `useroot` account for the deployment to use
~~~~

Use deploy-rucio.sh to deploy services onto the OKD cluster after the environment is configured appropriately as described above. Use the setup_rucio_env.sh environment file at the top of the given experiment's configuration tree to do this.
Use undeploy-rucio.sh to remove them.

The Rucio code may be monkey patched at image build time by placing patch files into one of two locations: $FNAL_RUCIO_DIR/rucio-fnal/docker/[server,daemon]/patches

## EXAMPLE DIRECTORY STRUCTURE FOR AN EXPERIMENT:
~~~~
    dune
    ├── certs                               < Experiment specific certificate, key, cert/key concatenated, and CA certificate bundle. >
    │   ├── ca_bundle.pem
    │   ├── rucio.fnal.gov_cert.pem
    │   ├── rucio.fnal.gov_combined.pem
    │   └── rucio.fnal.gov_key.pem
    ├── helm
    │   ├── cache
    │   │   └── values.yaml
    │   ├── daemons
    │   │   └── values.yaml                 < Daemon configuration specific values > 
    │   ├── messenger
    │   │   └── values.yaml
    │   ├── osg_authentication
    │   │   └── values.yaml
    │   ├── secret
    │   │   └── config.yaml                 < Secret information such as DB connection string. >
    │   ├── server
    │   │   └── values.yaml                 < Server configuration specific values >
    │   └── webui
    │       └── values.yaml
    ├── patches
    └── setup_dune_rucio_env.sh             < Export the needed environment variables for experiment setup >
~~~~

Directories named certs/ and secret/ will not be committed to the repository according to the default .gitignore file.
