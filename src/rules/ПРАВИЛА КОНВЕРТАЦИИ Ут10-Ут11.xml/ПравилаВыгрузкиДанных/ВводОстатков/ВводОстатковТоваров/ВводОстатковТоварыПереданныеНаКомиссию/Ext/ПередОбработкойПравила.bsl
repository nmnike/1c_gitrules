﻿Запрос = Новый Запрос("
|ВЫБРАТЬ
|	ЕСТЬNULL(ПартииТоваровПереданныеОстатки.ДокументПередачи.Организация,            ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
|	ЕСТЬNULL(ПартииТоваровПереданныеОстатки.ДоговорКонтрагента.Владелец,             ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК Контрагент,
|	ЕСТЬNULL(ПартииТоваровПереданныеОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов, ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка))      КАК ВалютаВзаиморасчетов,
|	ПартииТоваровПереданныеОстатки.ДоговорКонтрагента                      КАК ДоговорКонтрагента,
|	ПартииТоваровПереданныеОстатки.Номенклатура                            КАК Номенклатура,
|	ПартииТоваровПереданныеОстатки.ХарактеристикаНоменклатуры              КАК Характеристика,
|	ЕСТЬNULL(ТоварыПереданныеОстатки.КоличествоОстаток * ЕСТЬNULL(ПартииТоваровПереданныеОстатки.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент, 1), 0) КАК Количество,
|
|	ЕСТЬNULL((ПартииТоваровПереданныеОстатки.СтоимостьОстаток / ПартииТоваровПереданныеОстатки.КоличествоОстаток) * ТоварыПереданныеОстатки.КоличествоОстаток, 0) КАК Сумма,
|
|	ЕСТЬNULL(ТоварыПереданныеОстатки.СерияНоменклатуры.НомерГТД, ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)) КАК НомерГТД,
|	ЕСТЬNULL(ТоварыПереданныеОстатки.СерияНоменклатуры.СтранаПроисхождения, ЗНАЧЕНИЕ(Справочник.КлассификаторСтранМира.ПустаяСсылка)) КАК СтранаПроисхождения,
|	ЕСТЬNULL(ТоварыПереданныеОстатки.СерияНоменклатуры.ПометкаУдаления, Ложь) КАК ПометкаУдаления
|ИЗ
|	РегистрНакопления.ПартииТоваровПереданные.Остатки(&ДатаОстатков, СтатусПередачи = ЗНАЧЕНИЕ(Перечисление.СтатусыПолученияПередачиТоваров.НаКомиссию)) КАК ПартииТоваровПереданныеОстатки
|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыПереданные.Остатки КАК ТоварыПереданныеОстатки
|		ПО ПартииТоваровПереданныеОстатки.Номенклатура = ТоварыПереданныеОстатки.Номенклатура
|			И ПартииТоваровПереданныеОстатки.ХарактеристикаНоменклатуры = ТоварыПереданныеОстатки.ХарактеристикаНоменклатуры
|			И ПартииТоваровПереданныеОстатки.ДоговорКонтрагента = ТоварыПереданныеОстатки.ДоговорКонтрагента
|			И ПартииТоваровПереданныеОстатки.ДокументПередачи.Организация = ТоварыПереданныеОстатки.Организация
|
|УПОРЯДОЧИТЬ ПО
|	ПартииТоваровПереданныеОстатки.Номенклатура.Наименование, 	
|	ПартииТоваровПереданныеОстатки.ХарактеристикаНоменклатуры.Наименование 	
| 
|ИТОГИ ПО
|	Организация,
|	Контрагент,
|	ДоговорКонтрагента
|");

Запрос.УстановитьПараметр("ДатаОстатков", КонецДня(Параметры.ДатаОстатков));

ВыборкаДанных = Новый ТаблицаЗначений;
ВыборкаДанных.Колонки.Добавить("Дата");
ВыборкаДанных.Колонки.Добавить("Организация");
ВыборкаДанных.Колонки.Добавить("Партнер");
ВыборкаДанных.Колонки.Добавить("СоглашениеСКомиссионером");
ВыборкаДанных.Колонки.Добавить("Валюта");
ВыборкаДанных.Колонки.Добавить("Товары");

РезультатыЗапроса = Запрос.Выполнить();
ВыборкаПоОрганизациям = РезультатыЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
Пока ВыборкаПоОрганизациям.Следующий() Цикл
		
	ВыборкаПоКонтрагентам = ВыборкаПоОрганизациям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоКонтрагентам.Следующий() Цикл
		
		ВыборкаПоДоговорамКонтрагента = ВыборкаПоКонтрагентам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоДоговорамКонтрагента.Следующий() Цикл
			
			НоваяСтрока = ВыборкаДанных.Добавить();
			НоваяСтрока.Дата                     = КонецДня(Параметры.ДатаОстатков); 
			НоваяСтрока.Организация              = ВыборкаПоОрганизациям.Организация; 
			НоваяСтрока.Партнер                  = ВыборкаПоКонтрагентам.Контрагент; 
			НоваяСтрока.СоглашениеСКомиссионером = ВыборкаПоДоговорамКонтрагента.ДоговорКонтрагента; 
			НоваяСтрока.Валюта                   = ВыборкаПоДоговорамКонтрагента.ВалютаВзаиморасчетов; 
			
			НоваяСтрока.Товары = Новый ТаблицаЗначений;
			НоваяСтрока.Товары.Колонки.Добавить("Номенклатура");
			НоваяСтрока.Товары.Колонки.Добавить("Характеристика");
			НоваяСтрока.Товары.Колонки.Добавить("Количество");
			НоваяСтрока.Товары.Колонки.Добавить("Сумма");
			НоваяСтрока.Товары.Колонки.Добавить("Цена");
			НоваяСтрока.Товары.Колонки.Добавить("НомерГТД");
			
			ВыборкаДетальныеЗаписи = ВыборкаПоДоговорамКонтрагента.Выбрать(); 
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				Если ВыборкаДетальныеЗаписи.Количество < 0.00 Тогда
					СтрокаСообщения = "Обнаружен отрицательный остаток по товару ""%2"" при выгрузке по правилу: ""%3""";
					СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%2", ВыборкаДетальныеЗаписи.Номенклатура);
					СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%3", "Товары, переданные на комиссию");
					Сообщить(СтрокаСообщения, СтатусСообщения.ОченьВажное);
					Продолжить;
				КонецЕсли;
				Если ВыборкаДетальныеЗаписи.Сумма < 0.00 Тогда
					СтрокаСообщения = "Обнаружен некорректный суммовой остаток по товару ""%2"" при выгрузке по правилу: ""%3""";
					СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%2", ВыборкаДетальныеЗаписи.Номенклатура);
					СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%3", "Товары, переданные на комиссию");
					Сообщить(СтрокаСообщения, СтатусСообщения.ОченьВажное);
					Продолжить;
				КонецЕсли;
				Если ВыборкаДетальныеЗаписи.Количество = 0.00 И ВыборкаДетальныеЗаписи.Сумма > 0.00 Тогда
					СтрокаСообщения = "Обнаружен некорректный суммовой остаток по товару ""%2"" при выгрузке по правилу: ""%3""";
					СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%2", ВыборкаДетальныеЗаписи.Номенклатура);
					СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%3", "Товары, переданные на комиссию");
					Сообщить(СтрокаСообщения, СтатусСообщения.ОченьВажное);
					Продолжить;
				КонецЕсли;
				
				НоваяСтрокаТовары = НоваяСтрока.Товары.Добавить();	
				НоваяСтрокаТовары.Номенклатура       = ВыборкаДетальныеЗаписи.Номенклатура;
				НоваяСтрокаТовары.Характеристика     = ВыборкаДетальныеЗаписи.Характеристика;
				НоваяСтрокаТовары.Количество         = ВыборкаДетальныеЗаписи.Количество;
				НоваяСтрокаТовары.Сумма              = ВыборкаДетальныеЗаписи.Сумма;
				Если ВыборкаДетальныеЗаписи.Количество <> 0 Тогда
					НоваяСтрокаТовары.Цена = ВыборкаДетальныеЗаписи.Сумма / ВыборкаДетальныеЗаписи.Количество;
				Иначе
					НоваяСтрокаТовары.Цена = 0;
				КонецЕсли;
			
				Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.НомерГТД) Тогда
					НоваяСтрокаТовары.НомерГТД = Новый Структура;
					НоваяСтрокаТовары.НомерГТД.Вставить("Владелец", ВыборкаДетальныеЗаписи.Номенклатура);
					НоваяСтрокаТовары.НомерГТД.Вставить("СтранаПроисхождения", ВыборкаДетальныеЗаписи.СтранаПроисхождения);
					НоваяСтрокаТовары.НомерГТД.Вставить("ПометкаУдаления", ВыборкаДетальныеЗаписи.ПометкаУдаления);
					НоваяСтрокаТовары.НомерГТД.Вставить("Код", ВыборкаДетальныеЗаписи.НомерГТД);
				КонецЕсли;
				
			КонецЦикла;
			
			Если НоваяСтрока.Товары.Количество() = 0 Тогда
				ВыборкаДанных.Удалить(НоваяСтрока);	
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецЦикла;
