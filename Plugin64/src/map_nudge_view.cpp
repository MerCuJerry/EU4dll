#include "pch.h"
#include "plugin_64.h"

namespace MapNudgeView {
	extern "C" {;
		void mapNudgeViewProc1V136();
		uintptr_t mapNudgeViewProc1ReturnAddress;
	}

	DllError mapNudgeViewProc1Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			//  movzx   eax, byte ptr [rax+rcx]
			BytePattern::temp_instance().find_pattern("0F B6 04 08 49 8B 94 C7 20 01 00 00");
			if (BytePattern::temp_instance().has_size(1, u8"nudge view")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// jz      short loc_xxxxx
				mapNudgeViewProc1ReturnAddress = address + 0xF;

				Injector::MakeJMP(address, mapNudgeViewProc1V136, true);
			}
			else {
				e.mapNudge.unmatchdMapNudgeViewProc1Injector = true;
			}
			break;
		default:
			e.mapNudge.versionMapNudgeViewProc1Injector = true;
		}

		return e;
	}

	DllError Init(RunOptions options) {
		DllError result = {};

		result |= mapNudgeViewProc1Injector(options);

		return result;
	}
}