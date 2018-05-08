﻿!(function(window,document){function na_verify(options){this.options={id:"",canvasId:"verifyCanvas",width:"150",height:"35",type:"blend",code:""}
if(Object.prototype.toString.call(options)=="[object Object]"){for(var i in options){this.options[i]=options[i];}}else{this.options.id=options;}
this.options.numArr="0,1,2,3,4,5,6,7,8,9".split(",");this.options.letterArr=getAllLetter();this._init();this.refresh();}
na_verify.prototype={version:'1.0.0',_init:function(){var con=document.getElementById(this.options.id);var canvas=document.createElement("canvas");this.options.width=con.offsetWidth>0?con.offsetWidth:"150";this.options.height=con.offsetHeight>0?con.offsetHeight:"35";canvas.id=this.options.canvasId;canvas.width=this.options.width;canvas.height=this.options.height;canvas.innerHTML=vCanvasMsg;con.appendChild(canvas);},refresh:function(){this.options.code="";var canvas=document.getElementById(this.options.canvasId);if(canvas.getContext){var ctx=canvas.getContext('2d');}else{return;}
ctx.textBaseline="middle";ctx.fillStyle=randomColor(200,250);ctx.fillRect(0,0,this.options.width,this.options.height);if(this.options.type=="blend"){var txtArr=this.options.numArr.concat(this.options.letterArr);}else if(this.options.type=="number"){var txtArr=this.options.numArr;}else{var txtArr=this.options.letterArr;}
for(var i=1;i<=4;i++){var txt=txtArr[randomNum(0,txtArr.length)];this.options.code+=txt;ctx.font=randomNum((this.options.height-5),this.options.height)+'px SimHei';ctx.fillStyle=randomColor(40,150);ctx.shadowOffsetX=randomNum(-2,2);ctx.shadowOffsetY=randomNum(-2,2);ctx.shadowBlur=randomNum(-2,2);ctx.shadowColor="rgba(0, 0, 0, 0.2)";var x=this.options.width/5*i;var y=this.options.height/2;var deg=randomNum(-20,20);ctx.translate(x,y);ctx.rotate(deg*Math.PI/180);ctx.fillText(txt,0,0);ctx.rotate(-deg*Math.PI/180);ctx.translate(-x,-y);}
for(var i=0;i<1;i++){ctx.strokeStyle=randomColor(60,190);ctx.beginPath();ctx.moveTo(randomNum(0,this.options.width),randomNum(0,this.options.height));ctx.lineTo(randomNum(0,this.options.width),randomNum(0,this.options.height));ctx.stroke();}
for(var i=0;i<this.options.width/6;i++){ctx.fillStyle=randomColor(0,255);ctx.beginPath();ctx.arc(randomNum(0,this.options.width),randomNum(0,this.options.height),1,0,2*Math.PI);ctx.fill();}},validate:function(code){var v_code=this.options.code;if(code==v_code){return true;}else{this.refresh();return false;}}}
function getAllLetter(){var letterStr="1,2,3,4,5,6,7,8,9,0,a,c,d,e,f,g,h,i,j,k,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,J,K,L,M,N,P,Q,R,S,T,U,V,W,X,Y,Z";return letterStr.split(",");}
function randomNum(min,max){return Math.floor(Math.random()*(max-min)+min);}
function randomColor(min,max){var r=randomNum(min,max);var g=randomNum(min,max);var b=randomNum(min,max);return"rgb("+r+","+g+","+b+")";}
window.na_verify=na_verify;})(window,document);
function GetNavLang(){var userLang=navigator.language||navigator.userLanguage;var ReturnLang;switch(userLang){case'zh':case'zh-tw':case'zh-TW':ReturnLang="ZH";break;case'en':case'en-US':ReturnLang="EN";break;default:ReturnLang="OT";break;}
return ReturnLang;}
var NavLang=GetNavLang();if(NavLang=="ZH"){var vVerifyCode="驗證碼:&nbsp;";var vVCodeExpired="圖形驗證碼已過期!";var vVCodeError="驗證碼輸入錯誤!<br>(驗證碼有區分大小寫)";var vEnterVerify="請輸入驗證碼";var vCanvasMsg="您的瀏覽器版本不支援canvas";var vVerifyTimeout="驗證碼過期(超過60秒),<br>請按下更新圖示重新產生驗證碼";var vWaitRelogin="請等待登入Router, 剩餘 ";var vSecond=" 秒!";}else{var vVerifyCode="Verify Code:&nbsp;";var vVCodeExpired="The verify code has Expired.";var vVCodeError="The verify code error.";var vChangeRoute="Are you sure you want to change the default gateway ?";var vEnterVerify="Enter Verify Code";var vCanvasMsg="Your browser does not support HTML5 Canvas.";var vVerifyTimeout="Please login within 60 second.<br>Press refresh icon for login again."
var vWaitRelogin="You can relogin your router in ";var vSecond=" seconds.";}