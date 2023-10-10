// This file is created by egg-ts-helper@1.35.1
// Do not modify this file!!!!!!!!!
/* eslint-disable */

import 'egg';
import ExportBigdata = require('../../../app/controller/bigdata');
import ExportRole = require('../../../app/controller/role');
import ExportUpload = require('../../../app/controller/upload');

declare module 'egg' {
  interface IController {
    bigdata: ExportBigdata;
    role: ExportRole;
    upload: ExportUpload;
  }
}
