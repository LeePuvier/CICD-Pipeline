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
script_path=${2}
report_path=${code_path}/${TestModule}/target/surefire-reports/testng-results.xml
email_contant=${script_path}/email_contant.html

if [[ -n ${gitlabUserName} ]];then
	build_name=${gitlabUserName}
elif [[ -n ${BUILD_USER} ]];then
	build_name=${BUILD_USER}
else
	build_name="timer"
fi
echo "<!DOCTYPE html>
<html><head>
        <title>TestReport</title>
    </head>
<body><div><h3 color=\"#00FF00\">CI地址：${BUILD_URL}</h3><br/><h3 color=\"#00FF00\">提交人：${build_name}</h3></div></body>" > ${email_contant}

email_name="Coverage_Report_${JOB_NAME}_${BUILD_NUMBER}_${build_name}"

python ${script_path}/sendEmails.py "${email_list}" "${email_name}" "${email_contant}" "${report_path}"
exit_error "$?" "[error:$0:${LINE}]:sendEmails failed!"
exit 0