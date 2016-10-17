# react-native-NTUtil

安装：  
  npm install react-native-ntutil <br />
  rnpm link react-native-ntutil  <br />
<br /> <br />
Android 添加   <br />
  找到getPackages方法所在的类，添加  <br />
  import com.NTUtil.NTUtilPackage; <br />
  @Override <br />
    protected List<ReactPackage> getPackages() { <br />
      return Arrays.<ReactPackage>asList(<br />
          new MainReactPackage(),<br />
              new NTUtilPackage()<br />
      );<br />
    }<br />
<br /> 
js 使用 <br />
  const ANDROIDModule = NativeModules.NTUtilModule; <br />
  //android toast 提示框  <br />
  ANDROIDModule.showToast("toast提示框",0);<br />
  //短信发送<br />
  ANDROIDModule.sendMsg("电话号码"," 短信内容");<br />
  //电话拨打<br />
  ANDROIDModule.call("电话号码");<br />
  //剪切板<br />
  ANDROIDModule.copyText("这是复制文本的");<br />
  //判断网络类型  2g/3g/4g/wifi<br />
  ANDROIDModule.judgeNetType((e)=>{alert(e)});<br />
  //判断网络状态 true可用<br />
  ANDROIDModule.isNetworkAvailable((e)=>{alert(e)});<br />
  //判断是否是debug版本 true是debug<br />
  ANDROIDModule.judgeIsDebug((e)=>{alert(e)});<br />
  //添加联系人 <br />
  ANDROIDModule.addContact("姓名 ",["电话号码1","电话号码2","110"],"备注");<br />
  //删除联系人<br />
  ANDROIDModule.deleteContact("姓名");<br />
  //查找联系人 true存在<br />
  ANDROIDModule.selectContact("姓名",(e)=>{alert(e)});<br />
  //导入联系人  e1为1,e2 联系人列表为null ;  e1为null,e2为联系人列表<br />
  ANDROIDModule.getContactList((e1,e2)=>{alert(e2)});<br />
  //保存图片 返回e为true，保存成功<br />
  ANDROIDModule.saveImage(["图片url1","图片url2"],(e)=>{alert(e)});<br />
  //清除cookie<br />
  ANDROIDModule.clearCookie();<br />
  <br /><br />
  //摇一摇<br />
  componentDidMount(){<br />
    //注册摇一摇监听<br />
    ANDROIDModule.registerShake();<br />
  }<br />
  <br />
  componentWillUnmount(){<br />
    //注销摇一摇监听<br />
    ANDROIDModule.unregisterShake();<br />
  }<br />
  //摇一摇reset<br />
  ANDROIDModule.shakeReset();<br />
  接受摇一摇事件:<br />
  DeviceEventEmitter.addListener('NTUtil',(e)=>{<br />
    switch(e.type){<br />
      case 4001:<br />
       //todosomeing        <br />
      break;<br />
    }<br />
  });<br />
  
  <br />
  
  
