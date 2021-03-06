Запрос = Новый Запрос("
|ВЫБРАТЬ
|	ВзаиморасчетыСКонтрагентамиОстатки.Организация                                         КАК Организация,
|	ВзаиморасчетыСКонтрагентамиОстатки.Сделка                                              КАК Сделка,
|	ВЫРАЗИТЬ(ВзаиморасчетыСКонтрагентамиОстатки.Сделка КАК Документ.ЗаказПоставщику).Дата  КАК ДатаРасчетногоДокумента,
|	ВЫРАЗИТЬ(ВзаиморасчетыСКонтрагентамиОстатки.Сделка КАК Документ.ЗаказПоставщику).Номер КАК НомерРасчетногоДокумента,
|	ВзаиморасчетыСКонтрагентамиОстатки.Контрагент                                          КАК Партнер,
|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток                          КАК Сумма,
|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов             КАК Валюта
|ИЗ
|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(&ДатаОстатков, ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком)) КАК ВзаиморасчетыСКонтрагентамиОстатки
|ГДЕ
|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам)
|	И ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток > 0
|	И ВзаиморасчетыСКонтрагентамиОстатки.Сделка ССЫЛКА Документ.ЗаказПоставщику 
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
	НоваяСтрока.РасчетыСПартнерами.Колонки.Добавить("ДатаРасчетногоДокумента");
	НоваяСтрока.РасчетыСПартнерами.Колонки.Добавить("НомерРасчетногоДокумента");
	НоваяСтрока.РасчетыСПартнерами.Колонки.Добавить("Сумма");
	НоваяСтрока.РасчетыСПартнерами.Колонки.Добавить("Валюта");
	НоваяСтрока.РасчетыСПартнерами.Колонки.Добавить("РасчетныйДокумент");
	
	ВыборкаДетальныеЗаписи = ВыборкаПоОрганизациям.Выбрать(); 
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НоваяСтрокаРасчетыСПартнерами = НоваяСтрока.РасчетыСПартнерами.Добавить();	
		НоваяСтрокаРасчетыСПартнерами.Партнер                  = ВыборкаДетальныеЗаписи.Партнер;
		НоваяСтрокаРасчетыСПартнерами.Контрагент               = ВыборкаДетальныеЗаписи.Партнер;
		НоваяСтрокаРасчетыСПартнерами.ДатаРасчетногоДокумента  = ВыборкаДетальныеЗаписи.ДатаРасчетногоДокумента;
		НоваяСтрокаРасчетыСПартнерами.НомерРасчетногоДокумента = ВыборкаДетальныеЗаписи.НомерРасчетногоДокумента;
		НоваяСтрокаРасчетыСПартнерами.Сумма                    = ВыборкаДетальныеЗаписи.Сумма;
		НоваяСтрокаРасчетыСПартнерами.Валюта                   = ВыборкаДетальныеЗаписи.Валюта;
		НоваяСтрокаРасчетыСПартнерами.РасчетныйДокумент        = ВыборкаДетальныеЗаписи.Сделка;
		
	КонецЦикла;
		
КонецЦикла;
