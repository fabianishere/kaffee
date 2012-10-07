Path = require 'path'

Goal = require './goal'
Request = require '../execution/request'
Result = require '../execution/result'
EventManager = require '../event/manager'
###
  A {@link Plugin} instance represents a Kaffee plugin.

  @author Fabian M. <mail.fabianm@gmail.com>
###
class Plugin
	###
	  Constructs a new {@link Plugin} instance.

	  @since 0.2.1
	  @param name The name of this {@link Plugin}.
	  @param project The {@link Project} of this {@link Plugin}.
	  @param configuration The configuration of this {@link Plugin}.
	###
	constructor: (@name, @project, @configuration = {}) ->
		this.goals = []
		this.event = new EventManager "plugin-#{ this.name }", project.getEventManager(), this

	###
	  Loads this plugin.
	  
	  @since 0.3.0
	###
	load: ->
		this.event.fire "enter", this
		this.logger = this.getLogger()
		try
			# Modify path.
			module.paths = process.mainModule.paths.concat module.paths, [Path.join this.project.getConfiguration().getWorkspace().getPath(), "node_modules"]
			obj = require this.name
			throw "Plugin " + this.name + " is invalid." if typeof obj != 'function' 
			obj.call this, this.configuration
		catch e
			this.event.getLogger().error e
			return
		this.logger = undefined
		this.event.fire "leave", this
		true
		

	###
	  Returns the name of this {@link Plugin}.
	
	  @since 0.2.1
	  @return The name of this {@link Plugin}.
	###
	getName: -> this.name

	###
	  Returns the {@link Project} of this {@link Plugin}.

	  @since 0.2.1
	  @return The {@link Project} of this {@link Plugin}.
	###
	getProject: -> this.project
	
	###
	  Returns the configuration of this {@link Plugin}.
	  
	  @since 0.2.1
	  @return The configuration of this {@link Plugin}.
	###
	getConfiguration: -> this.configuration

	###
	  Returns the {@link Goal}s of this {@link Plugin}.

	  @since 0.2.1
	  @return The {@link Goal}s of this {@link Plugin}.
	###
	getGoals: -> this.goals

	###
	  Returns the {@link EventManager} of this {@link Plugin}.

	  @since 0.3.0
	  @return The {@link EventManager} of this {@link Plugin}.
	###
	getEventManager: -> this.event
	
	###
	  Returns the logging object of this {@link Plugin}.
	  
	  @since 0.3.1
	  @return The logging object of this {@link Plugin}.
	###
	getLogger: -> this.getEventManager().getLogger()

	###
	  Returns a {@link Goal} of this {@link Plugin}.
	  
	  @since 0.3.0
	  @param name The name of the goal to get.
	  @return The {@link Goal}.
	###
	getGoal: (name) -> return goal for goal in this.goals when goal.getName() is name
		
	###
	  Determines if this {@link Project} has a {@link Plugin}.
	
	  @since 0.2.1
	  @param name The name of the {@link Goal}.
	###
	hasGoal: (name) -> !!this.getGoal name
		
	###
	  Registers a goal.
	  
	  @since 0.3.0
	  @param name The name of the goal to register.
	  @param call The function of this goal.
	###
	register: (name, call) -> this.goals.push new Goal(this, name, call)
	
module.exports = Plugin
