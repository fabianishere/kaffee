###
  A {@link Result} instance contains the result of a executed {@link Goal}

  @author Fabian M. <mail.fabianm@gmail.com>
###
class Result

	### 
	  Constructs a new {@link Result} instance.

	  @since 0.2.1
	  @param project The {@link Project} of this {@link Result}.
	  @param parent The parent {@link Result} of this {@link Result}.
	###
	constructor: (@project) ->
		@childs = []
		@logs = []
		
	###
	  Returns the {@link LogEvent}s of this {@link Result} instance.
	  
	  @since 0.3.0
	  @return The {@link LogEvent}s of this {@link Result} instance.
	###
	getLogs: -> @logs

	###
	  Returns the {@link Project} of this {@link ProjectResult} instance.

	  @since 0.2.1
	  @return The {@link Project} of this {@link ProjectResult} instance.
	###
	getProject: -> @project
	
	###
	  Adds a child {@link Result} to this {@link Result} instance.

	  @since 0.2.1
	  @param child The {@link Result} to add.
	###
	addChild: (child) ->
		return @childs if not child
		return @childs.push child if child instanceof Result
		return @childs = @childs.concat child

	###
	  Returns the child {@link Result}s of this {@link Result} instance.

	  @since 0.2.1
	  @return The child {@link Result}s of this {@link Result} instance.
	###
	getChilds: -> @childs

	###
	  Sets the result message of this {@link Result} instance.

	  @since 0.2.1
	  @param message The message to set.
	###
	setMessage: (@message) ->

	###
	  Returns the result message of this {@link Result} instance.
	
	  @since 0.2.1
	  @return The result message of this {@link Result} instance.
	###
	getMessage: -> @message
module.exports = Result
		
