package test;

import org.tamina.utils.HTMLUtils;

typedef BrowserInfo = {
	type:BrowserType,
	version:Int
};

class HTMLUtilsTest {

	public static function main():Void {
		var userAgents:Array<String> = [
			"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36",
			"Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.93 Safari/537.36",
			"Mozilla/5.0 (Windows NT 6.2) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.26 Safari/537.11",
			"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246",
			"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1",
			"Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:23.0) Gecko/20131011 Firefox/23.0",
			"Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; AS; rv:11.0) like Gecko",
			"Mozilla/5.0 (compatible, MSIE 11, Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko",
			"Mozilla/5.0 (compatible; MSIE 10.6; Windows NT 6.1; Trident/5.0; InfoPath.2; SLCC1; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 2.0.50727) 3gpp-gba UNTRUSTED/1.0",
			"Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)",
			"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; chromeframe/13.0.782.215)",
			"Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; Media Center PC 6.0; InfoPath.2; MS-RTC LM 8)",
			"Mozilla/4.0 (Windows; MSIE 6.0; Windows NT 5.0)",
			"Opera/9.80 (X11; Linux i686; Ubuntu/14.10) Presto/2.12.388 Version/12.16",
			"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A",
			"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Safari/602.1.50",
		];

		for (ua in userAgents) {
			var browserInfo = getBrowserInfo(ua);
			trace(ua);
			trace(browserInfo.type, browserInfo.version);
		}
	}

	private static function getBrowserInfo(ua:String):BrowserInfo {
		var ret = {
			type: Unknown,
			version: -1
		};

		ret.type = HTMLUtils.getBrowserType(ua);
		
		ret.version = switch (ret.type) {
			case Chrome:
			HTMLUtils.getChromeVersion(ua);

			case Safari:
			HTMLUtils.getSafariVersion(ua);

			case FireFox:
			HTMLUtils.getFirefoxVersion(ua);

			case IE:
			HTMLUtils.getIEVersion(ua);

			default:
			-1;

			// TODO:
			// case Android;
			// case WebKitOther;
			// case Opera;
			// case Unknown;
		};

		return ret;
	}

}