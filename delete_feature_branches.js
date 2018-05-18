const exec = require('child_process')
const rawStdio = exec.execSync('git branch -vv').toString()
const branches = rawStdio.match(/feature\/\S+/g)

async function main() {
	console.log(rawStdio)

	if (branches) {
		for (let branch of branches) {
			const work = await exec.spawnSync(`git branch -D ${branch}`, {shell: true/*, cwd: process.cwd()*/})
			console.log(work.stdout.toString().trim())
			console.log(work.stderr.toString().trim())
		}

		console.log(rawStdio)
	}
}

main()
