# Copyright (c) 2012 Fabian M.
# See the AUTHORS file for all contributors of the Kaffee project.
fs = require 'fs'
Path = require 'path'

###
  The {@link Workspace} class is a pointer to the workspace of a {@link Project}

  @version 0.1.1
  @author Fabian M. <mail.fabianm@gmail.com>
###
class Workspace

	###
	  The path pointing to the workspace.
	###
	path: "."

	###
	  Constructs a new {@link Workspace} instance.
	
	  @since 0.1.1
	  @param path The path pointing to the workspace.
	###
	constructor: (path = ".") ->
		this.path = Path.resolve path

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
	exists: -> fs.existsSync this.path

	###
	  Creates this workspace.
	
	  @since 0.1.1
	###
	create: -> fs.mkdirSync this.path
module.exports = Workspace
