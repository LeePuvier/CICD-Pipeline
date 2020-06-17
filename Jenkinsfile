pipeline {

    agent any

    stages {
      stage('Check Out Code') {
				steps {
					dir('code') {
						echo "starting APIScript......"
						git([url: 'git@github.com:LeePuvier/Java-Dubbo-ZookeeperSpring-Mybatis.git', branch: env.CaseBranch, credentialsId: '297fc1a8-893a-4972-9a29-03d0ef67f2d3'])
					}
				}
      }
      
		stage('Exec Test Case Ing') {
				steps {
					dir('code') {
						echo "starting Testing......"
							withMaven(globalMavenSettingsConfig: '80d7f536-d473-44a8-9edf-60630acc7d72', jdk: 'Oracle JDK 8', maven: 'Maven 3.5.0', mavenSettingsConfig: 'bfa90212-2742-4611-aa71-8e0ec76d0c28') {        
								script {
									try {
										sh "mvn clean test"
									} catch (exc) {
										echo 'Some TestCase failed'
									}
								}
							}
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
