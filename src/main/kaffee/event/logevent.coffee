# Copyright (c) 2012 Fabian M.
# See the AUTHORS file for all contributors of the Kaffee project.

###
  A {@link LogEvent} instance represents a Kaffee log message.

  @version 0.2.1
  @author Fabian M. <mail.fabianm@gmail.com>
###
class LogEvent

	###
	  The message of this {@link LogEvent}.
	###
	message: ""

	###
	  The level of this {@link LogEvent}.
	###
	level: null

	###
	  The time of this {@link LogEvent}.
	###
	time: 0

	###
	  The stacktrace of this {@link LogEvent}.
	###
	stack: []

	###
	  The {@link EventManager} of this {@link LogEvent}.
	###
	manager: null
	
	###
	  Constructs a new {@link LogEvent}.

	  @since 0.3.0
	  @param manager The {@link EventManager} of this {@link LogEvent}.
	  @param level The level of this {@link LogEvent}.
	  @param message The message of this {@link LogEvent}.
	  @param stack The stacktrace.
	###
	constructor: (manager, level, message, stack = null) ->
		this.manager = manager
		this.level = level
		this.message = message
		this.time = Date.now()
		this.stack = message.stack if message.stack
		this.stack = stack if stack
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
	setLevel: (level) -> 
		this.level = level
		this

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
	setTime: (time) -> 
		this.time = time
		this

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
	setStack: (stack) -> 
		this.stack = stack
		this

module.exports = LogEvent
