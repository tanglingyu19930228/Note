import time
import urllib.request
import pymysql.cursors

def get_html(url):
    headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.221 Safari/537.36 SE 2.X MetaSr 1.0'}
    request=urllib.request.Request(url,headers=headers)
    response=urllib.request.urlopen(request)
    html=response.read()
    return html

connection=pymysql.connect(host='127.0.0.1',port=3306,user='root',password='cp1193543051+',db='fuliba',charset='utf8',cursorclass=pymysql.cursors.DictCursor)
cursor=connection.cursor()
sql="SELECT * FROM urls"
cursor.execute(sql)
results=cursor.fetchall()

for result in results:
    id=result['id']
    page_id=result['page_id']
    img_url=result['img_url']
    jiforjpg=result['jiforjpg']
    img_id=result['img_id']
    n=1
    while True:
        try:
            img_html=get_html(img_url)
            with open('%s_%s.%s'%(page_id,img_id,jiforjpg),'wb') as fp:
                fp.write(img_html)
                print(id)
        except Exception:
            if n>3:
                print("There is a wrong")
                break
            else:
                time.sleep(3)
                n+=1
            continue
        break
    
connection.close()
print('done')
