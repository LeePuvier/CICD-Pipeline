pipeline {

    agent any
    
    tools {
    	maven 'maven'
  	}

    stages {
      stage('Check Out Code') {
				steps {
					dir('code') {
						echo "starting APIScript......"
						git([url: 'git@github.com:LeePuvier/Java-Dubbo-ZookeeperSpring-Mybatis.git', branch: env.CaseBranch, credentialsId: '0f583688-7da2-4abd-a5cd-3b40fa1a73a6'])
					}
				}
      }
      
		stage('Exec Test Case Ing') {
				steps {
					dir('code') {
						echo "starting Testing......"
							//withMaven(maven: 'maven') {        
								script {
									try {
										sh "mvn clean test"
									} catch (exc) {
										echo 'Some TestCase failed'
									}
								}
							//}
					}
				}
	    }
	    
		stage('Create Sonar File') {
        steps {
		        echo "Start create sonar file......"
						script {
							sh "chmod +x -R ${JOB_NAME}"
							sh "${JOB_NAME}/generate_sonar_file.sh code"
						}
          }
        }
        
		stage('Sonar Scanner') {
        steps {
            echo "starting excute sonar scanner......"
            dir('code') {
                script {
									def sonarqubeScannerHome = tool name: 'SonarQube Scanner'
                    	withSonarQubeEnv('SonarQube-Public') {
                        	sh "${sonarqubeScannerHome}/bin/sonar-scanner"
                    	}
                }
            }
        	}
        }
        
		stage('Analysis Jacoco Results') {
			steps {
				echo "starting parse jacoco report......"
				
				dir('code') {
					script {
						if(!"".equals(env.ClassInclusions)){
							jacoco inclusionPattern:ClassInclusions
						}else{
							jacoco()
						}
					}
				}
			}
		}
		stage('Send Emails') {
			steps {
				echo "starting send emails......"
				wrap([$class: 'BuildUser']) {
					script {
						sh "${JOB_NAME}/sendEmails.sh code ${JOB_NAME}"
					}
				}
			}
		}
    }
}
