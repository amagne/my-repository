# Bookstore Web API Project

This project showcases the development and deployment of a containerized Bookstore Web API using Flask, Docker, Terraform, and AWS EC2.

## Key Technologies

- **Flask:** A Python microframework used to create RESTful web services.
- **Docker:** Containerization platform for packaging the application and its dependencies.
- **Docker Compose:** Tool for defining and running multi-container Docker applications.
- **AWS EC2:** Amazon Web Services virtual machine for hosting the application.
- **Terraform:** Infrastructure as Code (IaC) tool for provisioning resources on AWS.

## Step-by-Step Realization

### Develop the Web API:

- A Flask application was created to provide Bookstore API endpoints (e.g., add a book, retrieve book details, search for books, etc.).
- The API interacts with a MySQL database to manage book data.

### Containerize with Docker:

- **Dockerfile:** A Dockerfile was written with instructions to build a Docker image containing the Python environment, Flask dependencies, application code, and database connection settings.
- **Docker Image Build:** The `docker build` command was used to build the Docker image from the Dockerfile.

### Orchestrate with Docker Compose

- **docker-compose.yml:** A Docker Compose file defined the API container along with the database container, establishing their relationship and network configuration.

### Provision AWS Infrastructure with Terraform

- **main.tf:** Terraform files were created to define the following AWS resources:
  - EC2 instance
  - Security Groups (controlling inbound and outbound traffic).
- **AWS Deployment:** `terraform apply` deployed the defined resources.

### Deploy and Run on AWS

- **Git Repository:** Creates a private repository ("bookstore-api-repo") and uploads the core project files (e.g., "bookstore-api.py," "Dockerfile").
- **AWS Provisioning:** Deploys an EC2 instance (t2.micro) in the 'us-east-1' region, configured with a security group allowing SSH (port 22) and HTTP (port 80) access.
- **Instance Bootstrapping:** A user-data script was included in the EC2 configuration to, upon instance launch:
  - Install Docker.
  - Pull the project code from GitHub.
  - Run the application via `docker-compose up`.

## Accessing the Bookstore API

After deployment, the Bookstore API will be accessible at the public IP address or DNS name of your AWS EC2 instance. You can use tools like curl or Postman to interact with the API endpoints.

### Example Endpoint Interaction

```bash
# Add a new book
curl -X POST -H "Content-Type: application/json" -d '{"title": "The Hitchhiker\'s Guide to the Galaxy", "author": "Douglas Adams", "isbn":"9780345391803"}' http://<EC2_IP_ADDRESS>:<API_PORT>/books

# Get all books
curl http://<EC2_IP_ADDRESS>:<API_PORT>/books
