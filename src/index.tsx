import { NativeModules } from 'react-native';

type DsphotoModuleType = {
  multiply(a: number, b: number): Promise<number>;
};

const { DsphotoModule } = NativeModules;

export default DsphotoModule as DsphotoModuleType;
