"use strict";

const { Controller } = require("egg");

class BigDataController extends Controller {
	async getReportList() {
		const { ctx, service } = this;
		const result = await service.task.addBatchTasks(ctx.request.body);
		return ctx.sendSuccess(result);
	}
}

module.exports = BigDataController;
