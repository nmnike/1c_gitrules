Запрос = Новый Запрос("
|ВЫБРАТЬ
|	ВзаиморасчетыСПодотчетнымиЛицамиОстатки.Организация                КАК Организация,
|	ВзаиморасчетыСПодотчетнымиЛицамиОстатки.ФизЛицо                    КАК ПодотчетноеЛицо,
|	ВзаиморасчетыСПодотчетнымиЛицамиОстатки.РасчетныйДокумент          КАК РасчетныйДокумент,
|	ВзаиморасчетыСПодотчетнымиЛицамиОстатки.РасчетныйДокумент.Номер    КАК НомерРасчетногоДокумента,
|	ВзаиморасчетыСПодотчетнымиЛицамиОстатки.РасчетныйДокумент.Дата     КАК ДатаРасчетногоДокумента,
|	ВзаиморасчетыСПодотчетнымиЛицамиОстатки.СуммаВзаиморасчетовОстаток КАК Сумма,
|	ВзаиморасчетыСПодотчетнымиЛицамиОстатки.Валюта                     КАК Валюта
|ИЗ
|	РегистрНакопления.ВзаиморасчетыСПодотчетнымиЛицами.Остатки(&ДатаОстатков) КАК ВзаиморасчетыСПодотчетнымиЛицамиОстатки
|ГДЕ
|	ВзаиморасчетыСПодотчетнымиЛицамиОстатки.РасчетныйДокумент ССЫЛКА Документ.РасходныйКассовыйОрдер
|   ИЛИ ВзаиморасчетыСПодотчетнымиЛицамиОстатки.РасчетныйДокумент ССЫЛКА Документ.ПриходныйКассовыйОрдер 
|
|УПОРЯДОЧИТЬ ПО
|	ВзаиморасчетыСПодотчетнымиЛицамиОстатки.ФизЛицо.Наименование 	
| 
|ИТОГИ ПО
|	Организация
|");

Запрос.УстановитьПараметр("ДатаОстатков", КонецДня(Параметры.ДатаОстатков));

ВыборкаДанных = Новый ТаблицаЗначений;
ВыборкаДанных.Колонки.Добавить("Дата");
ВыборкаДанных.Колонки.Добавить("Организация");
ВыборкаДанных.Колонки.Добавить("РасчетыСПодотчетниками");

РезультатыЗапроса = Запрос.Выполнить();
ВыборкаПоОрганизациям = РезультатыЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
Пока ВыборкаПоОрганизациям.Следующий() Цикл
	
	НоваяСтрока = ВыборкаДанных.Добавить();
	НоваяСтрока.Дата        = КонецДня(Параметры.ДатаОстатков); 
	НоваяСтрока.Организация = ВыборкаПоОрганизациям.Организация; 
	
	НоваяСтрока.РасчетыСПодотчетниками = Новый ТаблицаЗначений;
	НоваяСтрока.РасчетыСПодотчетниками.Колонки.Добавить("ПодотчетноеЛицо");
	НоваяСтрока.РасчетыСПодотчетниками.Колонки.Добавить("ДатаРасчетногоДокумента");
	НоваяСтрока.РасчетыСПодотчетниками.Колонки.Добавить("НомерРасчетногоДокумента");
	НоваяСтрока.РасчетыСПодотчетниками.Колонки.Добавить("Сумма");
	НоваяСтрока.РасчетыСПодотчетниками.Колонки.Добавить("Валюта");
	
	ВыборкаДетальныеЗаписи = ВыборкаПоОрганизациям.Выбрать(); 
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если ВыборкаДетальныеЗаписи.Сумма < 0.00 Тогда
			СтрокаСообщения = "Обнаружен отрицательный остаток по подотчетному лицу ""%1"" при выгрузке по правилу: ""%2""";
			СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%1", ВыборкаДетальныеЗаписи.ПодотчетноеЛицо);
			СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%2", "Долги подотчетников по наличным средствам");
			Сообщить(СтрокаСообщения, СтатусСообщения.ОченьВажное);
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(ВыборкаДетальныеЗаписи.РасчетныйДокумент) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
			СтрокаСообщения = "Обнаружен остаток по расчетному документу вида ""Приходный кассовый ордер"" по подотчетному лицу ""%1"" при выгрузке по правилу: ""%2""";
			СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%1", ВыборкаДетальныеЗаписи.ПодотчетноеЛицо);
			СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%2", "Долги подотчетников по наличным средствам");
			Сообщить(СтрокаСообщения, СтатусСообщения.ОченьВажное);
			Продолжить;
		КонецЕсли;
		
		НоваяСтрокаРасчетыСПодотчетниками = НоваяСтрока.РасчетыСПодотчетниками.Добавить();	
		НоваяСтрокаРасчетыСПодотчетниками.ПодотчетноеЛицо          = ВыборкаДетальныеЗаписи.ПодотчетноеЛицо;
		НоваяСтрокаРасчетыСПодотчетниками.ДатаРасчетногоДокумента  = ВыборкаДетальныеЗаписи.ДатаРасчетногоДокумента;
		НоваяСтрокаРасчетыСПодотчетниками.НомерРасчетногоДокумента = ВыборкаДетальныеЗаписи.НомерРасчетногоДокумента;
		НоваяСтрокаРасчетыСПодотчетниками.Сумма                    = ВыборкаДетальныеЗаписи.Сумма;
		НоваяСтрокаРасчетыСПодотчетниками.Валюта                   = ВыборкаДетальныеЗаписи.Валюта;
		
	КонецЦикла;
	
	Если НоваяСтрока.РасчетыСПодотчетниками.Количество() = 0 Тогда
		ВыборкаДанных.Удалить(НоваяСтрока);	
	КонецЕсли;
	
КонецЦикла;
