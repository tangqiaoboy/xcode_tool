The xcode tool project is planed to be a collection of xcode tools.

Now, it contains 3 tool:

####1. Code snippets management.

It is used for managing the snippets in xcode.

The default snippets are stored in the ~/Library/Developer/Xcode/UserData/CodeSnippets/

We can check out this git project and use a soft link to the target directory.

Usage:

	1. check out the project using: git clone https://github.com/tangqiaoboy/xcode_tool
	2. cd xcode_tool
	3. ./setup_snippets.sh


####2. A collection of shell utils

	1. removeTailBlank.sh  It can remove tailing blank space in the .h & .m source file.

####3. NSString Wrapper

NSString Wrapper is a wrapper class to decorate NSString methods to java String style.
