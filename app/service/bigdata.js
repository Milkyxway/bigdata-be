const Service = require("egg").Service;

class RoleService extends Service {
	// async index() {
	//   const result = await this.app.mysql.select('category')
	//   return result
	// }
	/**
	 * 登录接口
	 * @param {*} query
	 */
	async login(query) {
		const user = await this.app.mysql.select("user", {
			where: {
				username: query.username,
			},
		});
		return new Promise((res, reject) => {
			if (user) {
				if (query.password === user[0].password) {
					const { password, ...rest } = user[0];
					res({
						userInfo: { ...rest }, // 不把密码返回给前端
					});
				}
			}
			reject();
		});
	}

	/**
	 * 修改密码
	 * @param {*} query
	 */
	async modifyPwd(query) {
		const { oldPwd, userId, newPwd } = query;
		return new Promise(async (resolve, reject) => {
			const userInfo = await this.app.mysql.select("user", {
				where: { userId },
			});
			if (userInfo) {
				const pwdInsql = userInfo[0].password;
				if (pwdInsql !== oldPwd) {
					reject("旧密码输入有误");
				} else if (pwdInsql === newPwd) {
					reject("新密码与旧密码一致");
				} else {
					await this.app.mysql.update(
						"user",
						{ password: newPwd },
						{
							where: {
								userId: query.userId,
							},
						}
					);
					resolve();
				}
			} else {
				reject("获取用户失败");
			}
		});
	}

	/**
	 * 创建账户
	 * @param {*} query
	 */
	async createAccount(query) {
		return new Promise(async (resolve, reject) => {
			const useraccount = await this.app.mysql.select("user", {
				where: {
					username: query.username,
				},
			});
			if (useraccount.length) {
				reject("该账户已存在");
			} else {
				await this.app.mysql.insert("user", query);
				resolve();
			}
		});
	}

	/**
	 * 获取
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
}

module.exports = RoleService;
