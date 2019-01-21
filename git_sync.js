const fs = require('fs')
const {spawnSync, execSync} = require('child_process')

function checkout(branch, path) {
	exec(`git checkout ${branch}`, path)
}

function pull(branch, path) {
	exec(`git pull origin ${branch}`, path)
}

function exec(cmd, path = process.cwd()) {
	const exec = spawnSync(cmd, {shell: true, cwd: path})
	console.log(exec.stdout.toString().trim())
	console.log(exec.stderr.toString().trim())
}

async function deleteOtherBranches(currentBranch, path) {
	const branches = await execSync(`git branch`, {shell: true, cwd: path})
		.toString()
		.split('\n')
		.map(raw => raw.trim())
		.filter(raw => (raw !== '' && !raw.startsWith('*') && raw !== currentBranch))

	for (let branch of branches) {
		try {
			await exec(`git branch -D ${branch}`, path)
		} catch (e) {
			console.log(e)
		}
	}
}

async function main() {
	// console.log(`Node version:`, process.version + '\n')
	let pkg

	try {
		pkg = fs.readFileSync('package.json');
	} catch (error) {

		if (error.code === 'ENOENT') {
			return console.log('Exiting, package.json not found.')
		}

		// because we still need to exit our program
		throw error
	}

	const {submoduleConfig} = JSON.parse(pkg)

	if (!submoduleConfig) {
		return console.log('Exiting, key "submoduleConfig" is not found in package.json.')
	}

	if (process.argv.includes('-clean')) {
		deleteOtherBranches('master')
	} else if (process.argv.includes('-checkout')) {
		checkout('master')
	} else if (process.argv.includes('-current')) {
		exec('git pull origin $(git rev-parse --abbrev-ref HEAD)')
	} else {
		// sync the main repo
		checkout('master')
		pull('master')
	}

	const envs = ['dev', 'prod']
	const env = envs.includes(process.arvg0) ? process.arvg0 : envs[0]
	const submodulesInfo = submoduleConfig[env]

	for (const path in submodulesInfo) {
		let branch = submodulesInfo[path]

		if (typeof branch === 'object') {
			branch = branch.sourceBranch || branch.tag
		}

		console.log('Directory: ', path)
		console.log('Git branch: ', branch)

		if (process.argv.includes('-clean')) {
			deleteOtherBranches(branch, path)
		} else if (process.argv.includes('-checkout')) {
			checkout(branch, path)
		} else {
			checkout(branch, path)
			pull(branch, path)
		}

		console.log('\n')
	}
}

main()
