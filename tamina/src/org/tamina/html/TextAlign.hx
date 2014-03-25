/*
* SakuraEditor
* Visit http://storage.sakuradesigner.microclimat.com/apps/api/ for documentation, updates and examples.
*
* Copyright (c) 2014 microclimat, inc.
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package org.tamina.html;

/**
* This is the description for my class.
* @author d.mouton
* @class Align
* @constructor
*/
@:enum abstract TextAlign(String) from String to String {
/** Specifies start edge alignment - text is aligned to match the writing order. Equivalent to setting 
		 * left in left-to-right text, or right in right-to-left text.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */

    public var START = "start";

/** Specifies end edge alignment - text is aligned opposite from the writing order. Equivalent to 
		 *  specifying right in left-to-right text, or left in right-to-left text. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */

    public var END = "end";

/** Specifies left edge alignment. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */

    public var LEFT = "left";

/** Specifies right edge alignment. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */

    public var RIGHT = "right";

/** Specifies center alignment within the container.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */

    public var CENTER = "center";

/** Specifies that text is justified within the lines so they fill the container space.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */

    public var JUSTIFY = "justify";

}
