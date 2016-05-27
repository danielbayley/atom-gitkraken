{exec} = require 'child_process'

module.exports =
	#os: process.platform
	#timeout:
		#timeout: 10000
		#killSignal: 'SIGKILL'
	selector: '[class^="status-bar"] .git-branch'

	subs: null
	activate: ->
		SubAtom = require 'sub-atom' # {CompositeDisposable} = require 'atom'
		@subs = new SubAtom #CompositeDisposable
#-------------------------------------------------------------------------------

		@subs.add atom.commands.add 'atom-workspace',
			'gitkraken:release': => @open()

		atom.packages.onDidActivateInitialPackages =>
			@subs.add 'status-bar','click', @selector, @open

	open: ->
		{path} = atom.project.getDirectories()[0]
		exec "open -b com.axosoft.GitKraken --args -p '#{path}'" #, @timeout

#-------------------------------------------------------------------------------
	deactivate: -> @subs.dispose()
