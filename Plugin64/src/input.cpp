#include "pch.h"
#include "plugin_64.h"

// 1.28.3,1.29.3時点でSDLのversionは2.0.4 hg-10001:e12c38730512
namespace Input {
	extern "C" {
		void inputProc1V130();
		void inputProc2();
		void KeyPadLeftProc();
		void KeyPadRightProc();

		uintptr_t originalinputProcAddress;
		uintptr_t inputProc1ReturnAddress2;
		uintptr_t inputProc2ReturnAddress;
		uintptr_t KeyPadLeftReturnAddress;
		uintptr_t CursorAtZeroReturnAddress;
		uintptr_t KeyPadRightReturnAddress;
		uintptr_t KeyPadRightProcCallAddress;
	}

	DllError inputProc1Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			// mov     eax, dword ptr	[rbp+120h+var_18C]
			BytePattern::temp_instance().find_pattern("8B 45 94 32 DB 3C 80 73 05 0F B6 D8 EB 10");
			if (BytePattern::temp_instance().has_size(1, u8"入力した文字をutf8からエスケープ列へ変換する１")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// mov     rax, [r13+0] eu4.7FF7740F6104
				originalinputProcAddress = address + 0x1E;

				Injector::MakeJMP(address, inputProc1V130, true);
			}
			else {
				e.input.unmatchdInputProc1Injector = true;
			}
			// call    qword ptr [rax+18h]
			BytePattern::temp_instance().find_pattern("FF 50 18 E9 ? ? 00 00 49 8B 45 00");
			if (BytePattern::temp_instance().has_size(1, u8"入力した文字をutf8からエスケープ列へ変換する２")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();
				// jmp     loc_{xxxxx}
				inputProc1ReturnAddress2 = Injector::GetBranchDestination(address + 0x3).as_int();
			}
			else {
				e.input.unmatchdInputProc1Injector = true;
			}
			break;
		default:
			e.input.versionInputProc1Injector = true;
		}

		return e;
	}

	DllError inputProc2Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			// mov     rax, [rdi]
			BytePattern::temp_instance().find_pattern("48 8B 07 48 8B CF 85 DB 74 08 FF 90 40 01 00 00");
			if (BytePattern::temp_instance().has_size(1, u8"バックスペース処理の修正")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// movzx   r8d, word ptr [rdi+56h]
				inputProc2ReturnAddress = address + 0x18;

				Injector::MakeJMP(address, inputProc2, true);
			}
			else {
				e.input.unmatchdInputProc2Injector = true;
			}
			break;
		default:
			e.input.versionInputProc2Injector = true;
		}

		return e;
	}
	DllError KeyPadProcInjector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			//push 	rdi
			BytePattern::temp_instance().find_pattern("40 57 48 83 EC 40 0F B7 41 54 48 8B F9 66 85 C0");
			if (BytePattern::temp_instance().has_size(1, u8"keypadleft")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// movzx   r8d, word ptr [rdi+56h]
				KeyPadLeftReturnAddress = address + 0x15;
				CursorAtZeroReturnAddress = address + 0x1E;

				Injector::MakeJMP(address, KeyPadLeftProc, true);
			}
			else {
				e.input.unmatchdKeyPadLeftProcInjector = true;
			}
			BytePattern::temp_instance().find_pattern("48 8B C4 55 48 8D 68 A1 48 81 EC 90 00 00 00 48 C7 45 E7 FE FF FF FF 48 89 58 08 48 89 78 18 48 8B F9");
			if (BytePattern::temp_instance().has_size(1, u8"keypadrightcall")) {
				KeyPadRightProcCallAddress = BytePattern::temp_instance().get_first().address();
			}
			//mov rcx,rdi
			BytePattern::temp_instance().find_pattern("48 8B CF 8D 50 01 E8 6C ED FF FF 0F B7 47 54 89 47 50");
			if (BytePattern::temp_instance().has_size(1, u8"keypadright")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();
				// movzx eax,word ptr ds:[rdi+54]
				KeyPadRightReturnAddress = address + 0x0F;
				Injector::MakeJMP(address, KeyPadRightProc, true);
			}
			else {
				e.input.unmatchdKeyPadLeftProcInjector = true;
			}
			break;
		default:
			e.input.versionKeyPadLeftProcInjector = true;
		}

		return e;
	}

	DllError Init(RunOptions options) {
		DllError result = {};

		result |= inputProc1Injector(options);
		result |= inputProc2Injector(options);
		result |= KeyPadProcInjector(options);

		return result;
	}
}