import objectPath from 'object-path';

export default class FPrototypes {
  static setupAll() {
    this.setupArray();
    this.setupString();
  }

  static setupArray() {
    // 根据keyPath值获取元素
    Array.prototype.objectWithValue = function(value: any, keyPath: string): any {
      if (!value) {
        return null;
      }
      for (var idx in this) {
        var ele = this[idx];
        if (objectPath.get(ele, keyPath) === value) {
          return ele;
        }
      }
      return null;
    };
  }

  static setupString() {
    // 包含数字
    String.prototype.hasNumber = function(): boolean {
      return /\d/.test(this);
    };

    // 包含浮点数
    String.prototype.hasFloat = function(): boolean {
      return /\d\./.test(this);
    };

    // 包含ASCII码
    String.prototype.hasASCII = function(): boolean {
      return /[\x00-\xFF]/.test(this);
    };

    // 包含中文
    String.prototype.hasChinese = function(): boolean {
      return /[\u4e00-\u9fff]/.test(this);
    };

    // 包含字母
    String.prototype.hasLetter = function(): boolean {
      return /[A-Za-z]/.test(this);
    };

    // 包含小写字母
    String.prototype.hasLowercaseLetter = function(): boolean {
      return /[a-z]/.test(this);
    };

    // 包含大写字母
    String.prototype.hasUppercaseLetter = function(): boolean {
      return /[A-Z]/.test(this);
    };

    // 包含特殊字符
    String.prototype.hasSpecialCharacter = function(): boolean {
      return /[^\da-zA-Z\u4e00-\u9fff]/.test(this);
    };

    // 含有html标签的检测
    String.prototype.hasHTML = function(): boolean {
      return /<[^>]+>/.test(this);
    };

    // 数字
    String.prototype.isNumber = function(): boolean {
      return /^[+-]?((\d*\.?\d+)|(\d+\.?\d*))$/.test(this);
    };

    // 浮点数
    String.prototype.isFloat = function(): boolean {
      return /^[+-]?((\d*\.\d+)|(\d+\.\d*))$/.test(this);
    };

    // 整数
    String.prototype.isInteger = function(): boolean {
      return /^-?\d+$/.test(this);
    };

    // 纯ASCII码
    String.prototype.isASCII = function(): boolean {
      return /^[\x00-\xFF]+$/.test(this);
    };

    // 纯中文
    String.prototype.isChinese = function(): boolean {
      return /^[\u4e00-\u9fff]+$/.test(this);
    };

    // 纯字母
    String.prototype.isLetter = function(): boolean {
      return /^[A-Za-z]+$/.test(this);
    };

    // 纯小写字母
    String.prototype.isLowercaseLetter = function(): boolean {
      return /^[a-z]+$/.test(this);
    };

    // 纯大写字母
    String.prototype.isUppercaseLetter = function(): boolean {
      return /^[A-Z]+$/.test(this);
    };

    // 纯特殊字符
    String.prototype.isSpecialCharacter = function(): boolean {
      return /^[^\da-zA-Z\u4e00-\u9fff]+$/.test(this);
    };

    // Email
    String.prototype.isEmail = function(): boolean {
      return /^(([^<>()\[\]\\.,;:\s@\"]+(\.[^<>()\[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(this);
    };

    // 手机号码
    String.prototype.isMobile = function(): boolean {
      return /^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\d{8}$/.test(this);
    };

    // 身份证号码
    String.prototype.isIDCardNumber = function(): boolean {
      return /^1$/.test(this);
    };

    // URL
    String.prototype.isURL = function(): boolean {
      return false;
      // return /^((/)[^/]|[a-z]{3,6}://([0-9a-zA-Z-]+\.){1,}[0-9a-zA-Z-]+([/]|$))/.test(this);
    };

    // 是否为空
    String.prototype.isNull = function(): boolean {
      return /^1$/.test(this);
    };

    // 16进制颜色
    String.prototype.isHexColor = function(): boolean {
      return /^(#|0x)?([0-9a-fA-F]{3}){1,2}$/.test(this);
    };

    // IP地址
    String.prototype.isIP = function(): boolean {
      return /^1$/.test(this);
    };

    // IPv4地址
    String.prototype.isIPv4 = function(): boolean {
      return /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/.test(this);
    };

    // IPv6地址
    String.prototype.isIPv6 = function(): boolean {
      return /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){5}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/.test(this);
    };
  }
}
