const Service = require("egg").Service;

class BigDataService extends Service {
	/**
	 * 获取报表列表
	 * @param {*} query
	 * @returns
	 */
	getReportList(query) {
		const { pageNum, pageSize } = query;
		return new Promise(async (resolve, reject) => {
			try {
				let whereStr = `where reportType = ${query.reportType}`;
				if (query.startTime) {
					whereStr = `${whereStr} and createTime between ${query.startTime} and ${query.endTime}`;
				}
				if (query.keyword) {
					whereStr = `${whereStr} and reportName like '%${query.keyword}%'`;
				}
				whereStr = `${whereStr} order by createTime desc limit ${
					pageNum * pageSize
				},${pageSize}`;
				const list = await this.app.mysql.query(
					`select * from bigdata_period ${whereStr}`
				);
				const [{ "COUNT(*)": total }] = await this.app.mysql.query(
					`SELECT COUNT(*) from bigdata_period ${whereStr}`
				);
				resolve({
					list,
					total,
				});
			} catch (err) {
				reject(err);
			}
		});
	}

	uploadSql() {
		return new Promise((resolve, reject) => {
			const ftp = require("ftp");
			const client = new ftp();
			client.on("ready", function () {
				client.get("客户明细.sql", function (error, stream) {
					console.log(error);
				});
			});

			client.connect({
				host: "172.16.179.5",
				user: "htgl",
				password: "zaSFW5AfrerDm6eD",
			});
		});
	}

	async getSQL(query) {
		const { pageNum, pageSize } = query;
		let whereStr = "";
		if (query.keyword) {
			whereStr = `where sqlName like '%${query.keyword}%'`;
		}
		// return new Promise((resolve, reject) => {
		// 	const ftp = require("ftp");
		// 	const client = new ftp();
		// 	client.on("ready", function () {
		// 		client.list(function (err, list) {
		// 			if (err) throw err;
		// 			const result = list.map((i) => {
		// 				return {
		// 					...i,
		// 					name: Buffer.from(i.name, "latin1").toString("utf8"),
		// 				};
		// 			});
		// 			resolve(result.filter((i) => i.type === "-"));

		// 			client.end();
		// 		});
		// 	});

		// 	client.connect({
		// 		host: "172.16.179.5",
		// 		user: "htgl",
		// 		password: "zaSFW5AfrerDm6eD",
		// 	});
		// });
		return new Promise(async (resolve, reject) => {
			const sqlStr = `select * from common_sql ${whereStr} order by createTime desc`;
			const [{ "COUNT(*)": total }] = await this.app.mysql.query(
				`SELECT COUNT(*) from common_sql ${whereStr}`
			);
			const list = await this.app.mysql.query(sqlStr);
			resolve({
				list,
				total,
			});
		});
	}

	/**
	 * 创建任务
	 * @param {*} query
	 * @returns
	 */
	createTask(query) {
		return new Promise(async (resolve, reject) => {
			try {
				const result = await this.app.mysql.insert("report_list", {
					...query,
					createTime: new Date(),
					reportState: 0,
				});
				resolve({
					reportId: result.insertId,
				});
			} catch (e) {
				reject(e);
			}
		});
	}
	isEmptyObj(obj) {
		for (let key in obj) {
			if (key) {
				return false;
			}
		}
		return true;
	}

	handleQueryToSqlStr(rest, reportName) {
		let notEmptyParams = {};
		let whereStr = "";
		Object.keys(rest).map((i) => {
			if (rest[i] !== "") {
				notEmptyParams[i] = rest[i];
			}
		});
		Object.keys(notEmptyParams).map((i, index) => {
			if (index !== 0) {
				whereStr = whereStr + ` && ${i} = '${notEmptyParams[i]}'`;
			} else {
				whereStr = `WHERE ${i} = '${notEmptyParams[i]}'`;
			}
		});
		const commonSql = (key, val) => {
			return this.isEmptyObj(notEmptyParams)
				? `where ${key} like '%${val}%'`
				: `${whereStr} and ${key} like '%${val}%'`;
		};

		if (reportName) {
			whereStr = commonSql("reportName", reportName);
		}
		return whereStr;
	}

	/**
	 * 获取任务列表
	 * @returns
	 */
	getTaskList(query) {
		return new Promise(async (resolve, reject) => {
			try {
				const { pageNum, pageSize, reportName, ...rest } = query;
				let whereStr = this.handleQueryToSqlStr(rest, reportName);
				const sqlStr = `select * from report_list ${whereStr} order by createTime desc limit ${
					pageNum * pageSize
				},${pageSize}`;
				const list = await this.app.mysql.query(sqlStr);
				const [{ "COUNT(*)": total }] = await this.app.mysql.query(
					`SELECT COUNT(*) from report_list ${whereStr}`
				);
				resolve({
					list,
					total,
				});
			} catch (e) {
				reject(e);
			}
		});
	}

