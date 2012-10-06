# Copyright (c) 2012 Fabian M.
# See the AUTHORS file for all contributors of the Kaffee project.
Path = require 'path'

Goal = require './goal'
Request = require '../execution/request'
Result = require '../execution/result'
EventManager = require '../event/manager'

###
  A {@link Plugin} instance represents a Kaffee plugin.

  @version 0.2.1
  @author Fabian M. <mail.fabianm@gmail.com>
###
class Plugin

	###
	  The name of this {@link Plugin}.
	###
	name: ""

	###
	  The {@link Goals} of this {@link Plugin}.
	###
	goals: []

	###
	  The {@link Project} instance of this {@link Goal}.
	###
	project: null

	###
	  The configuration of this {@link Plugin}.
	###
	configuration: null

	###
	  The {@link EventManager} of this {@link Plugin}.
	###
	event: null
	
	###
	  Constructs a new {@link Plugin} instance.

	  @since 0.2.1
	  @param name The name of this {@link Plugin}.
	  @param project The {@link Project} of this {@link Plugin}.
	  @param configuration The configuration of this {@link Plugin}.
	###
	constructor: (name, project, configuration = {}) ->
		throw "IllegalArgumentException" if not name or not project
		this.goals = []
			
		this.name = name
		this.project = project
		this.configuration = configuration
		this.event = new EventManager "plugin-" + this.name, project.getEventManager(), this
		this.logger = this.event.getLogger()

	###
	  Loads this plugin.
	  
	  @since 0.3.0
	###
	load: ->
		this.event.fire "enter", this
		try
			# Modify path.
			module.paths.push Path.join this.project.getConfiguration().getWorkspace().getPath(), "node_modules"
			module.paths = process.mainModule.paths.concat module.paths
			obj = require this.name
			throw "Plugin " + name + " is invalid." if typeof obj != 'function' 
			obj.apply this, [this.configuration]
		catch e
			this.event.getLogger().error e
			return
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
	  Returns a {@link Goal} of this {@link Plugin}.
	  
	  @since 0.3.0
	  @param name The name of the goal to get.
	  @return The {@link Goal}.
	###
	getGoal: (name) ->
		for goal in this.goals
			return goal if goal.getName() == name
		false
		
	###
	  Determines if this {@link Project} has a {@link Plugin}.
	
	  @since 0.2.1
	  @param name The name of the {@link Goal}.
	###
	hasGoal: (name) -> !!this.getGoal name

	###
	  Adds a {@link Goal} to this {@link Plugin}.

	  @since 0.2.1
	  @param goal The goal to add.
	###
	addGoal: (goal) -> this.goals.push(goal) if goal instanceof Goal
		
	###
	  Registers a goal.
	  
	  @since 0.3.0
	  @param name The name of the goal to register.
	  @param func The function of this goal.
	###
	register: (name, func) -> this.addGoal new Goal(this, name, func)
	
module.exports = Plugin
