Fs = require 'fs'
Path = require 'path'

###
  The {@link Workspace} class is a pointer to the workspace of a {@link Project}

  @author Fabian M. <mail.fabianm@gmail.com>
###
class Workspace

	###
	  Constructs a new {@link Workspace} instance.
	
	  @since 0.1.1
	  @param path The path pointing to the workspace.
	###
	constructor: (path = ".") -> this.path = Path.resolve path

	###
	  Returns the path pointing to the workspace.

	  @since 0.1.1
	  @return The path pointing to the workspace.
	###
	getPath: -> this.path

	###
	  Determines if this workspace exists or not.

	  @since 0.1.1
	  @return <code>true</code> if this workspace exists, <code>false</code> otherwise.
	###
	exists: -> Fs.existsSync this.path

	###
	  Creates this workspace.
	
	  @since 0.1.1
	###
	create: -> Fs.mkdirSync this.path
module.exports = Workspace
