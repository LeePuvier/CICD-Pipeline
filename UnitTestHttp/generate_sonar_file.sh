#!/bin/bash

echo "#######################################################"
echo "#           generate_sonar_file.sh is called         #"
echo "#######################################################"

function exit_error(){
    if [[ ${1} != 0 ]];then
		echo "${2}"
	    exit 1
	fi
}

code_path=${1}
rm -rf sonar-project.properties

projectVersion=$(date +"%Y-%m-%d_%H-%M-%S")

echo "# sonar.projectKey 项目key（自定义）
sonar.projectKey=${JOB_NAME}_${CaseBranch}_UnitTest
# sonar.projectName项目名称（自定义）
sonar.projectName=${JOB_NAME}_${CaseBranch}_UnitTest
# sonar.projectVersion 项目版本
sonar.projectVersion=${projectVersion}
# sonar.sourceEncoding 源码编码格式
sonar.sourceEncoding=UTF-8
# sonar.language 指定了要分析的开发语言（特定的开发语言对应了特定的规则）
sonar.language=java
# sonar.java.binaries 需要分析代码的编译后 class 文件位置
#sonar.java.binaries=.
sonar.java.binaries=${TestModule}/target/classes
# sonar.sources 需要分析的源代码位置（示例中的$WORKSPACE 所指示的是当前 Jenkins 项目的目录）
sonar.sources=${TestModule}/src
# sonar.core.codeCoveragePlugin 指定统计代码覆盖率工具
sonar.core.codeCoveragePlugin=jacoco
# sonar.jacoco.reportPaths 覆盖率结果文件路径
sonar.jacoco.reportPaths=${TestModule}/target/coverage-reports/jacoco.exec"  > ${code_path}/sonar-project.properties

if [[ -n ${CodeInclusions} ]];then
	echo "# sonar.inclusions 需要分析的源代码路径包含文件
sonar.inclusions=${CodeInclusions}" >> ${code_path}/sonar-project.properties
fi

if [[ -n ${CodeExclusions} ]];then
	echo "# sonar.exclusions 需要分析的源代码路径不包含文件
sonar.exclusions=${CodeExclusions}" >> ${code_path}/sonar-project.properties
fi

cat ${code_path}/sonar-project.properties
exit 0