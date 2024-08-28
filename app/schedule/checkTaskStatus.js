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
		const cycleExeTasks = [534,533,536]
		await this.app.mysql.update("report_list", {
			reportState: 1,
			lastTime: '2020-01-01 00:00:00'
		 }, {
			where: {
				reportId: 534,
			},
		});
		await this.app.mysql.update("report_list", {
			reportState: 1,
			lastTime: '2020-01-01 00:00:00'
		 }, {
			where: {
				reportId: 533,
			},
		});
		await this.app.mysql.update("report_list", {
			reportState: 1,
			lastTime: '2020-01-01 00:00:00'
		 }, {
			where: {
				reportId: 536,
			},
		});
		await this.app.mysql.update("report_list", {
			reportState: 1,
			lastTime: '2020-01-01 00:00:00'
		 }, {
			where: {
				reportId: 560,
			},
		});
		await this.app.mysql.update("report_list", {
			reportState: 1,
			lastTime: '2020-01-01 00:00:00'
		 }, {
			where: {
				reportId: 590,
			},
		});

	}
}

module.exports = logTime;
