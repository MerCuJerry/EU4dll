#include "pch.h"
#include "plugin_64.h"

namespace CBitmapFont {
	extern "C" {
		void cBitmapFontProc1();
		void cBitmapFontProc2();
		uintptr_t cBitmapFontProc1ReturnAddress;
		uintptr_t cBitmapFontProc2ReturnAddress;
	}

	DllError cBitmapFontProc1Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			// movzx   eax, byte ptr [rdi+rax]
			BytePattern::temp_instance().find_pattern("0F B6 04 07 49 8B 8C C7 20 01 00 00");
			if (BytePattern::temp_instance().has_size(1, u8"フォント読み出し")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// jz      xxxxxx
				cBitmapFontProc1ReturnAddress = address + 0x0F;

				Injector::MakeJMP(address, cBitmapFontProc1, true);
			}
			else {
				e.cBitmapFont.unmatchdCBitmapFontProc1Injector = true;
			}
			break;
		default:
			e.cBitmapFont.versionCBitmapFontProc1Injector = true;
		}

		return e;
	}

	DllError cBitmapFontProc2Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			// mov     r13d, edi
			BytePattern::temp_instance().find_pattern("44 8B EF F3 41 0F 10 B4 24 48 08 00 00");
			if (BytePattern::temp_instance().has_size(1, u8"フォント読み出し")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// jz      xxxxxx
				cBitmapFontProc2ReturnAddress = address + 0x19;

				Injector::MakeJMP(address, cBitmapFontProc2, true);
			}
			else {
				e.cBitmapFont.unmatchdCBitmapFontProc2Injector = true;
			}
			break;
		default:
			e.cBitmapFont.versionCBitmapFontProc2Injector = true;
		}

		return e;
	}

	DllError Init(RunOptions options) {
		DllError result = {};

		result |= cBitmapFontProc1Injector(options);

		// CBitmapFont::GetRequiredSize
		result |= cBitmapFontProc2Injector(options);

		return result;
	}
}