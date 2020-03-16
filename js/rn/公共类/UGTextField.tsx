import React, {Component} from 'react';
import {View, Text} from 'react-native';
import {Input, InputProps, Card, Icon, Button, IconNode} from 'react-native-elements';
import NetworkRequest1 from './网络/NetworkRequest1';
import FUtils from './FishUtils';

interface IPorps extends InputProps {
  // 父类变量
  placeholder?: string; // 占位文本
  defaultValue?: string; // 默认文本
  maxLength?: number; // 限制长度
  onChangeText?: (text: string) => void;

  // 自定义变量
  type?: '推荐人ID' | '账号' | '密码' | '确认密码' | '真实姓名' | '手机号' | '字母验证码' | '短信验证码' | '空';
  onlyNumbers?: boolean; // 仅数字
  onlyNumbersWithDecimals?: number; // 仅数字含小数
  onlyNumbersAndLetters?: boolean; // 仅数字加字母
  onlyVisibleASCII?: boolean; // 仅可见的ASCII
  additionalAllowedCharacters?: string; // 额外允许的字符
  forbiddenCharacters?: string; // 禁止的字符
}

interface IState {
  text: string; // 文本
}

export default class UGTextField extends Component<IPorps, IState> {
  newProps: IPorps; // 自定义props
  willRefreshCode: boolean = false; // 是否刷新验证码验证码

  constructor(props: IPorps) {
    super(props);
    this.state = {text: null};
    var iconSize = 20;

    var defaultProps: IPorps = {
      containerStyle: [{marginTop: 12, height: 46, backgroundColor: 'rgba(0, 0, 0, 0.6)', borderRadius: 23, overflow: 'hidden'}],
      inputStyle: {marginLeft: 8, height: 46, color: 'white', fontSize: 15},
      leftIconContainerStyle: {marginLeft: 6, width: iconSize, height: iconSize},
      placeholderTextColor: 'rgba(255, 255, 255, 0.3)',
      clearButtonMode: 'while-editing',
    };

    var input = React.createRef();

    var other = ((): IPorps => {
      switch (props.type) {
        case '推荐人ID':
          return {
            placeholder: '推荐人ID（选填）',
            leftIcon: {name: 'user', type: 'font-awesome', color: 'rgba(255, 255, 255, 0.6)', size: iconSize},
            keyboardType: 'number-pad',
            onlyNumbersAndLetters: true,
          };
        case '账号':
          return {
            placeholder: '请输入账号',
            leftIcon: {name: 'user', type: 'font-awesome', color: 'rgba(255, 255, 255, 0.6)', size: iconSize},
            keyboardType: 'email-address',
          };
        case '密码':
          return {
            placeholder: '请输入密码',
            leftIcon: {name: 'lock', type: 'material', color: 'rgba(255, 255, 255, 0.6)', size: iconSize},
            rightIcon: <Icon name="md-eye" type="ionicon" size={22} color="rgba(255, 255, 255, 0.3)" containerStyle={{marginLeft: 15, marginRight: 4}} onPress={() => {}} />,
            rightIconContainerStyle: {marginLeft: -6, marginRight: 3, height: iconSize},
            secureTextEntry: true,
            keyboardType: 'email-address',
            onlyVisibleASCII: true,
          };
        case '真实姓名':
          return {
            placeholder: '真实姓名',
            leftIcon: {name: 'user', type: 'font-awesome', color: 'rgba(255, 255, 255, 0.6)', size: iconSize},
          };
        case '手机号':
          return {
            placeholder: '手机号',
            leftIcon: {name: 'device-mobile', type: 'octicon', color: 'rgba(255, 255, 255, 0.6)', size: iconSize},
            keyboardType: 'phone-pad',
            onlyNumbers: true,
            additionalAllowedCharacters: '+',
          };
        case '字母验证码':
          return {
            placeholder: '验证码',
            keyboardType: 'email-address',
            onlyNumbersAndLetters: true,
            leftIcon: {name: 'Safety', type: 'antdesign', color: 'rgba(255, 255, 255, 0.6)', size: iconSize},
            rightIcon: this.renderLetterVerificationCode(),
          };
        case '短信验证码':
          return {
            placeholder: '验证码',
            keyboardType: 'email-address',
            onlyNumbersAndLetters: true,
            leftIcon: {name: 'Safety', type: 'antdesign', color: 'rgba(255, 255, 255, 0.6)', size: iconSize},
            rightIcon: <Button title="发送验证码" buttonStyle={{marginRight: 3, backgroundColor: 'rgba(255, 255, 255, 0.3)'}} titleStyle={{fontSize: 11}} />,
          };
        default:
          return {};
      }
    })();

    this.newProps = FUtils.props_merge(FUtils.props_merge(defaultProps, other), props);
  }

  renderLetterVerificationCode() {
    var code = '';
    var codeLength = 4; //验证码的长度，可变
    var selectChar = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
    for (var i = 0; i < codeLength; i++) {
      var charIndex = Math.floor(Math.random() * selectChar.length);
      code += selectChar[charIndex];
    }
    return (
      <Text
        style={{
          color: 'white',
          backgroundColor: 'rgba(255, 255, 255, 0.3)',
          paddingVertical: 6.5,
          paddingLeft: 12,
          paddingRight: 8,
          borderRadius: 8,
          overflow: 'hidden',
          fontWeight: '600',
          fontStyle: 'italic',
          letterSpacing: 3,
          marginRight: 3,
        }}
        onPress={() => {
          this.willRefreshCode = true;
          this.setState({});
        }}>
        {code}
      </Text>
    );
  }

  render() {
    if (this.props.type === '字母验证码' && this.willRefreshCode) {
      this.willRefreshCode = false;
      this.newProps.rightIcon = this.renderLetterVerificationCode();
    }

    return (
      <Input
        {...this.newProps}
        value={this.state.text ?? null}
        clearTextOnFocus
        onChangeText={text => {
          console.log(text);
          var {onlyNumbers, onlyNumbersWithDecimals, onlyNumbersAndLetters, onlyVisibleASCII, additionalAllowedCharacters: chars = '', forbiddenCharacters} = this.newProps;

          // 禁用指定字符
          if (forbiddenCharacters) {
            text = text.replace(new RegExp(`[${forbiddenCharacters}]+`), '');
          }
          var reg: string = null;
          // 仅数字
          if (onlyNumbers) {
            reg = `[0-9${chars}]*`;
          }
          // 仅数字含小数
          else if (onlyNumbersWithDecimals) {
            text = text.match(new RegExp(`[0-9.${chars}]*`, 'g'))?.join('') ?? '';
            reg = `^[0-9]*[.]?[0-9${chars}]{0,${onlyNumbersWithDecimals}}`;
          }
          // 仅数字加字母
          else if (onlyNumbersAndLetters) {
            reg = `[0-9A-Za-z${chars}]*`;
          }
          // 仅可见的ASCII码
          else if (onlyVisibleASCII) {
            reg = `[\x20-\x7E${chars}]*`;
          }
          if (reg) {
            text = text.match(new RegExp(reg, 'g'))?.join('') ?? '';
          }
          this.setState({text: text});

          // 回调
          this.props.onChangeText && this.props.onChangeText(text);
        }}
      />
    );
  }
}
