#include "pch.h"
#include "plugin_64.h"

namespace ListFieldAdjustment {
	extern "C" {
		void listFieldAdjustmentProc1_v1315();
		void listFieldAdjustmentProc2_v1315();
		void listFieldAdjustmentProc3_v1315();
		uintptr_t listFieldAdjustmentProc1ReturnAddress;
		uintptr_t listFieldAdjustmentProc2ReturnAddress;
		uintptr_t listFieldAdjustmentProc3ReturnAddress;
		uintptr_t listFieldAdjustmentProc2V1315ReturnAddress;
	}

	DllError listFieldAdjustmentProc1Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			// mov     rcx, [rbp+0D0h+var_130]
			BytePattern::temp_instance().find_pattern("48 8B 4D A0 F3 0F 10 B1 48 08 00 00 42 0F B6 04 20");
			if (BytePattern::temp_instance().has_size(1, u8"フォント読み出し")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// jz loc_xxxxx
				listFieldAdjustmentProc1ReturnAddress = address + 0x18;

				Injector::MakeJMP(address, listFieldAdjustmentProc1_v1315, true);
			}
			else {
				e.listFiledAdjustment.unmatchdListFieldAdjustmentProc1Injector = true;
			}
			break;
		default:
			e.listFiledAdjustment.versionListFieldAdjustmentProc1Injector = true;
		}

		return e;
	}

	DllError listFieldAdjustmentProc2Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			// inc     ebx
			BytePattern::temp_instance().find_pattern("FF C3 4C 8B 4F 10 41 3B D9 0F 8D 20 02 00 00");
			if (BytePattern::temp_instance().has_size(1, u8"カウントを進める")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// jge     loc_{xxxxx}
				listFieldAdjustmentProc2V1315ReturnAddress =
					Injector::GetBranchDestination(address + 0x09).as_int();

				// 
				listFieldAdjustmentProc2ReturnAddress = address + 0x0F;

				Injector::MakeJMP(address, listFieldAdjustmentProc2_v1315, true);
			}
			else {
				e.listFiledAdjustment.unmatchdListFieldAdjustmentProc2Injector = true;
			}
			break;
		default:
			e.listFiledAdjustment.versionListFieldAdjustmentProc2Injector = true;
		}

		return e;
	}

	DllError listFieldAdjustmentProc3Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			// mov     rcx, [rax+rcx*8]
			BytePattern::temp_instance().find_pattern("48 8B 0C C8 44 8B 0C 91 45 33 C0 48 8D 54 24 28");
			if (BytePattern::temp_instance().has_size(2, u8"文字列切り取り処理")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// call sub_xxxxx
				listFieldAdjustmentProc3ReturnAddress = address + 0x13;

				Injector::MakeJMP(address, listFieldAdjustmentProc3_v1315, true);
			}
			else {
				e.listFiledAdjustment.unmatchdListFieldAdjustmentProc3Injector = true;
			}
			break;
		default:
			e.listFiledAdjustment.versionListFieldAdjustmentProc3Injector = true;
		}

		return e;
	}

	DllError Init(RunOptions options) {
		DllError result = {};

		result |= listFieldAdjustmentProc1Injector(options);
		result |= listFieldAdjustmentProc2Injector(options);
		result |= listFieldAdjustmentProc3Injector(options);

		return result;
	}

}