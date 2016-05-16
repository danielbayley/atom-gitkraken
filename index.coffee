{exec} = require 'child_process'
module.exports =
	#os: process.platform
	app: '/Applications/GitKraken.app/Contents/MacOS/GitKraken'
	#timeout:
		#timeout: 10000
		#killSignal: 'SIGKILL'

	subs: null
	activate: ->
		@subs = atom.commands.add 'atom-workspace',
			'gitkraken:release': =>
				{path} = atom.project.getDirectories()[0]
				exec "#{@app} -p '#{path}'" #, @timeout

	deactivate: -> @subs.dispose()
