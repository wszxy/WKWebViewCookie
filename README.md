# WKWebViewCookie
如果已经开启了Apache和php设置，直接将web里的文件移到/Library/WebServer/Documents目录下。如果没有，请看下面的设置。
**注意**：代码里的ip地址需要改成自己电脑的ip地址，电脑和手机要处于同一个局域网！

**1.开启Apache**
打开terminal，输入sudo apachectl start，打开浏览器，输入localhost或127.0.0.1，显示it works！说明服务器开启成功
![访问本机地址](https://upload-images.jianshu.io/upload_images/4758290-baca1ad9409e872d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这个页面是位于服务器根目录下/Library/WebServer/Documents下的index.html.en.
用记事本打开这个文件，可以看到html的代码：

    <html><body><h1>It works!</h1></body></html>

我们把文件名修改为index.php，浏览器访问localhost/index.php，发现浏览器不能解析其内容，因为还没配置php环境。
**2.配置php**
找到php的配置文件的路径：/etc/apache2/httpd.conf
用记事本打开，搜索定位到php7_module这句话，然后将前面的#去掉，保存退出。
![httpd.conf](https://upload-images.jianshu.io/upload_images/4758290-74a0310221a4c56c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
**3.重启Apache**
在terminal中输入：sudo apachectl restart
再次用浏览器访问localhost/index.php，当你看到it works！显示说明配置成功了。
**4.客户端设置**
这里的客户端指的是iOS设备，只要客户端与服务器处在同一个局域网下，就可以直接通过ip地址访问。ip地址通过打开网络偏好设置查看。
![查看局域网中的ip](https://upload-images.jianshu.io/upload_images/4758290-fa569c450b484bc7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
然后在手机浏览器中输入ip/index.php，看到it works！表示访问成功。
![手机访问服务器](https://upload-images.jianshu.io/upload_images/4758290-7fd60071946137f6.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
