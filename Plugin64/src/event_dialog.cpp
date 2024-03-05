﻿#include "pch.h"
#include "plugin_64.h"

namespace EventDialog {
	extern "C" {
		void eventDialogProc1V132();
		void eventDialogProc2();
		void eventDialogProc3V132();
		uintptr_t eventDialogProc1ReturnAddress;
		uintptr_t eventDialogProc2ReturnAddress1;
		uintptr_t eventDialogProc2ReturnAddress2;
		uintptr_t eventDialogProc3ReturnAddress;
	}

	DllError eventDialog1Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			// movzx   eax, byte ptr [rdx+rax]
			BytePattern::temp_instance().find_pattern("0F B6 04 02 49 8B 34 C2 F3 41 0F 10 8A 48 08 00 00");
			if (BytePattern::temp_instance().has_size(1, u8"文字取得処理")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// jz      loc_xxxxx
				eventDialogProc1ReturnAddress = address + 0x14;

				Injector::MakeJMP(address, eventDialogProc1V132, true);
			}
			else {
				e.eventDialog.unmatchdEventDialog1Injector = true;
			}
			break;
		default:
			e.eventDialog.versionEventDialog1Injector = true;
		}

		return e;
	}

	DllError eventDialog2Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			// mov     rax, [rsp+1158h+arg_20]
			BytePattern::temp_instance().find_pattern("48 8B 84 24 80 11 00 00 8B 00 03 C0");
			if (BytePattern::temp_instance().has_size(1, u8"分岐処理修正戻り先アドレス２")) {
				eventDialogProc2ReturnAddress2 = BytePattern::temp_instance().get_first().address();
			}
			else {
				e.eventDialog.unmatchdEventDialog2Injector = true;
			}

			// cvtdq2ps xmm0, xmm0
			BytePattern::temp_instance().find_pattern("0F 5B C0 F3 0F 59 C1 41 0F 2E C0 7A 4D");
			if (BytePattern::temp_instance().has_size(1, u8"分岐処理修正")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// movd    xmm0, [rsp+11158h+arg_8]
				eventDialogProc2ReturnAddress1 = address + 0x0F;

				Injector::MakeJMP(address, eventDialogProc2, true);
			}
			else {
				e.eventDialog.unmatchdEventDialog2Injector = true;
			}
			break;
		default:
			e.eventDialog.versionEventDialog2Injector = true;
		}

		return e;
	}


	DllError eventDialog3Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			// inc     edi
			BytePattern::temp_instance().find_pattern("FF C7 3B 7B 10 44 8B 84 24 70 11 00 00");
			if (BytePattern::temp_instance().has_size(1, u8"カウントアップ")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				//  mov     r11, 0BFFFFFF43FFFFFFh
				eventDialogProc3ReturnAddress = address + 0x14;

				Injector::MakeJMP(address, eventDialogProc3V132, true);
			}
			else {
				e.eventDialog.unmatchdEventDialog3Injector = true;
			}
			break;
		default:
			e.eventDialog.versionEventDialog3Injector = true;
		}

		return e;
	}

	DllError Init(RunOptions options) {
		DllError result = {};

		// CBitmapFont::GetActualRequiredSize

		result |= eventDialog1Injector(options);
		result |= eventDialog2Injector(options);
		result |= eventDialog3Injector(options);

		return result;
	}
}