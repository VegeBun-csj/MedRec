# MedRec
本项目是笔者在学习Fabric过程中做的一个集成了前后端以及Fabric的Demo——基于区块链的医疗信息共享。

代码中难免有拙陋之处，部署的流程、前后端、后端与Fabric网络的交互均已经过测试，如部署中出现问题或者有哪部分写的不够详细的，都可以提Issue与我联系，下面的搭建流程中仅演示了关于区块链的部分，其他的并未演示（也未尽完善，以后有时间再补充）

> 项目中上链的过程采用非对称密钥RSA进行加密，通过本地IPFS来模拟文件的存储，区块链采用的Fabric
>
> 第一部分主要是环境的预安装(所有需要的工具包，笔者均已经放在MedRec文件中，无需其他的下载，至于其他的一些Node，mysql的一些环境，可以自行网上教程安装，只要版本对即可)
>
> 第二部分是项目的演示

## 一．准备

#### 1.前期环境准备

（1）系统为**Ubuntu16.04**(我是搭建的虚拟机)

（2）在ubuntu上安装**Mysql**，版本是**5.7.31**，按照网上教程安装即可。

（3）在MedRec的目录中找到database目录中的**MedRecord.sql**文件(这是项目中需要使用的本地数据库的文件)。将该文件导入到Ubuntu中的mysql数据库中。

如果你是在Windows上搭建的虚拟机环境，可以像我下面一样，使用Navicat远程连接到虚拟机，将上面sql文件导入虚拟机的Mysql数据库中

![image-20200909134016816](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909134016816.png)

 下面是导入之后的数据库的表：

![image-20200909134031322](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909134031322.png)

 

导入表后，查看**hospital**与**user**表中有没有记录，有的话删除！！！！一定要删除！！

导入之后两个表中各有两条记录，删除即可

（3）可选：安装**nvm**版本为0.33.10(版本不限制，nvm是用来管理node版本的一个工具，可以很方便地安装node，轻松地切换node和npm版本)，当然也可以不用nvm安装，主要是为了安装Node。你可以选择自己的方式安装Node

（4）使用nvm安装**Node.js**版本为**v10.19.0**（npm和cnpm都是下载node依赖的管理工具，类似于java中的maven，注意**npm一定要配置国内镜像源，不然会下载很长时间卡死**）

（5）安装go语言环境，版本为**>=1.11**及以上均可,此处是用的1.11版本

 以上的基本环境安装使用网上教程安装即可，这里不做赘述

---

（6）安装**go-ipfs**,用来搭建本地IPFS，这里使用**go-ipfs\v0.4.23\linux-amd64.tar.gz**，这个在github上下载比较慢，在MedRecord目录的**IPFSInstall**文件夹中已经提供了

- 安装过程：


1. 将文件中的压缩包拷贝至虚拟机中的“**home**” 目录下，比如这里我的是

   ![image-20200909135034037](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909135034037.png)

2. 解压：

   ```shell
   tar -xzvf go-ipfs_v0.4.23_linux-amd64.tar.gz
   ```

   此时会看到在同级目录下生成了**go-ipfs**文件夹

   ![image-20200909135230281](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909135230281.png)

3. 配置全局使用IPFS的环境：

   ```shell
   sudo mv go-ipfs/ipfs /usr/local/bin/ipfs
   ```

   如果此时在终端中运行：

   ```ipfs
   ipfs
   ```

   出现以下，就说明安装成功

   ![image-20200909135535099](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909135535099.png)

4. 初始化本地的IPFS环境：

   ```shell
   ipfs init
   ```

   ![image-20200909140211031](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909140211031.png)

   这样就初始化成功了,执行上面的这个ipfs cat /ipfs/xxxxxxxxxxxxxxxxxxxx（这个hash每个人不一样，执行自己机器上面的即可）

   ```shell
   ipfs cat /ipfs/QmS4ustL54uo8FzR9455qaxZwuMiUhyvMcX9Ba8nUH4uVv/readme
   ```

   出现下面：

   ![image-20200909140548528](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909140548528.png)

5. 启动本地的IPFS 守护进程(只有启动这个才能使用IPFS上传文件并访问IPFS上的文件)：

   ```shell
   ipfs daemon
   ```

   ![image-20200909140754676](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909140754676.png)

   至此，IPFS的环境已经搭建完毕，下面来试试IPFS简单的文件上传使用，这个进程在项目中不要关闭，后台一直运行

6. 上传一个文件试试，在同级目录下创建一个文件 **a.txt**,文件内容如下：

   ![image-20200909141200628](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909141200628.png)

7. 将该文件上传（在a.txt目录下执行）：

   ```shell
   ipfs add a.txt
   ```

   ![image-20200909141351986](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909141351986.png)

   看到added后面有一串hash，这个就是标识a.txt文件在IPFS上的hash地址，通过该地址就可以通过ipfs特定的网关(ipfs daemon启动后可以看到本地网关以及端口是127.0.0.1:8080/ipfs)拿到a.txt文件

   所以通过127.0.0.1:8080/ipfs+hash地址即可访问文件，打开浏览器：

   http://127.0.0.1:8080/ipfs/QmWcNW1SSeYzYzHhVXHaXrZaTnRVce1BEoffQqWUHsr4Fu

   ![image-20200909143225920](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909143225920.png)

