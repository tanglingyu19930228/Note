import time
import re
import urllib.request
import gc
import pymysql.cursors

def get_html(url):
    headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.221 Safari/537.36 SE 2.X MetaSr 1.0'}
    request=urllib.request.Request(url,headers=headers)
    while True:
        try:
            response=urllib.request.urlopen(request)
            html=response.read()
        except Exception:
            print("There is a wrong")
            time.sleep(3)
            continue
        break        
    return html

def downpage(html,num):
    html1=get_html(html)
    reg_img='<img src=\"(http[\S]*\.((gif)|(jpg)))\"( alt="")? />(</strong>)?</p>'
    pattern=re.compile(reg_img)
    imgs=re.findall(pattern,repr(html1.decode('utf-8')))
    del html1
    gc.collect()
    num1=1
    for img_old in imgs:
        img_new=img_old[0]
        if img_new.find('jpg')!=-1:
            strs='jpg'
        elif img_new.find('gif')!=-1:
            strs='gif'
        a="'"+str(num)+"'"
        b="'"+html+"'"                
        c="'"+img_new+"'"
        d="'"+str(num1)+"'"
        e="'"+strs+"'"
        sql="INSERT INTO urls(page_id,page_url,img_url,img_id,jiforjpg) values(%s,%s,%s,%s,%s)"%(a,b,c,d,e)                
        cursor.execute(sql)
        num1+=1

def download_html(html,num):
    reg_html='<p class="post-thumb"> <a class="thumb" rel="external" href="(http://fuliba.net/[\S]*\.html)" target="_blank"'
    pattern1=re.compile(reg_html)
    htmls=re.findall(pattern1,repr(html.decode('utf-8')))
    del html
    gc.collect()
    for html in htmls:
        print(num,':',html)
        downpage(html,num)
        num+=1
    return num

connection=pymysql.connect(host='127.0.0.1',port=3306,user='root',password='cp1193543051+',db='fuliba',charset='utf8',cursorclass=pymysql.cursors.DictCursor)
cursor=connection.cursor()
num=1
for i in range(1,20):
    if i==1:
        url='http://fuliba.net/'
    else:
        url='http://fuliba.net/'+'page/'+str(i)
    html=get_html(url)
    num=download_html(html,num)
    connection.commit()
connection.close()
print('Done')
