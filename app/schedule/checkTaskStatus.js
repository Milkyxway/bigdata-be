"use strict";

const Subscription = require("egg").Subscription;
const dayjs = require("dayjs");

class logTime extends Subscription {
	static get schedule() {
		return {
			cron:  '0 0 */2 * * *',
			type: "worker",
		};
	}

	async subscribe() {
		const faultTasks = await this.app.mysql.query(`select * from report_list where reportId in (1136, 1134, 924, 921,918) and reportState = 4`)
		faultTasks.map(async i => {
			await this.app.mysql.update("report_list", {
				reportState: 1,
				lastTime: '2020-01-01 00:00:00'
			 }, {
				where: {
					reportId: i.reportId,
				},
			});
		})
		
		

	}
}

module.exports = logTime;
