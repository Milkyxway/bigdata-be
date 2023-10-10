"use strict";

const { Controller } = require("egg");

class BigDataController extends Controller {
	async getReportList() {
		const { ctx, service } = this;
		const result = await service.bigdata.getReportList(ctx.request.body);
		return ctx.sendSuccess(result);
	}

	async getSQL() {
		const { ctx, service } = this;
		const result = await service.bigdata.getSQL(ctx.request.body);
		return ctx.sendSuccess(result);
	}

	async downloadSql() {
		const { ctx, service } = this;
		const result = await service.bigdata.downloadSql(ctx.request.body);
		return ctx.sendSuccess(result);
	}

	async uploadSql() {
		const { ctx, service } = this;
		const result = await service.bigdata.uploadSql(ctx.request.body);
		return ctx.sendSuccess(result);
	}

	async createTask() {
		const { ctx, service } = this;
		const result = await service.bigdata.createTask(ctx.request.body);
		return ctx.sendSuccess(result);
	}

	async getTaskList() {
		const { ctx, service } = this;
		const result = await service.bigdata.getTaskList(ctx.request.body);
		return ctx.sendSuccess(result);
	}

	async createTaskType() {
		const { ctx, service } = this;
		const result = await service.bigdata.createTaskType(ctx.request.body);
		return ctx.sendSuccess(result);
	}

	async addSql() {
		const { ctx, service } = this;
		try {
			const result = await service.bigdata.addSql(ctx.request.body);
			return ctx.sendSuccess(result);
		} catch (e) {
			return ctx.sendError(e);
		}
	}
	async getTaskDetail() {
		const { ctx, service } = this;
		try {
			const result = await service.bigdata.getTaskDetail(ctx.request.body);
			return ctx.sendSuccess(result);
		} catch (e) {
			return ctx.sendError(e);
		}
	}

	async getReportType() {
		const { ctx, service } = this;
		try {
			const result = await service.bigdata.getReportType(ctx.request.body);
			return ctx.sendSuccess(result);
		} catch (e) {
			return ctx.sendError(e);
		}
	}
}

module.exports = BigDataController;