	/**
	 * 创建任务类型
	 * @param {*} query
	 * @returns
	 */
	createTaskType(query) {
		return new Promise(async (resolve, reject) => {
			try {
				const result = await this.app.mysql.insert("report_Type", {
					...query,

					createTime: new Date(),
				});
				resolve({
					reportTypeId: result.insertId,
				});
			} catch (e) {
				reject(e);
			}
		});
	}

	/**
	 * 增加sql语句
	 * @param {*} data
	 * @returns
	 */
	addSql(data) {
		return new Promise(async (resolve, reject) => {
			try {
				if (!data.reportId) {
					reject("没有任务id");
				} else {
					const result = await this.app.mysql.insert("report_sql", {
						...data,
						createTime: new Date(),
					});
					resolve({
						result,
					});
				}
			} catch (e) {
				reject(e);
			}
		});
	}

	/**
	 * 获取任务详情
	 * @param {*} query
	 * @returns
	 */
	getTaskDetail(query) {
		return new Promise(async (resolve, reject) => {
			try {
				const detail = await this.app.mysql.select("report_list", {
					where: {
						reportId: query.taskId,
					},
				});
				if (detail) {
					resolve(detail[0]);
				} else {
					reject();
				}
			} catch (e) {
				reject(e);
			}
		});
	}

	/**
	 * 获取任务类型
	 * @param {*} query
	 * @returns
	 */
	getReportType(query) {
		return new Promise(async (resolve, reject) => {
			try {
				const result = await this.app.mysql.select("report_Type", {
					where: {
						reportTypeId: query.reportTypeId,
					},
				});
				if (result) {
					resolve(result[0]);
				} else {
					reject();
				}
			} catch (e) {
				reject(e);
			}
		});
	}

	/**
	 * 更新任务
	 * @param {*} data
	 * @returns
	 */
	updateTask(data) {
		return new Promise(async (resolve, reject) => {
			try {
				await this.app.mysql.update("report_list", data, {
					where: {
						reportId: data.reportId,
					},
				});
				resolve();
			} catch (e) {
				reject(e);
			}
		});
	}

	/**
	 * 获取任务的sql语句
	 * @param {*} query
	 * @returns
	 */
	getTaskSqls(query) {
		return new Promise(async (resolve, reject) => {
			try {
				const result = await this.app.mysql.select("report_sql", {
					where: {
						reportId: query.taskId,
					},
				});
				resolve({
					taskSqls: result.length ? result : null,
				});
			} catch (e) {
				reject(e);
			}
		});
	}

	/**
	 * 删除一条任务
	 * @param {*} query
	 * @returns
	 */
	deleteTask(query) {
		return new Promise(async (resolve, reject) => {
			try {
				await this.app.mysql.delete("report_list", {
					reportId: query.reportId,
				});
				resolve();
			} catch (e) {
				reject(e);
			}
		});
	}

	addCommonSQL(data) {
		return new Promise(async (resolve, reject) => {
			try {
				await this.app.mysql.insert("common_sql", data);
				resolve();
			} catch (e) {
				reject(e);
			}
		});
	}

	/**
	 * 删除常用sql
	 * @returns
	 */
	deleteCommonSql(query) {
		return new Promise(async (resolve, reject) => {
			try {
				await this.app.mysql.delete("common_sql", {
					sqlId: query.sqlId,
				});
				resolve();
			} catch (e) {
				reject(e);
			}
		});
	}

	/**
	 * 更新常用sql
	 * @returns
	 */
	updateCommonsql(data) {
		return new Promise(async (resolve, reject) => {
			try {
				await this.app.mysql.update("common_sql", data, {
					where: {
						sqlId: data.sqlId,
					},
				});
				resolve();
			} catch (e) {
				reject(e);
			}
		});
	}

	/**
	 * 参数表
	 * @returns
	 */
	getParamsList() {
		return new Promise(async (resolve, reject) => {
			try {
				const sqlStr = `select * from report_parameter`;
				const result = await this.app.mysql.query(sqlStr);
				const [{ "COUNT(*)": total }] = await this.app.mysql.query(
					`SELECT COUNT(*) from report_parameter`
				);
				resolve({
					list: result,
					total,
				});
			} catch (e) {
				reject(e);
			}
		});
	}

	/**
	 * 增加参数类型
	 * @param {*} data
	 * @returns
	 */
	addParams(data) {
		return new Promise(async (resolve, reject) => {
			try {
				await this.app.mysql.insert("report_parameter", data);
				resolve();
			} catch (e) {
				reject(e);
			}
		});
	}
}

module.exports = BigDataService;
