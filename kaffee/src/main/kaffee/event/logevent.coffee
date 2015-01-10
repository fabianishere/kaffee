###
  A {@link LogEvent} instance represents a Kaffee log message.

  @author Fabian M. <mail.fabianm@gmail.com>
###
class LogEvent

	###
	  Constructs a new {@link LogEvent}.

	  @since 0.3.0
	  @param manager The {@link EventManager} of this {@link LogEvent}.
	  @param level The level of this {@link LogEvent}.
	  @param message The message of this {@link LogEvent}.
	  @param stack The stacktrace.
	  @param callee The arguments.callee variable to provide more accurate stacktraces.
	###
	constructor: (@manager, @level, @message = "", @stack = "", callee = null) ->
		this.message = message.message if message instanceof Error
		this.stack ||= message.stack if message
		unless this.stack
			err = new Error this.message
			err.name = ""
			Error.captureStackTrace(err, callee || arguments.callee);
			this.stack = err.stack
		this.time = Date.now()
	###
	  Returns the {@link EventManager} of this {@link LogEvent}.

	  @since 0.3.0
	  @return The {@link EventManager} of this {@link LogEvent}.
	###
	getEventManager: -> this.manager

	###
	  Returns the message of this {@link LogEvent}.

	  @since 0.3.0
	  @return The message of this {@link LogEvent}.
	###
	getMessage: -> this.message

	###
	  Sets the message of this {@link LogEvent}.

	  @since 0.3.0
	  @param message The message to set.
	###
	setMessage: (message) -> 
		this.message = message
		this

	###
	  Returns the level of this {@link LogEvent}.

	  @since 0.3.0
	  @return The level of this {@link LogEvent}.
	###
	getLevel: -> this.level

	###
	  Sets the level of this {@link LogEvent}.

	  @since 0.3.0
	  @param level The level to set.
	###
	setLevel: (@level) -> this

	###
	  Returns the time in milliseconds of this {@link LogEvent}.

	  @since 0.3.0
	  @return The time in milliseconds.
	###
	getTime: -> this.time

	###
	  Sets the time in milliseconds of this {@link LogEvent}.

	  @since 0.3.0
	  @param time The time to set.
	###
	setTime: (@time) -> this.time = time

	###
	  Determines if this {@link LogEvent} has a stack or not.
	  
	  @since 0.3.0
	  @return <code>true</code> if this {@link LogEvent} has a stack, <code>false</code> otherwise.
	###
	hasStack: -> this.stack.length > 0
	
	###
	  Returns the stack of this {@link LogEvent}.

	  @since 0.3.0
	  @return The stack of this {@link LogEvent}.
	###
	getStack: -> this.stack

	###
	  Sets the stack of this {@link LogEvent}.

	  @since 0.3.0
	  @param stack The stack to set.
	###
	setStack: (@stack) -> this

module.exports = LogEvent
