// import { View, Text, TouchableOpacity, StyleSheet } from "react-native";
import React, { Component } from "react";
import { Button } from "react-native-elements";
import { TouchableOpacity, Text } from "react-native";

// 下划线
export class UGLine extends Component {
  render() {
    return <View style={{ backgroundColor: "gray", height: 0.5 }} />;
  }
}

export class UGButton2 extends Component {
  render() {
    return <Button title="这是标题" />;
  }
}

export function UGButton() {
  return <Button title="这是标题" />;
}
// // label
// export class UGLabel extends Component<{ text: string }> {
//   render() {
//     return (
//       // <Button></Button>
//       <TouchableOpacity style={[{ justifyContent: "center" , overflow: 'hidden', borderRadius:20}]}>
//         <Text style={{flex: 1, backgroundColor:'blue'}}>{this.props.text}</Text>
//       </TouchableOpacity>
//     );
//   }
// }



