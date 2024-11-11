## Software to Install:

- Terraform
- Docker
- OCI Cli
- GitHub

## Setup ~/.oci

```shell
mkdir ~/.oci
touch config
mv oci_apy_key.pem ~/.oci
```

Sample of config:

```dotenv
[DEFAULT]
user=ocid1.user.oc1..aaaaaaaagxxxxxrujhqz6okamxba
fingerprint=ae:6f:....:3b
tenancy=ocid1.tenancy.oc1..aaaaaaaa5ksgxxxxxxxxhrqvtepea
region=us-chicago-1
key_file=~/.oci/oci_api_key.pem
```

Make sure it works:

```shell
oci os ns get
oci iam availability-domain list
```

## Variables to prepare

1. `ad_list`

    <table>
      <tr>
        <td>Description</td>
        <td>Get availability domains</td>
      </tr>
      <tr>
        <td>Command</td>
        <td><b>oci iam availability-domain list</b></td>
      </tr>
      <tr>
        <td>Sample Value</td>
        <td>["HWME:US-CHICAGO-1-AD-1"]</td>
      </tr>

    </table>

2. `oke-worker-node-os-version`

    <table>
      <tr>
        <td>Description</td>
        <td>Node OS Version for the running K8s nodes</td>
      </tr>
      <tr>
        <td>Command</td>
        <td><b>oci ce node-pool-options get --node-pool-option-id all</b></td>
      </tr>
      <tr>
        <td>Sample Value</td>
        <td>8</td>
      </tr>
      <tr>
        <td>Reference</td>
        <td><a href="https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm" target="_blank">Compute Shapes</a></td>
      </tr>
    </table>

3. `oke-worker-node-shape`

    <table>
      <tr>
        <td>Description</td>
        <td>Node Shape for the running K8s nodes</td>
      </tr>
      <tr>
        <td>Command</td>
        <td><b>oci ce node-pool-options get --node-pool-option-id all</b></td>
      </tr>
      <tr>
        <td>Sample Value</td>
        <td>VM.Standard3.Flex</td>
      </tr>
    </table>


1. `ocir_registry_url`
    <table>
      <tr>
        <td>Description</td>
        <td>The endpoint needed to use to login via Docker and kubernetes deployments</td>
      </tr>

      <tr>
        <td>Sample Value</td>
        <td>
            <b>ord</b>.ocir.io
            <br/> <b>KEY</b>.ocir.io 
         </td>
      </tr>
      <tr>
        <td>Reference</td>
        <td>
            <a href="https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm" target="_blank">
               Regions and Availability Domains
            </a>
         </td>
      </tr>
    </table>
2. `ocir_namespace`
    <table>
      <tr>
        <td>Command</td>
        <td><b>oci os ns get</b></td>
      </tr>
    </table>
3. `oci_service_account_username`
4. `oci_service_auth_token`

## Deployment Process

### Docker login
Command
```shell
docker login -u '<ocir_namespace>/<oci_service_account_username>' <ocir_registry_url>
```
Example
```shell
docker login -u 'axq6t3vfixne/service_account' ord.ocir.io
```
Output
```text
> Login Succeeded
```

### Build the CC image
Command
```shell
docker buildx build --platform linux/amd64 -t <ocir_registry_url>/<ocir_namespace>/<cc-name>:<version> .
```
Example
```shell
docker buildx build --platform linux/amd64 -t ord.ocir.io/axq6t3vfixne/hello-world:v1 .
```
Output
```text
...
 => CACHED [2/6] WORKDIR /usr/src/app                                               0.0s
 => CACHED [3/6] COPY package*.json ./                                              0.0s
 => CACHED [4/6] RUN npm install --production                                       0.0s
 => [5/6] COPY . .                                                                  0.0s
 => [6/6] RUN npm install                                                          12.1s
 => exporting to image                                                              0.1s
 => => exporting layers                                                             0.1s
 => => writing image sha256:2e30bb4a5a87347bb625fef7d5472a61368981be6b61f99f0bc634  0.0s
 => => naming to ord.ocir.io/axq6t3vfixne/hello-world:v1                            0.0s
....
```

### Push image to OCIR
Command
```shell
docker push <ocir_registry_url>/<ocir_namespace>/<cc-name>:<version>
```
Example
```shell
docker push ord.ocir.io/axq6t3vfixne/hello-world:v1
```

### Automation:
[Deploy applications on a private OKE cluster using OCI Bastion and GitHub Actions](https://docs.oracle.com/en/solutions/deploy-oke-with-bastion-and-github/index.html#GUID-88DB2E49-F3FD-4BC9-993A-1B9F92835CB0)


## Troubleshooting

In case of using macos [you will need this](https://discuss.hashicorp.com/t/template-v2-2-0-does-not-have-a-package-available-mac-m1/35099)



