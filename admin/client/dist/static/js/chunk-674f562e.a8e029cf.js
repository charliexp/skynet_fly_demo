(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-674f562e"],{"2b0c":function(t,e,a){"use strict";a("eb49")},9406:function(t,e,a){"use strict";a.r(e);var n=function(){var t=this,e=t._self._c;return e("div",{staticClass:"dashboard-container"},[e("online-monitor")],1)},i=[],r=a("5530"),s=a("2f62"),o=function(){var t=this,e=t._self._c;return e("div",{staticClass:".onlinemonitor-container"},[e("panel-group",{on:{handleSetLineChartData:t.handleSetLineChartData,handleNotData:t.handleNotData}}),e("el-row",{staticStyle:{background:"#fff",padding:"16px 16px 0","margin-bottom":"32px"}},[e("line-chart",{attrs:{"chart-data":t.lineChartData,"is-notdata":t.isNotData}})],1)],1)},l=[],c=function(){var t=this,e=t._self._c;return e("div",[e("el-select",{attrs:{placeholder:"请选择哪天"},model:{value:t.pre_day,callback:function(e){t.pre_day=e},expression:"pre_day"}},t._l(t.dayOption,(function(t){return e("el-option",{key:t.value,attrs:{label:t.label,value:t.value}})})),1),e("el-select",{attrs:{placeholder:"请选择服务名"},model:{value:t.svr_name,callback:function(e){t.svr_name=e},expression:"svr_name"}},t._l(t.svrNameList,(function(t,a){return e("el-option",{key:a,attrs:{label:t,value:t}})})),1),e("el-select",{attrs:{placeholder:"请选择数据标签"},model:{value:t.tag,callback:function(e){t.tag=e},expression:"tag"}},t._l(t.tagList,(function(t,a){return e("el-option",{key:a,attrs:{label:t,value:t}})})),1)],1)},d=[],h=a("c7eb"),u=a("1da1"),f=a("b775");function p(){return Object(f["a"])({url:"/dashboard/node_map",method:"get"})}function v(t,e,a){return Object(f["a"])({url:"/dashboard/online_record",method:"get",params:{svr_name:t,pre_day:e,tag:a}})}var b=[{value:0,label:"当天"},{value:1,label:"昨天"},{value:2,label:"前天"},{value:3,label:"前第三天"},{value:4,label:"前第四天"},{value:5,label:"前第五天"},{value:6,label:"前第六天"},{value:7,label:"前第七天"}],m={data:function(){return{pre_day:0,svr_name:"hallserver",tag:"online",dayOption:b,svrNameList:[],tagList:[],nodeMap:{}}},created:function(){this.getsvrNameList(),this.handleSetLine()},watch:{svr_name:{handler:function(t){this.setTagList(t),this.handleSetLine()}},tag:{handler:function(t){this.handleSetLine()}},pre_day:{handler:function(t){this.handleSetLine()}}},methods:{setTagList:function(t){if(this.nodeMap[t]){var e=this.nodeMap[t];for(var a in this.tagList=[],e)this.tagList.push(a)}},getsvrNameList:function(){var t=this;return Object(u["a"])(Object(h["a"])().mark((function e(){var a,n;return Object(h["a"])().wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,p();case 2:for(n in a=e.sent,console.log("getsvrNameList>>>",a),t.svrNameList=[],t.nodeMap=a.data.node_map,t.nodeMap)t.svrNameList.push(n);t.setTagList(t.svr_name);case 8:case"end":return e.stop()}}),e)})))()},getOnlineRecord:function(){var t=this;return Object(u["a"])(Object(h["a"])().mark((function e(){var a,n,i,r,s,o,l,c,d,u;return Object(h["a"])().wrap((function(e){while(1)switch(e.prev=e.next){case 0:return e.next=2,v(t.svr_name,t.pre_day,t.tag);case 2:if(a=e.sent,n=a.data,console.log("getOnlineRecord>> ",n),"OK"==n.result){e.next=8;break}return t.$emit("handleNotData"),e.abrupt("return");case 8:for(n=n.data,i=[],r={},s=0;s<n.length;s++)for(l in o=n[s],o)for(d in i.push(l),c=n[s][l],c)u=c[d],r[d]||(r[d]=[]),r[d].push(u);console.log("opts:",r),t.$emit("handleSetLineChartData",{time:i,opts:r},t.svr_name,t.pre_day);case 14:case"end":return e.stop()}}),e)})))()},handleSetLine:function(){this.svr_name&&this.tag&&this.getOnlineRecord()}}},F=m,_=a("2877"),D=Object(_["a"])(F,c,d,!1,null,null,null),g=D.exports,E=a("e702"),y={components:{PanelGroup:g,LineChart:E["a"]},data:function(){return{lineChartData:{},svr_name:null,isNotData:!0,isCurDay:!1}},methods:{handleSetLineChartData:function(t,e,a){console.log("handleSetLineChartData:",t,e),this.lineChartData=t,this.svr_name=e,this.isNotData=!1,this.isCurDay=0==a},handleNotData:function(){console.log("没有数据>>>>>"),this.isNotData=!0}}},C=y,w=(a("2b0c"),Object(_["a"])(C,o,l,!1,null,"6a6c6b3f",null)),B=w.exports,L={name:"Dashboard",components:{onlineMonitor:B},data:function(){return{}},computed:Object(r["a"])({},Object(s["b"])([]))},$=L,O=Object(_["a"])($,n,i,!1,null,null,null);e["default"]=O.exports},e702:function(t,e,a){"use strict";var n=function(){var t=this,e=t._self._c;return t.isNotdata?e("div",{style:{height:t.height,width:t.width}},[t._v("暂无数据")]):e("div",{class:t.className,style:{height:t.height,width:t.width}})},i=[],r=a("313e"),s=a.n(r),o=a("ed08"),l={data:function(){return{$_sidebarElm:null,$_resizeHandler:null}},mounted:function(){var t=this;this.$_resizeHandler=Object(o["a"])((function(){t.chart&&t.chart.resize()}),100),this.$_initResizeEvent(),this.$_initSidebarResizeEvent()},beforeDestroy:function(){this.$_destroyResizeEvent(),this.$_destroySidebarResizeEvent()},activated:function(){this.$_initResizeEvent(),this.$_initSidebarResizeEvent()},deactivated:function(){this.$_destroyResizeEvent(),this.$_destroySidebarResizeEvent()},methods:{$_initResizeEvent:function(){window.addEventListener("resize",this.$_resizeHandler)},$_destroyResizeEvent:function(){window.removeEventListener("resize",this.$_resizeHandler)},$_sidebarResizeHandler:function(t){"width"===t.propertyName&&this.$_resizeHandler()},$_initSidebarResizeEvent:function(){this.$_sidebarElm=document.getElementsByClassName("sidebar-container")[0],this.$_sidebarElm&&this.$_sidebarElm.addEventListener("transitionend",this.$_sidebarResizeHandler)},$_destroySidebarResizeEvent:function(){this.$_sidebarElm&&this.$_sidebarElm.removeEventListener("transitionend",this.$_sidebarResizeHandler)}}};a("817d");var c=["#70DB93","#5C3317","#9F5F9F","#B5A642","#8C7853","#A67D3D","#5F9F9F","#D98719","#B87333","#FF7F00","#42426F","#2F4F2F","#4A766E","#4F4F2F","#9932CD","#871F78","#6B238E","#2F4F4F","#97694F","#7093DB","#855E42","#545454","#856363","#238E23","#CD7F32","#527F76","#93DB70","#215E21","#4E2F2F","#C0D9D9","#9F9F5F","#A8A8A8","#8F8FBD","#E9C2A6","#32CD32","#E47833","#8E236B","#32CD99","#3232CD","#6B8E23","#EAEAAE","#9370DB","#426F42","#7F00FF","#7FFF00","#70DBDB","#DB7093","#A68064","#2F2F4F","#23238E","#4D4DFF","#FF6EC7","#EBC79E","#CFB53B","#FF7F00","#FF2400","#DB70DB","#8FBC8F","#BC8F8F","#EAADEA","#D9D9F3","#5959AB","#6F4242","#BC1717","#238E68","#6B4226","#8E6B23","#E6E8FA","#3299CC","#007FFF","#FF1CAE","#00FF7F","#236B8E","#38B0DE","#D8BFD8","#ADEAEA","#5C4033","#CDCDCD","#4F2F4F","#CC3299","#D8D8BF","#99CC32"],d={mixins:[l],props:{className:{type:String,default:"chart"},width:{type:String,default:"100%"},height:{type:String,default:"450px"},autoResize:{type:Boolean,default:!0},chartData:{type:Object,required:!0},isNotdata:{tpye:Boolean,default:!0}},data:function(){return{chart:null}},watch:{chartData:{deep:!0,handler:function(t){console.log("handler>>>",t),this.setOptions(t)}},isNotdata:{handler:function(t){if(console.log("isNotdata:",this.isNotdata,t),this.isNotdata){if(!this.chart)return;this.chart.dispose(),this.chart=null}}}},mounted:function(){},beforeDestroy:function(){this.chart&&(this.chart.dispose(),this.chart=null)},methods:{resetChart:function(){this.chart?(this.chart.dispose(),this.chart=null,this.chart=s.a.init(this.$el,"macarons")):this.chart=s.a.init(this.$el,"macarons")},setOptions:function(){var t=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{},e=t.time,a=t.opts;if(e&&!(e.length<=0)){this.resetChart(),console.log("ddd",a,this.isNotdata);var n={xAxis:{data:e,boundaryGap:!1,axisTick:{show:!1}},grid:{left:10,right:10,bottom:20,top:30,containLabel:!0},tooltip:{trigger:"axis",axisPointer:{type:"cross"},padding:[5,10]},yAxis:{axisTick:{show:!1}},legend:{data:[]},series:[]},i=0;for(var r in a){var s=a[r],o=c[i];n.legend.data.push(r),n.series.push({name:r,smooth:!0,type:"line",data:s,animationDuration:2800,animationEasing:"quadraticOut",itemStyle:{normal:{color:o,lineStyle:{color:o,width:2}}}}),i++,i%=c.length}this.chart.setOption(n)}}}},h=d,u=a("2877"),f=Object(u["a"])(h,n,i,!1,null,null,null);e["a"]=f.exports},eb49:function(t,e,a){},ed08:function(t,e,a){"use strict";a.d(e,"a",(function(){return i})),a.d(e,"b",(function(){return r}));var n=a("53ca");a("ac1f"),a("00b4"),a("5319"),a("4d63"),a("2c3e"),a("25f0"),a("d3b7"),a("4d90"),a("a15b"),a("d81d"),a("b64b"),a("159b"),a("fb6a"),a("a630"),a("3ca3"),a("6062"),a("ddb0"),a("466d");function i(t,e,a){var n,i,r,s,o,l=function l(){var c=+new Date-s;c<e&&c>0?n=setTimeout(l,e-c):(n=null,a||(o=t.apply(r,i),n||(r=i=null)))};return function(){for(var i=arguments.length,c=new Array(i),d=0;d<i;d++)c[d]=arguments[d];r=this,s=+new Date;var h=a&&!n;return n||(n=setTimeout(l,e)),h&&(o=t.apply(r,c),r=c=null),o}}function r(t){if(!t&&"object"!==Object(n["a"])(t))throw new Error("error arguments","deepClone");var e=t.constructor===Array?[]:{};return Object.keys(t).forEach((function(a){t[a]&&"object"===Object(n["a"])(t[a])?e[a]=r(t[a]):e[a]=t[a]})),e}}}]);