module.exports = {
	// 可选类型
	types: [
		{
			value: 'task',
			name: 'task:      新增产品功能的任务'
		},
		{
			value: 'bug',
			name: 'bug:       修复 bug'
		},
		{
			value: 'fix',
			name: 'fix:       解决生产hotfix'
		},
		{
			value: 'formatting',
			name: 'formatting:     不改变代码功能的变动'
		},
		{
			value: 'refactor',
			name: 'refactor:  重构代码'
		},
		{
			value: 'perf',
			name: 'perf:      性能优化'
		},
		{
			value: 'build',
			name: 'build:     构建流程、外部依赖变更'
		},
		{
			value: 'ci',
			name: 'ci:        修改了 CI 配置、脚本'
		},
		{
			value: 'chore',
			name: 'chore:     对构建过程或辅助工具和库的更改'
		},
		{
			value: 'revert',
			name: 'revert:    回滚 commit'
		}
	],
	// 消息步骤
	messages: {
		type: '请选择提交类型:',
		customScope: '请输入修改的范围(可选)',
		subject: '请简要描述提交(必填)',
		body: '请输入详细描述(可选)',
		footer: '请输入关联 task/bug id:(可选)',
		confirmCommit: '确定要使用以上信息提交?(y/n)'
	},
	// scope 类型，针对 vue 项目
	scopes: [
		{ value: 'view', name: 'view 视图页面相关' },
		{ value: 'components', name: 'components 组件相关' },
		{ value: 'styles', name: 'styles 样式相关' },
		{ value: 'utils', name: 'utils 工具类相关' },
		{ value: 'auth', name: 'auth 权限相关' },
		{ value: 'logger', name: 'logger 日志相关' },
		{ value: 'deps', name: 'deps 依赖相关' },
		{ value: 'hooks', name: 'hooks hooks相关' },
		{ value: 'other', name: 'other 其他修改' }
	],
	// 默认提交长度
	subjectLimit: 200,
	footerPrefix: '关联 task/bug id:'
}
