import time
import re
import urllib.request
import gc
#gc shi fang nei cun
def get_html(url):
    headers={'User-Agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.221 Safari/537.36 SE 2.X MetaSr 1.0'}
    request=urllib.request.Request(url,headers=headers)
    response=urllib.request.urlopen(request)
    html=response.read()
    return html
def downpage(html,num):
    html=get_html(html)
    reg_img='<img src=\"(http[\S]*\.((gif)|(jpg)))" />(</strong>)?</p>'
    pattern=re.compile(reg_img)
    imgs=re.findall(pattern,repr(html.decode('utf-8')))
    del html
    gc.collect()
    num1=1
    timed=time.strftime('%Y%m%d',time.localtime(time.time()))
    for img_old in imgs:
        img_new=img_old[0]
        if img_new.find('jpg')!=-1:
            strs='jpg'
        elif img_new.find('gif')!=-1:
            strs='gif'
        while True:
            try:
                img_html=get_html(img_new)
                with open('%s_%d_%d.%s'%(timed,num,num1,strs),'wb') as fp:
                    fp.write(img_html)
                    print(num1)
                num1+=1
            except Exception:
                print("There is a wrong")
                time.sleep(3)
                continue
            break
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
num=1
for i in range(1,11):
    if i==1:
        url='http://fuliba.net/'
    else:
        url='http://fuliba.net/'+'page/'+str(i)
    html=get_html(url)
    num=download_html(html,num)
print('Done')
