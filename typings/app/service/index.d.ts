// This file is created by egg-ts-helper@1.35.1
// Do not modify this file!!!!!!!!!
/* eslint-disable */

import 'egg';
type AnyClass = new (...args: any[]) => any;
type AnyFunc<T = any> = (...args: any[]) => T;
type CanExportFunc = AnyFunc<Promise<any>> | AnyFunc<IterableIterator<any>>;
type AutoInstanceType<T, U = T extends CanExportFunc ? T : T extends AnyFunc ? ReturnType<T> : T> = U extends AnyClass ? InstanceType<U> : U;
import ExportBigdata = require('../../../app/service/bigdata');
import ExportRole = require('../../../app/service/role');

declare module 'egg' {
  interface IService {
    bigdata: AutoInstanceType<typeof ExportBigdata>;
    role: AutoInstanceType<typeof ExportRole>;
  }
}
