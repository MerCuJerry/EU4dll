#include "pch.h"
#include "plugin_64.h"

namespace Localization {
	extern "C" {
		void localizationProc2();
		void localizationProc3V130();
		void localizationProc4V130();
		void localizationProc5V131();
		void localizationProc6();
		void localizationProc7V131();
		void localizationProc8();

		uintptr_t localizationProc1CallAddress1;
		uintptr_t localizationProc1CallAddress2;
		uintptr_t localizationProc2ReturnAddress;
		uintptr_t localizationProc3ReturnAddress;
		uintptr_t localizationProc4ReturnAddress;
		uintptr_t localizationProc5ReturnAddress;
		uintptr_t localizationProc6ReturnAddress;
		uintptr_t localizationProc7ReturnAddress;
		uintptr_t localizationProc8ReturnAddress;

		uintptr_t localizationProc7CallAddress1;
		uintptr_t localizationProc7CallAddress2;

		uintptr_t generateCString;
		uintptr_t concatCString;
		uintptr_t concat2CString;

		uintptr_t JmpAddress;
		uintptr_t year;
		uintptr_t month;
		uintptr_t day;
	}

	DllError localizationProc1Injector(RunOptions options){
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			// mov     [rsp+arg_10], rbx
			BytePattern::temp_instance().find_pattern("48 89 5C 24 18 4C 89 74 24 20 41 57 48 83 EC 20");
			if (BytePattern::temp_instance().has_size(1, u8"std::basic_string<char>#insertをフック")) {
				localizationProc1CallAddress1 = BytePattern::temp_instance().get_first().address();
			}
			else {
				e.localization.unmatchdLocalizationProc1Injector = true;
			}
			break;
		default:
			e.localization.versionLocalizationProc1Injector = true;
		}

