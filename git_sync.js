const fs = require('fs')
const {spawnSync} = require('child_process')

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

function main() {
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

	// sync the main repo
	checkout('master')
	pull('master')

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

		checkout(branch, path)
		pull(branch, path)

		console.log('\n')
	}
}

main()
