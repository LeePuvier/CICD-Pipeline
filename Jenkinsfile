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
										sh "mvn org.jacoco:jacoco-maven-plugin:prepare-agent -f pom.xml clean test -Dautoconfig.skip=true -Dmaven.test.skip=false -Dmaven.test.failure.ignore=true"
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
							sh "chmod +x -R code"
							sh "chmod +x -R UnitTestHttp"
							sh "UnitTestHttp/generate_sonar_file.sh code"
						}
          }
        }
        
		stage('Sonar Scanner') {
        steps {
            echo "starting excute sonar scanner......"
            dir('code') {
                script {
									def sonarqubeScannerHome = tool name: 'sonarscanner'
                    	withSonarQubeEnv('sonar') {
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
							jacoco changeBuildStatus: true, maximumLineCoverage:70, inclusionPattern:ClassInclusions
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
						sh "ls"
						sh "UnitTestHttp/sendEmails.sh code UnitTestHttp"
					}
				}
			}
		}
    }
}