		return e;
	}

	DllError localizationProc2Injector(RunOptions options) {
		DllError e = {};

		if (!options.reversingWordsBattleOfArea) return e;

		switch (options.version) {
		case v1_36_0_0:
			// mov     rax, [rdi+30h]
			BytePattern::temp_instance().find_pattern("48 8B 47 30 4C 8B 40 28 49 83 C0 10");
			if (BytePattern::temp_instance().has_size(1, u8"Battle of areaを逆転させる")) {
				// nop
				uintptr_t address = BytePattern::temp_instance().get_first().address(0x1D);

				// nop
				localizationProc2ReturnAddress = address + 0x13;

				Injector::MakeJMP(address, localizationProc2, true);
			}
			else {
				e.localization.unmatchdLocalizationProc2Injector = true;
			}
			break;
		default:
			BytePattern::LoggingInfo(u8"Battle of areaを逆転させる [NG]");
			e.localization.versionLocalizationProc2njector = true;
		}

		return e;
	}


	DllError localizationProc3Injector(RunOptions options) {
		DllError e = {};

		std::string pattern;

		switch (options.version) {
		case v1_36_0_0:
			pattern = "49 83 C9 FF 45 33 C0 48 8B D0 49 8B CF E8 D3 58 DC FF";
			// or      r9, 0FFFFFFFFFFFFFFFFh
			BytePattern::temp_instance().find_pattern(pattern);
			if (BytePattern::temp_instance().has_size(1, u8"MDEATH_HEIR_SUCCEEDS heir nameを逆転させる")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address();

				// nop
				localizationProc3ReturnAddress = address + 0x12;

				Injector::MakeJMP(address, localizationProc3V130, true);
			}
			else {
				e.localization.unmatchdLocalizationProc3Injector = true;
			}
			break;
		default:
			BytePattern::LoggingInfo(u8"MDEATH_HEIR_SUCCEEDS heir nameを逆転させる [NG]");
			e.localization.versionLocalizationProc3njector = true;
		}

		return e;
	}

	DllError localizationProc4Injector(RunOptions options) {
		DllError e = {};
		std::string pattern;
		int offset = 0;

		switch (options.version) {
		case v1_36_0_0:
			offset = 0x3C;
			pattern = "48 8B D8 48 8B 8E D8 18 00 00 48 89 8D 90 00 00 00 45 33 C9 45 33 C0 33 D2 48 8D 8D 90 00 00 00 E8 ? ? ? ? 4C 8B";
			// or      r9, 0FFFFFFFFFFFFFFFFh
			BytePattern::temp_instance().find_pattern(pattern);
			if (BytePattern::temp_instance().has_size(1, u8"MDEATH_REGENCY_RULE heir nameを逆転させる")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address(offset);

				// nop
				localizationProc4ReturnAddress = address + 0x12;

				// call {xxxxx} std::basic_string<char>#appendをフック。直接はバイナリパターンが多すぎでフックできなかった
				localizationProc1CallAddress2 = Injector::GetBranchDestination(address + 0xD).as_int();

				Injector::MakeJMP(address, localizationProc4V130, true);
			}
			else {
				e.localization.unmatchdLocalizationProc4Injector = true;
			}
			break;
		default:
			BytePattern::LoggingInfo(u8"MDEATH_REGENCY_RULE heir nameを逆転させる [NG]");
			e.localization.versionLocalizationProc4Injector = true;
		}

		return e;
	}

	DllError localizationProc5Injector(RunOptions options) {
		DllError e = {};
		std::string pattern;
		int offset = 0;

		switch (options.version) {
		case v1_36_0_0:
			pattern = "48 8B 4F 68 48 8B 01 FF 50 08 84 C0 74 5F 48 8B 07";
			offset = 0x40;
			// or      r9, 0FFFFFFFFFFFFFFFFh
			BytePattern::temp_instance().find_pattern(pattern);
			if (BytePattern::temp_instance().has_size(1, u8"nameを逆転させる")) {
				uintptr_t address = BytePattern::temp_instance().get_first().address(offset);

				// nop
				localizationProc5ReturnAddress = address + 0x12;

				Injector::MakeJMP(address, localizationProc5V131, true);
			}
			else {
				e.localization.unmatchdLocalizationProc5Injector = true;
			}
			break;
		default:
			e.localization.versionLocalizationProc5Injector = true;
			BytePattern::LoggingInfo(u8"nameを逆転させる [NG]");
		}

		return e;
	}

	DllError localizationProc6Injector(RunOptions options) {
		DllError e = {};
		std::string pattern;
		int offset = 0;

		switch (options.version) {
		case v1_36_0_0:
			break;
		default:
			BytePattern::LoggingInfo(u8"M, Y → Y年M [NG]");
			e.localization.versionLocalizationProc6Injector = true;
		}

		return e;
	}

	DllError localizationProc7Injector(RunOptions options) {
		DllError e = {};
		std::string pattern;

		switch (options.version) {
		case v1_36_0_0:
			break;
		default:
			BytePattern::LoggingInfo(u8"D M, Y → Y年MD日 [NG]");
			e.localization.versionLocalizationProc7Injector = true;
		}

		return e;
	}

	DllError localizationProc8Injector(RunOptions options) {
		DllError e = {};
		std::string pattern;

		switch (options.version) {
		case v1_36_0_0:
			pattern = "90 4C 8D 45 A7 48 8D 55 0F 48 8D 4D EF";
			// nop 
			BytePattern::temp_instance().find_pattern(pattern);
			if (BytePattern::temp_instance().has_size(1, u8"M Y → Y年M")) {
				// mov     r8d, 1
				uintptr_t address = BytePattern::temp_instance().get_first().address() - 0x16;

				generateCString = Injector::GetBranchDestination(address + 0x11).as_int();
				concatCString = Injector::GetBranchDestination(address + 0x23).as_int();
				concat2CString = Injector::GetBranchDestination(address + 0x33).as_int();

				// nop
				localizationProc8ReturnAddress = address + 0x38;

				Injector::MakeJMP(address, localizationProc8, true);
			}
			else {
				e.localization.unmatchdLocalizationProc8Injector = true;
			}
			break;
		default:
			BytePattern::LoggingInfo(u8"M Y → Y年M [NG]");
			e.localization.versionLocalizationProc8Injector = true;
		}

		return e;
	}

	DllError localizationProc9Injector(RunOptions options) {
		DllError e = {};

		switch (options.version) {
		case v1_36_0_0:
			BytePattern::temp_instance().find_pattern("20 2D 20 00 4D 4F 4E 54 48 53 00 00");
			if (BytePattern::temp_instance().has_size(1, u8"Replace space")) {
				intptr_t address = BytePattern::temp_instance().get_first().address();
				Injector::WriteMemory<BYTE>(address+0, 0x20,true);
				Injector::WriteMemory<BYTE>(address+1, 0x2D, true);
				Injector::WriteMemory<BYTE>(address+2, 0x20, true);
			}
			else {
				e.localization.unmatchdLocalizationProc9Injector = true;
			}
			break;
		default:
			BytePattern::LoggingInfo(u8"Replace space [NG]");
			e.localization.versionLocalizationProc9Injector = true;
		}

		return e;
	}

	DllError readYamlProcInjector(RunOptions options) { //put this function here temporarily
		DllError e = {};

		// jns eu4.7FF6F05B920E
		BytePattern::temp_instance().find_pattern("0F 89 03 03 00 00 41 C6 07 3F BE 02 00 00 00 B0 20 0F B6 0B 84 C8 74 0B");
		if (BytePattern::temp_instance().has_size(1, u8"修正读取Yaml本地化文件时报错")) {
			uintptr_t address = BytePattern::temp_instance().get_first().address();

			// direct jmp to eu4.7FF6F05B920E bypass the validator
			JmpAddress = address + 0x309;

			Injector::MakeJMP(address, JmpAddress, true);
		}
		else {
			e.mainText.unmatchdMainTextProc4Injector = true;
		}
		return e;

	}

	ParadoxTextObject _year;
	ParadoxTextObject _month;
	ParadoxTextObject _day;

	DllError Init(RunOptions options) {
		DllError result = {};

		_day.t.text[0] = 0xE;
		_day.t.text[1] = '\0';
		_day.len = 1;
		_day.len2 = 0xF;

		_year.t.text[0] = 0xF;
		_year.t.text[1] = '\0';
		_year.len = 1;
		_year.len2 = 0xF;

		_month.t.text[0] = 7;
		_month.t.text[1] = '\0';
		_month.len = 1;
		_month.len2 = 0xF;
		
		year = (uintptr_t) &_year;
		month = (uintptr_t)&_month;
		day = (uintptr_t)&_day;

		result |= readYamlProcInjector(options);
		// 関数アドレス取得
		result |= localizationProc1Injector(options);

		// Battle of areaを逆転させる
		// 確認方法）敵軍と戦い、結果のポップアップのタイトルを確認する
		result |= localizationProc2Injector(options);

		// MDEATH_HEIR_SUCCEEDS heir nameを逆転させる
		//result |= localizationProc3Injector(options);

		// MDEATH_REGENCY_RULE heir nameを逆転させる
		// ※localizationProc1CallAddress2のhookもこれで実行している
		result |= localizationProc4Injector(options);

		// nameを逆転させる
		// 確認方法）sub modを入れた状態で日本の大名を選択する。大名の名前が逆転しているかを確認する
		result |= localizationProc5Injector(options);

		// 年号の表示がM, YからY年M
		// 確認方法）オスマンで画面上部の停戦アラートのポップアップの年号を確認する
		result |= localizationProc6Injector(options);

		// 年号の表示がD M, YからY年MD日になる
		// 確認方法）スタート画面のセーブデータの日付を見る
		result |= localizationProc7Injector(options);

		// 年号の表示がM YからY年Mになる
		// 確認方法）外交官のポップアップを表示し、年号を確認する
		result |= localizationProc8Injector(options);

		// スペースを変更
		//result |= localizationProc9Injector(options);

		return result;
	}
}