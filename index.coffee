{execSync, exec} = require 'child_process'
{writeFile, unlink} = require 'fs'
SubAtom = require 'sub-atom'

module.exports =
	#os: process.platform
	#timeout:
		#timeout: 10000
		#killSignal: 'SIGKILL'

	project: atom.project.getDirectories()[0]
	tmp: '/tmp/GitKraken.json'

	id: 'com.axosoft.GitKraken'
	selector: '[class^=status-bar] .git-branch'

	subs: new SubAtom
#-------------------------------------------------------------------------------
	activate: ->

		@subs.add atom.commands.add 'atom-workspace',
			'gitkraken:release': => @open @project

		atom.packages.onDidActivateInitialPackages =>
			@subs.add 'status-bar','click', selector, @open @project

#-------------------------------------------------------------------------------
	open: ({path}) ->
		if atom.config.get 'gitkraken.singleInstance'
			exec "pkill GitKraken; sleep .1 && open -Fb #{@id} --args -p '#{path}'" #, @timeout
		else
			projects = {}
			try
				projects = require @tmp
				execSync "ps #{projects[path]} | grep -q GitKraken &&
					open -b #{@id} --args -p '#{path}'"
			catch
				pid = execSync "open -nb #{@id} --args -p '#{path}' & echo $!"
				projects[path] = (parseInt pid) + 1
				writeFile @tmp, JSON.stringify projects

			window.addEventListener 'beforeunload', ->
				exec "kill #{projects[path]}"

#-------------------------------------------------------------------------------
	deactivate: ->
		@subs.dispose()
		window.removeEventListener 'beforeunload'
		unlink @tmp
