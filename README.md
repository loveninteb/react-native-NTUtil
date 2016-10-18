# react-native-NTUtil

安装：  
  `npm install react-native-ntutil`  
  `rnpm link react-native-ntutil`  
 
Android 添加:  
  `找到getPackages方法所在的类`    
  `头部添加import com.NTUtil.NTUtilPackage;`   
  `getPackages 方法里添加 new NTUtilPackage()(如下)`  
  `@Override`   
    `protected List<ReactPackage> getPackages() {` 
      `return Arrays.<ReactPackage>asList(`  
         `new MainReactPackage(),`  
         `new NTUtilPackage()`  
      `);`  
    `}`  

js 使用  
  `const ANDROIDModule = NativeModules.NTUtilModule;`   
  `//android toast 提示框`  
  `ANDROIDModule.showToast("toast提示框",0);`  
  `//短信发送`  
  `ANDROIDModule.sendMsg("电话号码"," 短信内容");`  
  `//电话拨打`  
  `ANDROIDModule.call("电话号码");`  
  `//剪切板`  
  `ANDROIDModule.copyText("这是复制文本的");`  
  `//判断网络类型  2g/3g/4g/wifi`  
  `ANDROIDModule.judgeNetType((e)=>{alert(e)});`  
  `//判断网络状态 true可用`  
  `ANDROIDModule.isNetworkAvailable((e)=>{alert(e)});`  
  `//判断是否是debug版本 true是debug`  
  `ANDROIDModule.judgeIsDebug((e)=>{alert(e)});`  
  `//添加联系人`  
  `ANDROIDModule.addContact("姓名 ",["电话号码1","电话号码2","110"],"备注");`  
  `//删除联系人`  
  `ANDROIDModule.deleteContact("姓名");`  
  `//查找联系人 true存在`  
  `ANDROIDModule.selectContact("姓名",(e)=>{alert(e)});`  
  `//导入联系人  e1为1,e2 联系人列表为null ;  e1为null,e2为联系人列表`  
  `ANDROIDModule.getContactList((e1,e2)=>{alert(e2)});`  
  `//保存图片 返回e为true，保存成功`  
  `ANDROIDModule.saveImage(["图片url1","图片url2"],(e)=>{alert(e)});`  
  `//清除cookie`  
  `ANDROIDModule.clearCookie();`  
    
  `//摇一摇`  
  `componentDidMount(){`  
    `//注册摇一摇监听`  
    `ANDROIDModule.registerShake();`  
  `}`
 
  `componentWillUnmount(){`  
    `//注销摇一摇监听`  
    `ANDROIDModule.unregisterShake();`  
  `}`  
  `//摇一摇reset`  
  `ANDROIDModule.shakeReset();`  
  `接受摇一摇事件:`  
  `DeviceEventEmitter.addListener('NTUtil',(e)=>{`  
    `switch(e.type){`  
      `case 4001:`  
       `//todosomeing`          
      `break;`  
    `}`  
  `});`  
 
  
  
