The xcode tool project is planed to be a collection of xcode tools.

Now, it contains the following tools:

####1. Code snippets management.

It is used for managing the snippets in xcode.

The default snippets are stored in the ~/Library/Developer/Xcode/UserData/CodeSnippets/

We can check out this git project and use a soft link to the target directory.

Usage:

	1. check out the project using: git clone https://github.com/tangqiaoboy/xcode_tool
	2. cd xcode_tool
	3. ./setup_snippets.sh


####2. A collection of shell utils

 * removeTailBlank.sh

It can remove tailing blank space in the .h & .m & .mm source file.

####3. NSString Wrapper

NSString Wrapper is a wrapper class to decorate NSString methods to java String style.

####4. Macro Utils

  * VersionCompare.h 

Macros used for version comparison.

* MacroUtils.h

Macros used for debuging and I18N.

* UIContants.h     

Macros used for UI.

####5. Encoding Utils

* Base64 

The author is Matt Gallagher. I got the code from [http://cocoawithlove.com/2009/06/base64-encoding-options-on-mac-and.     html](http://cocoawithlove.com/2009/06/base64-encoding-options-on-mac-and.html) . The copyright info is in the header of the relevant source file.

* JSON         

If you want a json lib, I recommend [JSONKit](https://github.com/johnezang/JSONKit) .As I know, it's faster than any other open source json libraries. You can get it using: 

    ```
    git clone https://github.com/johnezang/JSONKit.git
    ```


