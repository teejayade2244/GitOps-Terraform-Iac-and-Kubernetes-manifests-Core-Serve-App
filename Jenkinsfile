pipeline {
  agent any
 parameters { choice(name: 'CHOICES', choices: ['plan', 'apply', 'destroy'], description: '') }
  stages {
    stage ("Git Checkout") {
      steps {
        checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/teejayade2244/core-serve-frontend.git']])
      }
    }

     stage ("terraform init") {
      steps {
         sh "terraform init"
      }
    }

    stage ("terraform plan") {
      steps {
        script {
          if [ params.CHOICES == plan ]then;
                sh "terraform plan"
          elif [ params.CHOICES == apply ]then;
                sh "terraform apply --auto-approve"
          elif [ params.CHOICES == destroy ]then;
                sh "terraform destroy"
          fi
        }
       
      }
    }

   

  }

}


