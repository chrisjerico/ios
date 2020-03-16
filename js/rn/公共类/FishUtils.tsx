import {ViewProps} from 'react-native';

export default class FUtils {
  static props_merge(defaultProps: ViewProps, props: ViewProps): any {
    var retProps = Object.assign({}, defaultProps);
    for (var k in props) {
      if (k.toLowerCase().indexOf('style') != -1) {
        var style: Array<{[x: string]: any}> | {[x: string]: any} = retProps[k];
        if (!style) {
          style = props[k];
        } else if (style instanceof Array) {
          style.push(props[k]);
        } else {
          style = [style, props[k]];
        }
        retProps[k] = style;
      } else {
        retProps[k] = props[k];
      }
    }
    return retProps;
  }
}
