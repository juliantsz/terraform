env.AWS_ACCESS_KEY_ID = "${access_key_id}"
env.AWS_SECRET_ACCESS_KEY = "${secret_access_key}"
env.AWS_DEFAULT_REGION = 'us-east-1'

node {
  git (
    url: 'https://github.com/linuxacademy/content-terraform-docker-service.git',
    branch: 'remote-state'
  )
  stage('init') {
    sh label: 'terraform init', script: "terraform init -backend-config \"bucket=${bucket_name}\""
  }
  stage('plan') {
    sh label: 'terraform plan', script: "terraform plan -out=tfplan -input=false -var image_name=${image_name} -var ghost_ext_port=${ghost_ext_port}"
  }
  stage('apply') {
    sh label: 'terraform apply', script: "terraform apply -lock=false -input=false tfplan"
  }
}