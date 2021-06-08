//import * as React from 'react';
import React, {Component} from 'react';

import { StyleSheet, Text,TouchableOpacity, View, Button } from 'react-native';
import ImagePicker from "react-native-image-crop-picker"
import RNFS from 'react-native-fs'
import DsphotoModule from 'react-native-dsphoto-module';
//const { DsphotoModule } = NativeModules;

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();
  return (
    <View style={styles.container}>
      <Button
        title='ImageEditors'
        onPress={() => ImagePicker.openPicker({
          mediaType: 'photo',
        }).then((photo) => {
          console.log('path:',photo.path)
          /*const tempDest = RNFS.DocumentDirectoryPath + "/editortemp.png";
          console.log('temppath:',tempDest);
          RNFS.moveFile(photo.path, tempDest)
          .then(() => RNFS.scanFile(tempDest));*/
          DsphotoModule.Edit(photo.path, (res) => {
            console.log(`editor-path: ${res}`);
          },
          (error) => {
            console.log(`action: ${error} `);
          })
          
          
        })}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  existingUserBtn: {
    backgroundColor: '#34b9ae',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
