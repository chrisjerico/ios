import UpdateVersion from "./js/rn/UpdateVersion";
import React, { Component } from "react";
import { AppRegistry, View } from "react-native";

export default class AAA extends Component {
  render() {
    return <View />;
  }
}

AppRegistry.registerComponent("Demo", () => AAA);
AppRegistry.registerComponent("UpdateVersion", () => UpdateVersion);
