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

	downloadSql() {
		return new Promise((resolve, reject) => {
			const ftp = require("ftp");
			const client = new ftp();
			client.on("ready", function () {
				client.get("客户明细.sql", (err, file) => {
					resolve(file);
				});
			});

			client.connect({
				host: "172.16.179.5",
				user: "htgl",
				password: "zaSFW5AfrerDm6eD",
			});
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
}

module.exports = BigDataService;
