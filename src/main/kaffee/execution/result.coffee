# Copyright (c) 2012 Fabian M.
# See the AUTHORS file for all contributors of the Kaffee project.
###
  A {@link Result} instance contains the result of a executed {@link Goal}

  @version 0.3.0
  @author Fabian M. <mail.fabianm@gmail.com>
###
class Result
	
	###
	  The {@link Project} of this {@link Result} instance.
	###
	project: null

	###
	  The child {@link Result}s of this {@link Result}.
	###
	childs: []
	
	###
	  The logs of this {@link Result}.
	###
	logs: []

	### 
	  Constructs a new {@link Result} instance.

	  @since 0.2.1
	  @param project The {@link Project} of this {@link Result}.
	  @param parent The parent {@link Result} of this {@link Result}.
	###
	constructor: (project) ->
		this.project = project
		this.childs = []
		this.logs = []
		this
		
	###
	  Returns the {@link LogEvent}s of this {@link Result} instance.
	  
	  @since 0.3.0
	  @return The {@link LogEvent}s of this {@link Result} instance.
	###
	getLogs: -> this.logs

	###
	  Returns the {@link Project} of this {@link ProjectResult} instance.

	  @since 0.2.1
	  @return The {@link Project} of this {@link ProjectResult} instance.
	###
	getProject: -> this.project
	
	###
	  Adds a child {@link Result} to this {@link Result} instance.

	  @since 0.2.1
	  @param child The {@link Result} to add.
	###
	addChild: (child) ->
		return this.childs if not child
		return this.childs.push child if child instanceof Result
		return this.childs = this.childs.concat child

	###
	  Returns the child {@link Result}s of this {@link Result} instance.

	  @since 0.2.1
	  @return The child {@link Result}s of this {@link Result} instance.
	###
	getChilds: -> this.childs

	###
	  Sets the result message of this {@link Result} instance.

	  @since 0.2.1
	  @param message The message to set.
	###
	setMessage: (message) ->
		return this.message if not message
		this.message = message

	###
	  Returns the result message of this {@link Result} instance.
	
	  @since 0.2.1
	  @return The result message of this {@link Result} instance.
	###
	getMessage: -> this.message
module.exports = Result
		