​       即可看到我们上传到IPFS的文件。

> 此处是用的本地网关访问的，也可以使用其他的IPFS网关进行访问，即使可以访问外网，也需要等一段时间才能拿到文件。此处是为了方便测试和使用，使用了本地的网关，IPFS有好多备用的网关可以访问，网上可以搜索到很多
>
> 到这里，IPFS的本地节点部署就结束了，之后的病例文件也是通过这种方式上传访问（只是用了特定语言的IPFS API进行上传，底层还是一样的，都是通过这种 ipfs add的方式）



#### 2.下载Fabric1.4.4，并成功运行Fabric的例子，可以保证上面所有镜像，源码，依赖，工具版本都没有问题，完成了这一步才能进行下面的操作，非常重要！

 

#### 3.将项目MedRec拷贝至虚拟机中，所在目录如下：

 ![image-20200909143949808](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200909143949808.png)



注意：**MedRec**文件夹所在的目录要放置正确，最好上图的目录一致，不然可能会出现路径错误，因为项目中有部分写死了。



## 二. 开始MedRec项目运行

#### 1.在每次启动项目之前需要做两个重要的操作

（1）保证数据库的表**hospital和user**表中没有任何记录，有的话**删除**

（2）保证/home/用户名/go/src/github.com/hyperledger/MedRec/App/server/Identity/wallet目录下面没有任何文件，有的话**删除**！

（3）启动IPFS本地进程，即运行**ipfs daemon** 启动即可

（4）如果是第一次将项目复制进虚拟机，需要下载相关的依赖（也可以用cnpm下载的依赖，当然用npm下载依赖会比较慢，因为墙的原因，使用**npm下载时需要配备淘宝镜像源下载地址**）

![image-20200911115415026](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200911115415026.png)

![image-20200911115528162](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200911115528162.png)

![image-20200911115632553](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200911115632553.png)

在以上的三个目录中下载相应的依赖。

#### 2.开始启动项目的Fabric网络

进入以下目录：

![image-20200911115845729](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200911115845729.png)

启动网络，执行：

```shell
./start.sh up
```

启动网络需要一会时间,取决于你机器的配置..........................................（启动过程中启动了三个通道，三个链码，但是我们只用到**一个通道commonchannel，两个链码information和recordpa**）

出现以下即表示网络启动成功

 ![image-20200911122248915](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200911122248915.png)

注：（1）如果在启动网络时出现了超时错误，不会影响网络的启动，系统会自动尝试10次，但是如果出现了明显的比较严重的error，此时停止网络的启动，然后执行 ./start.sh down 再重新执行 ./start.sh up 启动网络，一般这种情况不多，但是出现过，网络启动过程中出现比较严重的timeout错误，只要把网络down掉重启即可

（2）**在每次网络启动之前，需要执行** **./start.sh down** **将网络环境清理干净启动，避免出现报错！！！**

 

#### 3.启动Node.js后端，包括医院，病人

##### （1）进入指定目录启动病人服务端：

 ![image-20200912141132896](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200912141132896.png)

##### （2）进入指定目录启动医院服务端：

![image-20200912141207135](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200912141207135.png)

**（3）启动IPFS本地节点**：

![image-20200912141423974](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200912141423974.png)

> 所以，本项目的部署启动，需要四个终端：两个后端程序node（分别模拟医院和患者），一个启动IPFS，一个启动Fabric网络

---

> #### 演示顺序严格按照以下的顺序执行！！！

##### （3）访问病人服务端

##### http://localhost:8081

![image-20200912110505902](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200912110505902.png)

 

**点击注册**，显示页面即可，但此时**不要真的进行注册**，因为我们还没有医院

![image-20200912110607151](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200912110607151.png)

> 这里之所以先访问这个注册页面是因为，之前在写页面的时候，把Fabric管理员用户生成放在了这个页面(后序会把这个改一下，这里不影响使用，只需要注意演示的顺序即可)，跳转到注册页面之后，管理员admin才会生成，后面的普通用户注册时需要用到管理员

此时，进入目录

> **/home/用户名/go/src/github.com/hyperledger/MedRec/App/server/Identity**
>
> 可以看到多出了一个文件**/wallet/admin**

 

##### （4）访问医疗服务端，并注册医院 

http://localhost:3000/

![image-20200912110954024](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200912110954024.png)



点击**注册（注意密码要6位！！！！）**

> （注意：**医院为第一人民医院的时候，用户名必须写h1;医院为第二人民医院的时候，用户名必须写h2**，因为这个在后端中写死了，并没有做更改，以后有机会再做优化，这里并不影响使用，因为本项目就只是做的两个医院）

![image-20200914203640236](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914203640236.png)

