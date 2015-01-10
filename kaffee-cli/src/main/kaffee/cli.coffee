Commander = require 'commander'
Winston = require 'winston'
Kaffee = require 'kaffee'

Configuration = Kaffee.Configuration
Workspace = Kaffee.project.Workspace
ProjectConfiguration = Kaffee.project.ProjectConfiguration
Project = Kaffee.project.Project
Request = Kaffee.execution.Request
###
  Command line interface for the Kaffee library.
	
  @version 0.3.0
  @author Fabian M. <mail.fabianm@gmail.com>
###
class Cli

	###
	  Runs Kaffee using command line arguments.

	  @since 0.2.1
	  @param args The command line arguments.
	###
	@run: (args) ->
		logger = new Winston.Logger
			transports: [ new Winston.transports.Console
				colorize : true
    			]
		goals = []

		Commander.version(Configuration.VERSION).usage(Configuration.NAME + " [options] [goal(s)]")
		Commander.option "-w, --workspace <path>", "Changes the working directory.", "."
		Commander.option "-c, --config <path>", "Sets the path to the package.json file.", undefined
		Commander.option "-f, --force", "Forces Kaffee.", Boolean, false
		Commander.command('*').action ->
			a = goals.concat Array.prototype.slice.call(arguments)
			a.pop()
			goals = a
		Commander.parse(args);
	
		try 
			workspace = new Workspace Commander.workspace
			config = new ProjectConfiguration workspace, Commander.config
		catch e
			return not logger.error e
		project = new Project config	
		project.getEventManager().on "attain", (goal) ->
			console.log ">> Running goal \"#{ goal.getPlugin().getName() }:#{ goal.getName() }\""
		project.getEventManager().on "attained", (goal, result) ->
			errors = (log for log in result.getLogs() when log.getLevel().value >= 3)
			warnings = (log for log in result.getLogs() when log.getLevel().value is 2)
			console.log ">> Finished with #{ errors.length } error(s) and #{ warnings.length } warning(s)"
		project.getEventManager().on "*log", (log) ->
			return logger.error log.getStack() if log.getLevel().value >= 3
			logger.log log.getLevel().name, log.getMessage()
		return unless project.load()
		result = project.execute new Request(goals, Commander.force)
module.exports = Cli
