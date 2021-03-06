## 同步演示demo

使用 [pixi.js](http://www.pixijs.com/) 做的一个演示.

延迟使用 [tc命令](https://wiki.linuxfoundation.org/networking/netem) 设置

<img src="http://77fm2e.com1.z0.glb.clouddn.com/tongbu2.gif" width="500">

速度在 100，200，300 之间变化

1.  0延迟
2.  80 ~ 120ms 延迟
3.  160 ~ 240ms 延迟


#### 同步包结构:

*   t: 加上延迟的服务器时间
*   x: t时间物体的 位置x
*   y: t时间物体的 位置y
*   vx: 当前物体的 x方向的运动矢量 （包括速度信息）
*   vy: 当前物体的 y方向的运动矢量 （包括速度信息）
*   delay: 当前延迟 (单向)

如果物体是在移动中，那么 t+=1000ms， 表示t是 一秒后。这样 x, y 也都是一秒后的位置。

如果物体静止，那么 t 不做处理， 就是当前时间。 这样客户端在收到静止的同步包后，会立即把物体拉扯到 x,y的位置，不会出现前移然后回退.


#### 同步处理

客户端收到同步包后
首先比较 服务器时间（加上延迟） now 和 t 的大小关系。

如果 now >= t, 说明这个同步包因为延迟，来晚了。直接把物体拉倒 x,y的位置

如果 now < t, 说明物体要在 (t-now) 的时间内 移动到 x,y.  算出速度，开始移动。  当移动到 x,t 后再把速度恢复到 正常的 vx, vy.

