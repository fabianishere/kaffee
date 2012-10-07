# Copyright (c) 2012 Fabian M.
# See the AUTHORS file for all contributors of the Kaffee project.
EventManager = require '../event/manager'
Result = require '../execution/result'
###
  A {@link Goal} instance represents a Kaffee goal.

  @version 0.3.0
  @author Fabian M. <mail.fabianm@gmail.com>
###
class Goal

	###
	  The name of this {@link Goal}.
	###
	name: ""

	###
	  The {@link Plugin} of this {@link Goal}.
	###
	plugin: null

	###
	  The {@link EventManager} of this {@link Goal}.
	###
	event: null

	###
	  The function of this {@link Goal}.
	###
	call: -> false

	###
	  Returns the name of this {@link Goal}.

	  @since 0.2.1
	  @return The name of this {@link Goal}.	
	###
	getName: -> this.name

	###
	  Returns the {@link Plugin} of this {@link Goal}.

	  @since 0.2.1
	  @return The {@link Plugin} of this {@link Goal}.
	###
	getPlugin: -> this.plugin

	###
	  Returns the {@link EventManager} of this {@link Goal}.
	  
	  @since 0.3.0
	  @return The {@link EventManager} of this {@link Goal}.
	###
	getEventManager: -> this.event

	###
	  Constructs a new {@link Goal}.

	  @since 0.2.1
	  @param plugin The {@link Plugin} of this {@link Goal}.
	  @param name The name of this {@link Goal}.
	  @param call The function of this {@link Goal}.
	###
	constructor: (plugin, name, call) ->
		this.name = name
		this.plugin = plugin
		this.call = call
		this.event = new EventManager "goal-#{ name }", plugin.getEventManager(), this
		this.logger = this.event.getLogger()
		
	###
	  Returns the {@link Project} of this {@link Goal}.
	  
	  @since 0.3.0
	  @return The {@link Project} of this {@link Goal}.
	###
	getProject: -> this.getPlugin().getProject()
		
	###
	  The {@link #dependsOn} methods should be called if 
	  	this {@link Goal} dependends on another {@link Goal}.
	  	
	  @since 0.3.0
	  @param name The name of the {@link Goal} to depend on.
	  @param request The {@link ExecutionRequest} instance.
	  @return The result.
	###
	dependsOn: (name, request) ->
		return if not name
		return name.attain request if name.attain
		this.getPlugin().getProject().attainGoal name, request
	
	###
	  Attains this {@link Goal}.

	  @since 0.3.0
	  @param request The {@link ExecutionRequest} instance.
	  @return The result.
	###
	attain: (request) -> 
		result = new Result this.getProject()
		this.event.fire "attain", this
		this.event.on "*log", (log) -> result.getLogs().push log
		try
			throw "Invalid Goal" if not this.call
			msg = this.call.apply this, request
			result.setMessage msg
		catch e
			this.logger.error e
		this.event.fire "attained", this, result
		result
module.exports = Goal
