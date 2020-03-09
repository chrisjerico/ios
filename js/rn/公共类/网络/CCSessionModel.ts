import { NativeModules } from "react-native";
import { object } from "prop-types";
import { promises, Resolver } from "dns";
import AppDefine from "../AppDefine";

interface Dictionary {
  [x: string]: any;
}

interface ResponseObject {
  code: number;
  msg: string;
  data: any;
}

export default class CCSessionModel {
  static isEncrypt = true; // 参数是否加密
  static publicParams = {
    // 公共参数
    // able: "123"
  };

  // 参数加密
  static encryptParams(params: Dictionary): Promise<Dictionary> {
    if (!this.isEncrypt) {
      return new Promise(resolve => resolve(params));
    }
    var temp = Object.assign({}, params);
    temp["checkSign"] = 1;

    console.log("开始加密");
    return AppDefine.ocCall("CMNetwork.encryptionCheckSign:", [temp]);
  }

  // 发起请求
  static req(path: string, params: object = {}, isPost: boolean = false): Promise<any> {
    var url = `${AppDefine.host}/wjapp/api.php?${path}`;
    return this.request(url, params, isPost);
  }

  static request(url: string, params: object = {}, isPost: boolean = false): Promise<any> {
    // 添加公共参数
    params = Object.assign({}, this.publicParams, params);

    // 参数加密
    var promise = this.encryptParams(params)
      .then((params: Dictionary) => {
        if (this.isEncrypt) {
          url += "&checkSign=1";
        }

        // 若是GET请求则拼接参数到URL
        if (!isPost) {
          Object.keys(params).map(key => {
            var value = params[key];
            url += `&${key}=${value}`;
          });
          params = null;
        }

        console.log("url = " + url);
        console.log("发起请求B");
        return fetch(url, {
          method: isPost ? "POST" : "GET",
          body: params ? JSON.stringify(params) : null,
          headers: new Headers({
            "Content-Type": "application/json"
          })
        })
          .then(function(response) {
            // 检查是否正常返回
            if (response.ok) {
              // 返回的是一个promise对象, 值就是后端返回的数据, 调用then()可以接收
              console.log("req succ!");
              return response.json();
            }
            throw new Error("请求失败：" + response.statusText);
          })
          .then((responseObject: ResponseObject) => {
            if (responseObject.code != 0) {
              throw new Error(responseObject.msg);
            }
            return Promise.resolve(responseObject.data);
          });
      })
      .catch(err => {
        console.log("请求失败， err = ");
        console.log(err);
        // rejects(err);
      });
    return promise;
  }
}
