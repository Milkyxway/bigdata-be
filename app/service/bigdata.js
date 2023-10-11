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
			const sqlStr = `select * from sql_Data ${whereStr} order by createTime desc limit ${
				pageNum * pageSize
			},${pageSize}`;
			const [{ "COUNT(*)": total }] = await this.app.mysql.query(
				`SELECT COUNT(*) from sql_Data ${whereStr}`
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

	/**
	 * 获取任务列表
	 * @returns
	 */
	getTaskList(query) {
		return new Promise(async (resolve, reject) => {
			try {
				const { pageNum, pageSize } = query;
				const sqlStr = `select * from report_list order by createTime desc limit ${
					pageNum * pageSize
				},${pageSize}`;
				const list = await this.app.mysql.query(sqlStr);
				const [{ "COUNT(*)": total }] = await this.app.mysql.query(
					`SELECT COUNT(*) from report_list `
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
			} catch (e) {}
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
			} catch (e) {}
		});
	}
}

module.exports = BigDataService;
