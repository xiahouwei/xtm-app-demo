module.exports = {
	extends: ['@commitlint/config-conventional'],
	rules: {
		'type-enum': [
			2,
			'always',
			['task', 'bug', 'fix', 'formatting', 'refactor', 'perf', 'build', 'ci', 'chore', 'revert']
		],
		'subject-case': [0]
	}
}
