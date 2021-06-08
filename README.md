# react-native-dsphoto-module

DSphoto Wrapper

## Installation

```sh
npm install react-native-dsphoto-module
```

## Usage

```js
import DsphotoModule from "react-native-dsphoto-module";

// ...

DsphotoModule.Edit(photo.path, (res) => {
            console.log(`editor-path: ${res}`);
          },
          (error) => {
            console.log(`action: ${error} `);
          })
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
