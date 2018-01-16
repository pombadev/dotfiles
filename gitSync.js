#!/usr/bin/node

const fs = require('fs')
const {spawnSync, spawn} = require('child_process')
let arg = process.argv[2]

if (arg && arg.match(/--help|--h$/i)) {
	return console.log(
	`
  $ node path/to/gitSync.js --env=[dev|prod|custom]

  This script looks through a project containing key 'submoduleConfig' in package.json to do two things:
  1) git checkout *branch*
  2) git pull origin *branch*

  Example package.json:

  .....,
  "submoduleConfig": {
  	"dev": {
  		"src/submodules1": "dev", // branch name
  		.....
  	},
  	"prod": {
  		"src/submodules1": "1.0", // branch name
  		......
  	}
  },
  .....

  Execute this from the root of the project.
	`
	)
}

let env = 'dev'
let pkj
let submoduleConfig

try {
	// can do process.cwd() because this script is meant to be executed
	// in the root of a project
	pkj = fs.readFileSync(`${process.cwd()}/package.json`)
} catch (e) {
	return console.log(`\n'package.json' not found\n`)
}

try {
	let parse_pkg = JSON.parse(pkj.toString())

	if (parse_pkg.submoduleConfig) {
		submoduleConfig = parse_pkg.submoduleConfig
	} else {
		throw new Error(`"submoduleConfig" not found.`)
	}
} catch (e) {
	return console.log(`\nCan't find "submoduleConfig" in package.json.\n`)
}

if (arg && arg.startsWith('--env=')) {
	let key = arg.split('=')[1]
	if (key in submoduleConfig) {
		env = key
	} else {
		console.log(`\nCan't find the env '${key}' passed, using 'dev' as default.\n`)
	}
}

const config = submoduleConfig[env]

function make_jobs() {
	let total = {
		checkout: [() => spawnSync(`git checkout master`, {shell: true, cwd: process.cwd()})],
		pull: [() => spawnSync(`git pull origin master`, {shell: true, cwd: process.cwd()})]
	}

	return Object.keys(config).reduce((total, cwd) => {
		total.checkout.push(() => spawnSync(`git checkout ${config[cwd]}`, {shell: true, cwd}))
		total.pull.push(() => spawnSync(`git pull origin ${config[cwd]}`, {shell: true, cwd}))
		return total
	}, total)

	// const git_checkout = async (cwd) =>
	// 	await new Promise(
	// 		resolve => resolve(spawnSync(`git checkout ${config[cwd]}`, {shell: true, cwd}))
	// 	)

	// const git_pull = async (cwd) =>
	// 	await new Promise(
	// 		resolve => resolve(spawnSync(`git pull origin ${config[cwd]}`, {shell: true, cwd}))
	// 	)

	// return Object.keys(config).reduce((total, cwd) => {
	// 	total.checkout.push(git_checkout(cwd))
	// 	total.pull.push(git_pull(cwd))
	// 	return total
	// }, {checkout: [], pull: []})
}

function execute_jobs(jobs) {
	return Promise.all(jobs.map(job => job()))
}

function parse_jobs(jobs) {
	return jobs.map(
		job => ({
			status: job.status === 0 ? job.stdout : job.stderr,
			exit_code: job.status,
			options: job.options
		})
	)
}

function log(jobs) {
	const blue = '\x1b[34m'
	const cyan = '\x1b[36m'
	const dim = '\x1b[2m'
	const green = '\x1b[32m'
	const red = '\x1b[31m'
	const reset = '\x1b[0m'
	// const underline = '\x1b[4m'
	const yellow = '\x1b[33m'

	jobs.forEach((job) => {
		console.log(`${blue}Command${reset}: ${dim}${job.options.args[2]}${reset} ${job.exit_code ? `${red}✘` : `${green}✔`}${reset}`)
		console.log(`${yellow}Directory${reset}:`, `${dim}${job.options.cwd}${reset}`)
		console.log(`${cyan}Logs${reset}:`)
		console.log(`${dim}${job.status.toString()}${reset}`)
	})
}

function main() {
	const {checkout, pull} = make_jobs()

	Promise.all([
		execute_jobs(checkout)
		.then(parse_jobs)
		.then(log),

		execute_jobs(pull)
		.then(parse_jobs)
		.then(log),
	])
	.catch((error) => {
		console.error(error)
	})
}

main()
