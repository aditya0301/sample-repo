def appVersion='0.1.0-SNAPSHOT'
pipeline {
  agent any

  options {
    ansiColor('xterm')
  }

  environment {
    TEST = "test"
    //   KUBECONFIG = credentials('kubeConfig')
    
    ORG_GRADLE_PROJECT_ARTIFACTORY = credentials('registry-docker')
    DOCKER_UPLOAD_ARTIFACTORY = 'aditya0301'
    //   HELM_UPLOAD_ARTIFACTORY = 'https://rt.artifactory.tio.systems/artifactory/helm-stmj-tnt-services-local'
   }


  parameters{
    booleanParam defaultValue: false, description: 'Indicate whether to skip tests or run them', name: 'runTests'
    booleanParam defaultValue: false, description: 'Should publish artifacts', name: 'publish'
    booleanParam defaultValue: false, description: 'Should deploy the artifact to the kubernetes cluster', name: 'deploy'
  }

  stages {

    stage ('Build') {
      steps {
        script {
        //   env.appVersion = sh(returnStdout: true, script: "cat build.gradle | grep ^version | awk '{print \$3}' | tr -d \"'\n\"")
            env.appVersion = sh(returnStdout: true, script: "echo 0.1.0-SNAPSHOT"'\n\"")
        }
        sh 'sleep 5'
        // sh 'sh gradlew clean compileJava'
        // sh 'sh gradlew clean compileTestJava'
      }
    }

    stage ('Unit & Integration Tests') {
      when {
        expression { return params.runTests }
      }
      steps {
        sh 'sleep 5'
        // sh 'sh gradlew clean test'
        // junit '**/build/test-results/test/**.xml'
      }
    }

    stage ('Generate Artifacts') {
      steps {
        sh 'sleep 5'
        // sh 'sh gradlew jar unpack'
        sh label: "Build Docker Image", script: "docker build -t ${DOCKER_UPLOAD_ARTIFACTORY}/sample-repo:${env.appVersion} -t ${DOCKER_UPLOAD_ARTIFACTORY}/sample-repo:latest ."
      }
    }

    stage ('Docker Build & Push Image') {
      when {
        expression { return params.publish }
      }
      steps {
        sh "docker login -u ${ORG_GRADLE_PROJECT_ARTIFACTORY_USR} -p ${ORG_GRADLE_PROJECT_ARTIFACTORY_PSW}"
        sh label:'Docker Push', script:"docker push ${DOCKER_UPLOAD_ARTIFACTORY}/sample-repo"
        sh label:'Docker Cleanup', script:"docker rmi -f ${DOCKER_UPLOAD_ARTIFACTORY}/sample-repo:latest ${DOCKER_UPLOAD_ARTIFACTORY}/sample-repo:${env.appVersion}"
      }
    }

    stage ('Setup Helm Publish') {
      when {
        expression { return params.publish }
      }
      steps {
        sh 'sleep 5'
        // sh "helm plugin install https://github.com/belitre/helm-push-artifactory-plugin --version 1.0.1"
        // sh "helm repo add tnt-local ${HELM_UPLOAD_ARTIFACTORY} --username ${ORG_GRADLE_PROJECT_ARTIFACTORY_USR} --password ${ORG_GRADLE_PROJECT_ARTIFACTORY_PSW}"
      }
    }

    stage ('Publish Helm Chart') {
      when {
        expression { return params.publish }
      }
      steps {
        sh 'sleep 5' 
        // dir('./src/main/helm') {
        //   sh "helm lint declaration-questionnaire-service"
        //   sh "helm repo update"
        //   sh "helm push-artifactory declaration-questionnaire-service/ tnt-local --version=${env.appVersion}"
        // }
      }
    }

    stage ('Install Helm Chart in Dev environment') {
      when {
        expression { return params.deploy }
      }
      steps {
        sh 'sleep 5'
        // dir('./src/main/helm') {
        //   sh "helm upgrade declaration-questionnaire-service ./declaration-questionnaire-service -n services --install -f ./declaration-questionnaire-service/service-values/values-dev.yaml --set image.tag=${env.appVersion} --set build.url=${BUILD_URL} --set build.number=${BUILD_NUMBER} --set build.name=${JOB_NAME}"
        // }
      }
    }
  }
}