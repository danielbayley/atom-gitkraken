{exec} = require 'child_process'

app = '/Applications/GitKraken.app/Contents/MacOS/GitKraken'

module.exports =
	#os: process.platform
	#app: '/Applications/GitKraken.app/Contents/MacOS/GitKraken'
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
			@subs.add 'status-bar','click', @selector, @open #mousedown

	open: ->
		{path} = atom.project.getDirectories()[0]
		exec "#{app} -p '#{path}'" #, @timeout

#-------------------------------------------------------------------------------
	deactivate: -> @subs.dispose()
