#coding:utf-8
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
import smtplib
import os
import sys
reload(sys)
sys.setdefaultencoding('utf-8')


def send(to_list,cc_list,sub,content,file):
    '''
    :param to_list: 收件人邮箱
    :param sub: 邮件标题
    :param content: 内容
    '''
    me = "877290202@qq.com"
    server_host = 'smtp.qq.com'
    smtpPort = '25'
    sslPort  = '465'


    username = '877290202@qq.com'
    password = '758168Li_pjun'
    # _subtype 可以设为html,默认是plain
    # msg = MIMEText(content, _subtype='plain')
    # msg = MIMEText(content, _subtype='html')
    f = open(content, 'rb')
    mail_body = f.read()
    f.close()
    msg = MIMEMultipart('alternative')
    msgText = MIMEText(mail_body, 'html', 'utf-8')
    msg.attach(msgText)
    if file is not None and os.path.exists(file):
        fileApart = MIMEApplication(open(file, 'rb').read())
        fileApart.add_header('Content-Disposition', 'attachment', filename=(os.path.basename(file)))
        msg.attach(fileApart)
    msg['Subject'] = sub
    msg['From'] = me
    msg['To'] = ';'.join(to_list)
    if cc_list is not  None:
        msg['Cc'] = ';'.join(cc_list)
    # token_file = urllib.urlopen(gettoken_url)
    
    try:
        #端口占用，使用以下方式
        #server = smtplib.SMTP()
        #纯粹的ssl加密方式，通信过程加密，邮件数据安全
        server = smtplib.SMTP_SSL(server_host,sslPort)
        server.ehlo()
        # server.starttls()
        #server.connect(server_host)
        server.login(username, password)
        # server.sendmail(me, to_list, msg.as_bytes())
        # logger.info("msg:"+msg.as_string())
        if cc_list is not None:
            server.sendmail(me, list(to_list+cc_list), msg.as_string())
        else:
            server.sendmail(me, to_list, msg.as_string())

        # server.sendmail(me, to_list, msg.as_string())
        print("邮件发送成功")
    except Exception as e:
        print("邮件发送失败："+str(e))
    finally:
        # print ('try finally')
        server.close()





# 主函数
if __name__ == '__main__':

    emaillist_str = sys.argv[1] # 收件人列表
    subname = sys.argv[2] # 邮件主题
    content = sys.argv[3] # 邮件内容
    attachment = sys.argv[4] # 附件
	
    emaillist = emaillist_str.split(",")


    #解析测试报告xml
    send(emaillist,None,subname,content,attachment)
    