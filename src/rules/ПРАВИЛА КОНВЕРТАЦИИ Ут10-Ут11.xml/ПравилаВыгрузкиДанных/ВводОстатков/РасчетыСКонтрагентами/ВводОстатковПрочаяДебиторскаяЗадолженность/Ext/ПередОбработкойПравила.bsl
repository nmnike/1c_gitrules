﻿Запрос = Новый Запрос("
|ВЫБРАТЬ
|	&ДатаОстатков                                                              КАК ДатаПлатежа,
|	ВзаиморасчетыСКонтрагентамиОстатки.Организация                             КАК Организация,
|	ВзаиморасчетыСКонтрагентамиОстатки.Сделка                                  КАК Сделка,
|	ВзаиморасчетыСКонтрагентамиОстатки.Контрагент                              КАК Партнер,
|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток              КАК Сумма,
|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК Валюта
|ИЗ
|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(&ДатаОстатков, ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.Прочее)) КАК ВзаиморасчетыСКонтрагентамиОстатки
|ГДЕ
|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток > 0
|
|УПОРЯДОЧИТЬ ПО
|	ВзаиморасчетыСКонтрагентамиОстатки.Контрагент.Наименование 	
|
|ИТОГИ ПО
|	Организация
|");

Запрос.УстановитьПараметр("ДатаОстатков", КонецДня(Параметры.ДатаОстатков));

ВыборкаДанных = Новый ТаблицаЗначений;
ВыборкаДанных.Колонки.Добавить("Дата");
ВыборкаДанных.Колонки.Добавить("Организация");
ВыборкаДанных.Колонки.Добавить("РасчетыСПартнерами");

РезультатыЗапроса = Запрос.Выполнить();
ВыборкаПоОрганизациям = РезультатыЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
Пока ВыборкаПоОрганизациям.Следующий() Цикл
	
	НоваяСтрока = ВыборкаДанных.Добавить();
	НоваяСтрока.Дата        = КонецДня(Параметры.ДатаОстатков); 
	НоваяСтрока.Организация = ВыборкаПоОрганизациям.Организация; 
	
	НоваяСтрока.РасчетыСПартнерами = Новый ТаблицаЗначений;
	НоваяСтрока.РасчетыСПартнерами.Колонки.Добавить("Партнер");
	НоваяСтрока.РасчетыСПартнерами.Колонки.Добавить("Контрагент");
	НоваяСтрока.РасчетыСПартнерами.Колонки.Добавить("Сумма");
	НоваяСтрока.РасчетыСПартнерами.Колонки.Добавить("Валюта");
	НоваяСтрока.РасчетыСПартнерами.Колонки.Добавить("ДатаПлатежа");
	
	ВыборкаДетальныеЗаписи = ВыборкаПоОрганизациям.Выбрать(); 
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НоваяСтрокаРасчетыСПартнерами = НоваяСтрока.РасчетыСПартнерами.Добавить();	
		НоваяСтрокаРасчетыСПартнерами.Партнер                  = ВыборкаДетальныеЗаписи.Партнер;
		НоваяСтрокаРасчетыСПартнерами.Контрагент               = ВыборкаДетальныеЗаписи.Партнер;
		НоваяСтрокаРасчетыСПартнерами.Сумма                    = ВыборкаДетальныеЗаписи.Сумма;
		НоваяСтрокаРасчетыСПартнерами.Валюта                   = ВыборкаДетальныеЗаписи.Валюта;
		НоваяСтрокаРасчетыСПартнерами.ДатаПлатежа              = ВыборкаДетальныеЗаписи.ДатаПлатежа;
		
	КонецЦикла;
	
	НоваяСтрока.РасчетыСПартнерами.Свернуть("Партнер, Контрагент, Валюта, ДатаПлатежа", "Сумма");
	
КонецЦикла;
