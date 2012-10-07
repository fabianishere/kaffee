EventManager = require '../event/manager'
Result = require '../execution/result'
###
  A {@link Goal} instance represents a Kaffee goal.

  @author Fabian M. <mail.fabianm@gmail.com>
###
class Goal
	###
	  Constructs a new {@link Goal}.

	  @since 0.2.1
	  @param plugin The {@link Plugin} of this {@link Goal}.
	  @param name The name of this {@link Goal}.
	  @param call The function of this {@link Goal}.
	###
	constructor: (@plugin, @name, @call) -> this.event = new EventManager "goal-#{ name }", plugin.getEventManager(), this
		
	###
	  Returns the {@link Project} of this {@link Goal}.
	  
	  @since 0.3.0
	  @return The {@link Project} of this {@link Goal}.
	###
	getProject: -> this.getPlugin().getProject()
	
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
	  Returns the logging object of this {@link Goal}.
	  
	  @since 0.3.1
	  @return The logging object of this {@link Goal}.
	###
	getLogger: -> this.getEventManager().getLogger()
		
	###
	  The {@link #dependsOn} methods should be called if 
	  	this {@link Goal} dependends on another {@link Goal}.
	  	
	  @since 0.3.0
	  @param name The name of the {@link Goal} to depend on.
	  @param request The {@link ExecutionRequest} instance.
	  @return The result.
	###
	dependsOn: (name, request) ->
		return unless name
		return name.attain? request
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
		this.logger = this.getLogger()
		try
			throw new Error "Invalid Goal" unless this.call
			result.setMessage this.call.call(this, request)
			
		catch e
			this.getLogger().error e
		this.logger = undefined
		this.event.fire "attained", this, result
		result
module.exports = Goal
