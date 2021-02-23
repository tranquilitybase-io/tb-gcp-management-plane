## Requirements

| Name | Version |
|------|---------|
| terraform | >=0.13.4,<0.15 |
| google | <4.0,>= 2.12 |

## Usage

### Pre-Requisites
- Create a project for deployment
- Gcloud authentication setup
- If running on a local workstation execute ```export GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token)```
- Clone git repo
- Create deployment/common_vars.json file, replacing _PROJECT_ with your GCP Project ID

```hcl
gcloud services enable compute
git clone https://github.com/tranquilitybase-io/tb-gcp-management-plane-architecture.git

 
cat <<EOF > deployment/common_vars.json
{
  "project_id": "_PROJECT_",
  "region": "europe-west2"
}
EOF
source ./scripts/config.sh
make setup

```

### Deployment

- Execute the following in a terminal:

```hcl
make apply
 
gcloud compute ssh $(gcloud compute instances list \
     --project $TG_PROJECT --format="value(name)" --filter=forward) \
     --zone $(gcloud compute instances list --project $TG_PROJECT --format="value(zone)" --filter=forward) \
     --project $TG_PROJECT \
     --tunnel-through-iap \
     -- -L 3128:localhost:3128
```
- In a new terminal execute the following:

```hcl
cd tb-gcp-management-plane-architecture
source ./scripts/config.sh
gcloud container clusters get-credentials tb-mgmt-gke --region $TG_REGION
 
env HTTPS_PROXY=localhost:3128 kubectl get nodes
env HTTPS_PROXY=localhost:3128 kubectl cluster-info
```
