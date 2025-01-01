# Deploying an ODA Custom Component in OKE

This guide provides step-by-step instructions on how to deploy an Oracle Digital Assistant (ODA) Custom Component on Oracle Kubernetes Engine (OKE) and expose it through an API Gateway.

## Prerequisites

Before you begin, ensure you have the following:

- An Oracle Cloud account with access to OKE and API Gateway services.
- A configured OCI CLI.
- Kubectl installed and configured for your OKE cluster.
- Docker installed for building container images.
- Access to Oracle Container Registry for pushing Docker images.


### Step 0: Log in to the VM Using Bastion Server

Before starting the deployment process, you need to log in to your Virtual Machine (VM) through a Bastion server.

1. **Access the Bastion Server**:
    - Open a terminal on your local machine.
    - Connect to the Bastion server using SSH. Replace `<bastion-user>`, `<bastion-host>`, and `<bastion-key>` with your specific credentials and key file path:

      ```bash
      ssh -i <bastion-key> <bastion-user>@<bastion-host>
      ```

2. **Connect to the Target VM**:
    - From the Bastion server, initiate an SSH connection to the target VM. Replace `<vm-user>`, `<vm-host>`, and use the appropriate key if required:

      ```bash
      ssh <vm-user>@<vm-host>
      ```

Ensure you have the necessary SSH keys and permissions to connect through the Bastion server to your VM. Once logged in, you can proceed with the subsequent deployment steps.
### Step 1: Copy Your Custom Component

- Copy your custom component directory to `/home/opc/oke-deployments`.
- Ensure all necessary files, such as source code and configuration files, are included in this directory.

### Step 2: Prepare the `.env` File

Create a `.env` file at `/home/opc/oke-deployments/.env` with the following variables. These will be used throughout the deployment process.


| Variable                 | Description                                                                                |
|--------------------------|--------------------------------------------------------------------------------------------|
| CUSTOM_COMPONENT_DIR     | The path where your custom component is located.                                           |
| CUSTOM_COMPONENT_NAME    | The name of your custom component (used in Docker image naming and Kubernetes deployment). |
| OKE_PATH_ENDPOINT        | The endpoint path for your Oracle Kubernetes Engine deployment.                            |
| CUSTOM_COMPONENT_VERSION | The version tag for your Docker image.                                                     |


Example `.env` file content:

```plaintext
CUSTOM_COMPONENT_DIR=/home/opc/oke-deployments/utils
CUSTOM_COMPONENT_NAME=utils
OKE_PATH_ENDPOINT=utils
CUSTOM_COMPONENT_VERSION=v1
```

### Step 3: Manually Create the Registry Image in OCI

Before proceeding with the deployment, you need to manually create a container image repository in Oracle Cloud Infrastructure (OCI).

1. **Log in to the OCI Console**:
    - Go to the [Oracle Cloud Infrastructure Console](https://cloud.oracle.com/).

2. **Navigate to the Container Registry**:
    - From the main menu, select **Developer Services** > **Container Registry**.

3. **Create a New Repository**:
    - Click on **Create Repository**.
    - Enter the **name** for your repository. It must be identical to the `CUSTOM_COMPONENT_NAME` from your `.env` file.
    - Select the **compartment** where you want to create the repository. Ensure it is under the compartment: `dh-AI-cmp`.
    - Set the **visibility** to **Private** to restrict access to authorized users only.

4. **Confirm Creation**:
    - Click **Create** to finalize the repository creation.

Make sure the repository name exactly matches the `CUSTOM_COMPONENT_NAME` and is placed in the specified compartment with private visibility to ensure security and successful image pushing later in the process.


### Step 4: Run the Deployment Script

With all preparations complete, execute the deployment script to build, push, and deploy your custom component.

1. **Ensure Prerequisites**:
    - Verify that you have completed Steps 1 to 3.
    - Ensure the `.env` file is correctly configured and located at `/home/opc/oke-deployments/.env`.

2. **Run the Script**:
    - Navigate to the directory containing your `deployment.sh` script.
    - Execute the script with the following command:

      ```bash
      ./deployment.sh
      ```

This script will handle logging into the Oracle Container Registry, building and pushing the Docker image, and deploying the application to your Kubernetes cluster.

Ensure you have the necessary permissions and that your Kubernetes context is correctly set up before running the script.
