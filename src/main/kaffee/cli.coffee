# Copyright (c) 2012 Fabian M.
# See the AUTHORS file for all contributors of the Kaffee project.
Commander = require 'commander'
Winston = require 'winston'

Kaffee = require 'kaffee'
Configuration = Kaffee.Configuration
Workspace = Kaffee.project.Workspace
ProjectConfiguration = Kaffee.project.ProjectConfiguration
Project = Kaffee.project.Project
Request = Kaffee.execution.Request

###
  Command line interface for the kaffee-core library.
	
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
		logger = new Winston.Logger { transports: [ new Winston.transports.Console {
			colorize : true
    		}]}
  
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
	
		workspace = new Workspace Commander.workspace
		config = new ProjectConfiguration workspace, Commander.config

		if not workspace.exists() || not config.exists()
			logger.warn "Workspace or configuration doesn't exist."
			logger.info "Use kaffee:init to initialize this project."
			return
		project = new Project config	
		###
		  Log {@link LogEvent}s.
		###
		project.getEventManager().on "attain", (goal) ->
			console.log ">> Running goal \"#{ goal.getPlugin().getName() }:#{ goal.getName() }\""
		project.getEventManager().on "attained", (goal, result) ->
			errors = (log for log in result.getLogs() when log.getLevel().value == 3)
			warnings = (log for log in result.getLogs() when log.getLevel().value == 2)
			console.log ">> Finished with #{ errors.length } error(s) and #{ warnings.length } warning(s)"
		project.getEventManager().on "*log", (log) ->
			return logger.log log.getLevel().name, log.getStack() if log.hasStack()
			logger.log log.getLevel().name, log.getMessage()
		return if not project.load()
		result = project.execute new Request(goals, Commander.force)
module.exports = Cli
