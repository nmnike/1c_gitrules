﻿Запрос = Новый Запрос("
|ВЫБРАТЬ
|	ЕСТЬNULL(ПартииТоваровНаСкладахОстатки.ДокументОприходования.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
|	ПартииТоваровНаСкладахОстатки.Склад КАК Склад,
|	ПартииТоваровНаСкладахОстатки.Номенклатура КАК Номенклатура,
|	ПартииТоваровНаСкладахОстатки.ХарактеристикаНоменклатуры КАК Характеристика,
|	ПартииТоваровНаСкладахОстатки.СерияНоменклатуры.НомерГТД КАК НомерГТД,
|	ПартииТоваровНаСкладахОстатки.СерияНоменклатуры.СтранаПроисхождения КАК СтранаПроисхождения,
|	ПартииТоваровНаСкладахОстатки.СерияНоменклатуры.ПометкаУдаления КАК ПометкаУдаления,
|	СУММА(ПартииТоваровНаСкладахОстатки.КоличествоОстаток * ЕСТЬNULL(ПартииТоваровНаСкладахОстатки.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент, 1)) КАК Количество,
|	СУММА(ПартииТоваровНаСкладахОстатки.СтоимостьОстаток) КАК Стоимость
|ИЗ
|	РегистрНакопления.ПартииТоваровНаСкладах.Остатки(
|			&ДатаОстатков,
|			// Только собственные товары
|			СтатусПартии <> ЗНАЧЕНИЕ(Перечисление.СтатусыПартийТоваров.НаКомиссию)
|				И Номенклатура.ВидНоменклатуры.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)) КАК ПартииТоваровНаСкладахОстатки
|
|СГРУППИРОВАТЬ ПО
|	ПартииТоваровНаСкладахОстатки.Номенклатура,
|	ПартииТоваровНаСкладахОстатки.Склад,
|	ПартииТоваровНаСкладахОстатки.ХарактеристикаНоменклатуры,
|	ЕСТЬNULL(ПартииТоваровНаСкладахОстатки.ДокументОприходования.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)),
|	ПартииТоваровНаСкладахОстатки.СерияНоменклатуры.НомерГТД,
|	ПартииТоваровНаСкладахОстатки.СерияНоменклатуры.СтранаПроисхождения,
|	ПартииТоваровНаСкладахОстатки.СерияНоменклатуры.ПометкаУдаления
|
|УПОРЯДОЧИТЬ ПО
|	ПартииТоваровНаСкладахОстатки.Склад.Наименование, 	
|	ПартииТоваровНаСкладахОстатки.Номенклатура.Наименование, 	
|	ПартииТоваровНаСкладахОстатки.ХарактеристикаНоменклатуры.Наименование 	
| 
|ИТОГИ ПО
|	Организация,
|	Склад
|");

Запрос.УстановитьПараметр("ДатаОстатков", КонецДня(Параметры.ДатаОстатков));

ВыборкаДанных = Новый ТаблицаЗначений;
ВыборкаДанных.Колонки.Добавить("Дата");
ВыборкаДанных.Колонки.Добавить("Организация");
ВыборкаДанных.Колонки.Добавить("Склад");
ВыборкаДанных.Колонки.Добавить("Товары");

РезультатыЗапроса = Запрос.Выполнить();
ВыборкаПоОрганизациям = РезультатыЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
Пока ВыборкаПоОрганизациям.Следующий() Цикл
	
	ВыборкаПоСкладам = ВыборкаПоОрганизациям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоСкладам.Следующий() Цикл
		
		НоваяСтрока = ВыборкаДанных.Добавить();
		НоваяСтрока.Дата        = КонецДня(Параметры.ДатаОстатков); 
		НоваяСтрока.Организация = ВыборкаПоОрганизациям.Организация; 
		НоваяСтрока.Склад       = ВыборкаПоСкладам.Склад; 
		
		НоваяСтрока.Товары = Новый ТаблицаЗначений;
		НоваяСтрока.Товары.Колонки.Добавить("Номенклатура");
		НоваяСтрока.Товары.Колонки.Добавить("Характеристика");
		НоваяСтрока.Товары.Колонки.Добавить("Количество");
		НоваяСтрока.Товары.Колонки.Добавить("Цена");
		НоваяСтрока.Товары.Колонки.Добавить("Сумма");
		НоваяСтрока.Товары.Колонки.Добавить("НомерГТД");
		
		ВыборкаДетальныеЗаписи = ВыборкаПоСкладам.Выбрать(); 
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Если ВыборкаДетальныеЗаписи.Количество < 0.00 Тогда
				СтрокаСообщения = "Обнаружен отрицательный остаток на складе ""%1"" по товару ""%2"" при выгрузке по правилу: ""%3""";
				СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%1", ВыборкаПоСкладам.Склад);
				СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%2", ВыборкаДетальныеЗаписи.Номенклатура);
				СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%3", "Собственные товары на складах");
				Сообщить(СтрокаСообщения, СтатусСообщения.ОченьВажное);
				Продолжить;
			КонецЕсли;
			Если ВыборкаДетальныеЗаписи.Стоимость < 0.00 Тогда
				СтрокаСообщения = "Обнаружен некорректный суммовой остаток на складе ""%1"" по товару ""%2"" при выгрузке по правилу: ""%3""";
				СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%1", ВыборкаПоСкладам.Склад);
				СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%2", ВыборкаДетальныеЗаписи.Номенклатура);
				СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%3", "Собственные товары на складах");
				Сообщить(СтрокаСообщения, СтатусСообщения.ОченьВажное);
				Продолжить;
			КонецЕсли;
			Если ВыборкаДетальныеЗаписи.Количество = 0.00 И ВыборкаДетальныеЗаписи.Стоимость > 0.00 Тогда
				СтрокаСообщения = "Обнаружен некорректный суммовой остаток на складе ""%1"" по товару ""%2"" при выгрузке по правилу: ""%3""";
				СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%1", ВыборкаПоСкладам.Склад);
				СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%2", ВыборкаДетальныеЗаписи.Номенклатура);
				СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%3", "Собственные товары на складах");
				Сообщить(СтрокаСообщения, СтатусСообщения.ОченьВажное);
				Продолжить;
			КонецЕсли;
			
			НоваяСтрокаТовары = НоваяСтрока.Товары.Добавить();	
			НоваяСтрокаТовары.Номенклатура       = ВыборкаДетальныеЗаписи.Номенклатура;
			НоваяСтрокаТовары.Характеристика     = ВыборкаДетальныеЗаписи.Характеристика;
			НоваяСтрокаТовары.Количество         = ВыборкаДетальныеЗаписи.Количество;
			Если ВыборкаДетальныеЗаписи.Количество <> 0 Тогда 
				НоваяСтрокаТовары.Цена = ВыборкаДетальныеЗаписи.Стоимость / ВыборкаДетальныеЗаписи.Количество;
			КонецЕсли;
			НоваяСтрокаТовары.Сумма              = ВыборкаДетальныеЗаписи.Стоимость;
			
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
