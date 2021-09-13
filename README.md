# 数字信号处理音频FIR去噪滤波器（基于MATLAB GUI的开发）

## 1、内容简介
 &nbsp;  &nbsp; &nbsp;  &nbsp;利用MATLAB GUI设计平台，用窗函数法设计FIR数字滤波器，对所给出的含有噪声的声音信号进行数字滤波处理，得到降噪的声音信号，进行时域频域分析，同时分析不同窗函数的效果。将文件解压至一个目录下，运行m文件即可使用。
## 2、函数使用
   读取.wav音频文件函数：audioread（）；（老版本为wavread）
   MATLAB播放音乐函数：sound()；
   MATLAB停止播放音乐：clear sound
   写入.wav音频文件函数：audiowrite（）；（老版本为audiowrite）
   加入白噪声：noise=(max(x(:,1))/5)*randn(x,2);
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;y=x+noise;
   频谱分析：&nbsp;&nbsp;&nbsp;&nbsp;fft（）；
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fftshift（）；
   Fir滤波：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fir1（n,Wn,ftype,window）；
   窗函数选择：	
				梯形窗boxcar
				三角窗triang
				海明窗hamming             
				汉宁窗hanning
				布莱克曼窗blackman
				凯塞窗kaiser

## 3、实现功能
![**音频滤波GUI界面**](https://img-blog.csdnimg.cn/20200423205510136.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjc5NTcz,size_16,color_FFFFFF,t_70)
实现的功能有：

1、打开文件：选择路径打开wav格式的音频文件，自动生成音频的原始波形与频谱。    

2、加入噪声：有两种噪声可以选择加入，一种是白噪声，其频率蔓延整个频谱；一种是特定频率的噪声，可通过输入频率加入单一频率的噪声。加入噪声后自动绘制加入噪声后的波形与频谱。

3、滤波处理：首先输入滤波器通/阻带的开始频率与截止频率（若为低/高通类型滤波，则只需输入开始频率；若为带通/阻类型，则开始与截止都要输入；输入频率值为真实频率值，可根据频谱图进行判断 ），之后选取窗函数和滤波类型，将会生成滤波处理后的波形与频谱。

4、音频播放/停止：可随时播放/停止原始、加噪、滤波处理后的音频。

5、图片导出：将波形、频谱图片一张张导出保存，可选的格式有jpg、png、bmp、eps。

6、保存文件：将加躁/滤波后的音频导出保存。
## 4、操作实例
选取音乐“卢本伟语音包”，转换为wav格式导入，得到结果如下
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200423205724129.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjc5NTcz,size_16,color_FFFFFF,t_70)
添加白噪声后，此时播放音频能听到显著杂音。而从原始信号的频谱来看，初始音频的频率主要集中在0-1000Hz，因此我们可以选用低通滤波器，阻带开始频率设为1000Hz，选用矩形窗进行滤波，得到结果如下：![在这里插入图片描述](https://img-blog.csdnimg.cn/20200423210029364.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjc5NTcz,size_16,color_FFFFFF,t_70)
由于白噪声遍布于整个频谱，对于噪声频谱于音频频谱的重叠部分，我们无法通过FIR滤波器进行滤除，依然会有小部分杂音存在。若噪声为特定单一频率的噪声，我们可以较好地将其去除。对于该音频添加5000Hz的特定频率，通过设计带阻滤波器，阻带范围为4500-5500Hz对其进行滤波，如下图所示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200423210122656.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjc5NTcz,size_16,color_FFFFFF,t_70)
## 5、窗函数对比
仍选用上例中的5000Hz频率噪声，同时增加噪声幅度，如下图所示：![在这里插入图片描述](https://img-blog.csdnimg.cn/20200423210657818.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjc5NTcz,size_16,color_FFFFFF,t_70)
选用带阻滤波器，设置阻带范围4000-6000Hz，观察各窗函数对其滤波的效果。(每行从左到右分别是：矩形窗，三角窗，海明窗，汉宁窗，布莱克曼窗，凯塞窗，下同)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200423215240121.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjc5NTcz,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200423215535706.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyNjc5NTcz,size_16,color_FFFFFF,t_70)

该种情况下滤波效果的总体排序为：凯瑟窗>矩形窗>汉宁窗>海明窗=三角窗>布莱克曼窗。
## 6、声明
本项目是本人基于其他滤波GUI设计的二次开发，大部分内容均为原创，若有侵权请及时告知。

CSDN链接：https://blog.csdn.net/qq_42679573/article/details/105716092