我们可以在**/home/用户名/go/src/github.com/hyperledger/MedRec/App/server/Identity**可以看到wallet文件夹中看到**hospital1**文件夹，其中出现这样几个文件即可代表注册hospital1成功(前两个文件是RSA公私钥，后三个是fabric网络通信的身份文件以及私钥)：

![image-20200914164514316](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914164514316.png)


> 点击sumit之后，进入后台，可以看到（第一次注册的时候，期间可能要等待一会，注意观察后端终端情况......直到后台终端出现下面的 **has been submit**的时候才算上链成功）

![image-20200914164243277](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914164243277.png)

此时就是上链成功！！！



**然后注册医院2**（和医院1的注册方式一样）

![image-20200914203820371](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914203820371.png)

 同样是上面的步骤，检查是否成功注册，并上链。



##### （5）注册病人（回到病人服务端）

http://192.168.162.139:8081/goRegister

![image-20200914172756795](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914172756795.png)

> **注册之后不要着急做操作!!!!**，注意后台还没有操作完成，正在进行患者公钥上链操作，等上链完成再操作

![image-20200914172903375](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914172903375.png)

并且注册之后页面会直接跳转到登陆（咱们选择相应的医院直接进行登陆即可）

![image-20200914173050301](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914173050301.png)

点击登录之后，跳转到以下页面

![image-20200914173135468](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914173135468.png)

完善患者个人信息，点击保存

![image-20200914173507616](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914173507616.png)

后台信息如下：

![image-20200914173525982](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914173525982.png)

查看数据库中patient表中会有一条记录

![image-20200914173558952](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914173558952.png)

此时病人信息登记成功，然后就是问诊，点击左边栏**问诊**，然后点击**心内科**

![image-20200914173706625](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914173706625.png)

填写自己的病情信息，保存即可

![image-20200914173802247](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914173802247.png)

##### （6）医院登陆（访问3000端口）

http://192.168.162.139:3000/

![image-20200914173932678](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914173932678.png)

用户名填**h1**,此时就代表咱们登入的是医院1 （因为刚刚病人波多野在医院1进行了病情描述，我们现在就是在医院1下面看下情况，从而进行问诊）

![image-20200914174101625](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914174101625.png)

 

登录之后，点击**医生工作站中的诊断病人**

![image-20200914174502481](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914174502481.png)

可以看到患者波多野之前在医院1的就诊记录（病情描述），点击这条记录

![image-20200914174538639](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914174538639.png)

选择**症状**

![image-20200914174646200](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914174646200.png)

点击**保存**，此时就会出现该病的处方。

![image-20200914174819464](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914174819464.png)

然后**导出病例**

![image-20200914174937558](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914174937558.png)

此时咱们可以在**/home/用户名/go/src/github.com/hyperledger/MedRec/App/server/hospital-management-system-master/file**目录中看到生成了病例 文件**9.txt**

![image-20200914175142569](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914175142569.png)



> 打开可以看到是患者的病情和医院诊断的信息还有其他一些详细信息，待会咱们就把这个文件上传至IPFS



选择上传病历

![image-20200914175309732](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914175309732.png)

> **注意：qqq是波多野的用户名**

![](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914180145627.png)

点击上链，可以看到后台正在将病历上传至IPFS，然后将返回的hash上链，**稍等一会！！！**出现下面才是成功了

![image-20200915134848811](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200915134848811.png)

此时，医院就将病人被诊断的病例信息上传IPFS和Fabric了，病人可以登录之后看到病例

> 如果出现了这种错误，说明身份失效了，需要重新登陆医院1.
>
> ![image-20200914180635240](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200914180635240.png)



##### （7）病人端再登陆查看刚刚医院上传的病例（根据自己的信息）

登陆之后点击左侧的**链上就诊信息**

![image-20200915135344640](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200915135344640.png)

点击查看历史，可以看到，病人有一个历史病例，就是刚刚医院上传的，这里可以查看病例，并且授权其他医院访问（此处就是病人的**病史查询功能和授权功能**）

![image-20200915135431900](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200915135431900.png)

点击hash地址查看如下：（注意：这里查看的时候，要在虚拟机里面打开浏览器访问这个hash地址链接）

![image-20200915135753758](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200915135753758.png)

然后病人点击授权病例（此处授权医院2即hospital2）

![image-20200915135843199](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200915135843199.png)

点击授权，查看后台终端：

![image-20200915135918945](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200915135918945.png)

授权成功！！！



##### （8）医院2登陆（查看被授权的病历）

![image-20200915140137983](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200915140137983.png)

点击医生工作站中的查看第三方病例

![image-20200915140224557](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200915140224557.png)

![image-20200915140715050](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200915140715050.png)

查看到病历

![image-20200915140810121](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200915140810121.png)

点击hash地址链接

![image-20200915140821695](C:\Users\Bun\AppData\Roaming\Typora\typora-user-images\image-20200915140821695.png)

可以看到被授权的病例，到此，病例共享的过程就结束了！！！