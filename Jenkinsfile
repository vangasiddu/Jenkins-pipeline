def CONTAINER_NAME="jenkins-pipeline"
def CONTAINER_TAG="latest"
def DOCKER_HUB_USER="vangasiddu"
def HTTP_PORT="8090"

node {

    stage('Initialize'){
        def dockerHome = tool 'myDocker'
        def mavenHome  = tool 'myMaven'
        env.PATH = "${dockerHome}/bin:${mavenHome}/bin:${env.PATH}"
    }

    stage('Checkout') {
        checkout scm
    }

    stage('Build'){
        bat "mvn clean install"
    }

    /*stage('Sonar'){
        try {
            sh "mvn sonar:sonar"
        } catch(error){
            echo "The sonar server could not be reached ${error}"
        }
     }*/

    stage("Image Prune"){
        imagePrune(CONTAINER_NAME)
    }

    stage('Image Build'){
        imageBuild(CONTAINER_NAME, CONTAINER_TAG)
    }

    stage('Push to Docker Registry'){
        withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            pushToImage(CONTAINER_NAME, CONTAINER_TAG, USERNAME, PASSWORD)
        }
    }

   stage('Run App'){
        runApp(CONTAINER_NAME, CONTAINER_TAG, DOCKER_HUB_USER, HTTP_PORT)
    } 

}

def imagePrune(containerName){
    try {
        "minikube ssh"
        bat "docker image prune -f"
         "docker stop $containerName"
        echo "image prune completed"
    } catch(error){}
}

def imageBuild(containerName, tag){
     "docker build -t $containerName:$tag  -t $containerName --pull --no-cache ."
    echo "Image build complete"
}

 def pushToImage(containerName, tag, dockerUser, dockerPassword){
     "docker login -u $dockerUser -p $dockerPassword"
     "docker tag $containerName:$tag $dockerUser/$containerName:$tag"
     "docker push $dockerUser/$containerName:$tag"
    echo "Image push complete"
}

 def runApp(containerName, tag, dockerHubUser, httpPort){
     "docker pull $dockerHubUser/$containerName"
     "docker run -d --rm -p $httpPort:$httpPort --name $containerName $dockerHubUser/$containerName:$tag"
    echo "Application started on port: ${httpPort} (http)"
} 
