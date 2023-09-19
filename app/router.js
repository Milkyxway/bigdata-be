"use strict";

/**
 * @param {Egg.Application} app - egg application
 */
module.exports = (app) => {
	const { router, controller } = app;

	/**
	 * 任务列表增删改查
	 */
	// router.post("/api/task/list", controller.task.query);
	// router.post("/api/task/add", controller.task.add);
	// router.delete("/api/task/delete", controller.task.delete);
	// router.put("/api/task/update", controller.task.update);
	// router.put("/api/task/finish", controller.task.setFinish);
	// router.post("/api/task/detail", controller.task.detail);
	// router.post("/api/task/appeal", controller.task.appeal);
	// router.post("/api/task/mine", controller.task.myTask);
	// router.post("/api/task/batchadd", controller.task.addBatchTasks);
	// router.post("/api/subtask/add", controller.task.addChildTask);
	// router.post("/api/subtask/update", controller.task.updateSubTask);
	// router.delete("/api/subtask/delete", controller.task.deleteSubTask);

	// router.post("/api/login", controller.role.login);
	// router.post("/api/modifypwd", controller.role.modifypwd);
	// router.post("/api/createaccount", controller.role.createaccount);
	router.post("/api/report/list", controller.bigdata.getReportList);
	router.post("/api/report/sqllist", controller.bigdata.getSQL);
	router.post("/api/report/download", controller.bigdata.downloadSql);
	router.post("/api/report/upload", controller.upload.upload);
};
