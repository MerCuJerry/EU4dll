#include "pch.h"
#include "plugin_64.h"

using namespace std;

namespace Version {
	typedef struct _Pattern {
		char ascii1, ascii2, dot, ascii3;
		int calVer() {
			int ver = (ascii1 - 0x30) * 100 + (ascii2 - 0x30) * 10 + (ascii3 - 0x30);
			return ver;
		}
	} Pattern;

	string versionString(Eu4Version version) {
		switch (version) {
		case v1_36_0_0:
			return u8"v1_36_0_0";
		default:
			return u8"UNKNOWN";
		}
	}

	void GetVersionFromExe(RunOptions *options) {
		Eu4Version version = UNKNOWN;
		
		// EU4 v1.??.?
		BytePattern::temp_instance().find_pattern("45 55 34 20 76 31 2E ? ? 2E ?");
		if (BytePattern::temp_instance().count() > 0) {
			// ??を取得する
			Pattern minor = Injector::ReadMemory<Pattern>(BytePattern::temp_instance().get_first().address(0x7), true);

			switch (minor.calVer()) {
				case 362:
					version = v1_36_0_0;
				break;
			}
		}
		BytePattern::LoggingInfo(versionString(version));
		options->version = version;
	}
}