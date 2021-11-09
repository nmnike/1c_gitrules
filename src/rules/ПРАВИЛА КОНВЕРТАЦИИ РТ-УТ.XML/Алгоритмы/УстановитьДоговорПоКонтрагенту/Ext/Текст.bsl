﻿Если ЗначениеЗаполнено(КонтрагентПараметр) 
   И (Не ЗначениеЗаполнено(ДокументОбъект.ДоговорКонтрагента) Или КонтрагентПараметр <> ДокументОбъект.ДоговорКонтрагента.Владелец) Тогда

	СписокВидовДоговоров = Новый СписокЗначений;
	СписокВидовДоговоров.Добавить(ВидДоговора);

	СтруктураПараметров = Новый Структура("ВалютаВзаиморасчетовДоговора, СписокДопустимыхВидовДоговоров");
	СтруктураПараметров.Вставить("ВалютаВзаиморасчетовДоговора"  , ВалютаРегламентированногоУчета);
	СтруктураПараметров.Вставить("СписокДопустимыхВидовДоговоров", СписокВидовДоговоров);
	
	ДоговорКонтрагента = ЗаполнениеДокументов.ПолучитьДоговорПоОрганизацииИКонтрагенту(ОрганизацияПараметр, КонтрагентПараметр, СтруктураПараметров);

	Если ДоговорКонтрагента = Неопределено Тогда
		
		НовыйДоговор                       = Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
		НовыйДоговор.ОбменДанными.Загрузка = Истина;
		НовыйДоговор.ВалютаВзаиморасчетов  = Параметры.ВалютаРегламентированногоУчета;
		НовыйДоговор.Владелец              = КонтрагентПараметр;
		НовыйДоговор.ВидДоговора           = ВидДоговора;
		НовыйДоговор.Наименование          = "Договор создан из ""1С:Розница 8""";
		НовыйДоговор.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом;
		
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("Организация", МетаданныеДокумента) И ЗначениеЗаполнено(Объект.Организация) Тогда
			НовыйДоговор.Организация = Объект.Организация;
		Иначе
			НовыйДоговор.Организация = Параметры.РазрешеннаяОрганизация;
		КонецЕсли;
		
		Если ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком Тогда
			
			
				КонтрагентОбъект = КонтрагентПараметр.ПолучитьОбъект();
				Если КонтрагентОбъект<>Неопределено И  НЕ КонтрагентПараметр.Поставщик Тогда   
				КонтрагентОбъект.ОбменДанными.Загрузка = Истина;
				КонтрагентОбъект.Поставщик = Истина;
				КонтрагентОбъект.Записать();
				КонецЕсли;
			
			
		ИначеЕсли ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда
			
				КонтрагентОбъект = КонтрагентПараметр.ПолучитьОбъект();
			Если КонтрагентОбъект<>Неопределено И  НЕ КонтрагентПараметр.Покупатель Тогда 
                КонтрагентОбъект.ОбменДанными.Загрузка = Истина;
				КонтрагентОбъект.Покупатель = Истина;
				КонтрагентОбъект.Записать();
			КонецЕсли;
			
		КонецЕсли;
		
		НовыйДоговор.Записать();
		
		ДоговорКонтрагента = НовыйДоговор.Ссылка;

	КонецЕсли;
	
	ДокументОбъект.ДоговорКонтрагента = ДоговорКонтрагента;
	
	Если Не ДоговорВТабличнойЧасти Тогда
			
		СтруктураКурсаДокумента = МодульВалютногоУчета.ПолучитьКурсВалюты(ДоговорКонтрагента.ВалютаВзаиморасчетов, ДокументОбъект.Дата);
		
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("ВалютаДокумента", МетаданныеДокумента) Тогда
			ДокументОбъект.ВалютаДокумента = ДоговорКонтрагента.ВалютаВзаиморасчетов;
		КонецЕсли;

		Если ЗначениеЗаполнено(ДоговорКонтрагента.ОсновнойПроект) Тогда
			ДокументОбъект.Проект = ДоговорКонтрагента.ОсновнойПроект;
		КонецЕсли;
		
		// В некоторых документах курс и кратность документа отсутствуют.
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("КурсДокумента", МетаданныеДокумента) Тогда
			ДокументОбъект.КурсДокумента           = СтруктураКурсаДокумента.Курс;
		КонецЕсли;
		
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("КратностьДокумента", МетаданныеДокумента) Тогда
			ДокументОбъект.КратностьДокумента      = СтруктураКурсаДокумента.Кратность;
		КонецЕсли;
		
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("КурсВзаиморасчетов", МетаданныеДокумента) Тогда
			ДокументОбъект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
		КонецЕсли;
		
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("КратностьВзаиморасчетов", МетаданныеДокумента) Тогда
			ДокументОбъект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;
		КонецЕсли;
		
	Иначе
		
		СтруктураКурсаДокумента = МодульВалютногоУчета.ПолучитьКурсВалюты(ДоговорКонтрагента.ВалютаВзаиморасчетов, ДатаПараметр);
		
		Если ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("КурсВзаиморасчетов", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
			ДокументОбъект.КурсВзаиморасчетов      = СтруктураКурсаДокумента.Курс;
		КонецЕсли;
		
		Если ОбщегоНазначения.ЕстьРеквизитТабЧастиДокумента("КратностьВзаиморасчетов", МетаданныеДокумента, ИмяТабличнойЧасти) Тогда
			ДокументОбъект.КратностьВзаиморасчетов = СтруктураКурсаДокумента.Кратность;
		КонецЕсли;
		
	КонецЕсли;
	
КонецЕсли;
