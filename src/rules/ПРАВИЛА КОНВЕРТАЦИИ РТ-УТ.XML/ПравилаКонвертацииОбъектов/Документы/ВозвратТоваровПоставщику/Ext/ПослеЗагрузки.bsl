

//нужные переменные
МетаданныеДокумента  = Объект.Метаданные();
ИскомыйСклад         = Справочники.Склады.ПустаяСсылка();
ИскомоеПодразделение = Справочники.Подразделения.ПустаяСсылка();

/// ШАПКА 

//получим нужные поля по коду магазина
ИмяПараметра = "КодМагазина";
Выполнить(Алгоритмы.ОпределитьПараметрыМагазина);

//общие реквизиты шапки
Выполнить(Алгоритмы.ОбработкаШапки);

//проверим, что контрагент - поставщик
Если ЗначениеЗаполнено(Объект.Контрагент) И Не Объект.Контрагент.Поставщик Тогда
	Контрагент = Объект.Контрагент.ПолучитьОбъект();
	Если Контрагент <> Неопределено Тогда
		Контрагент.Поставщик = Истина;
		Контрагент.Записать();
	КонецЕсли;
КонецЕсли;

//заполним поле договор
ДокументОбъект                  = Объект;
ВалютаРегламентированногоУчета  = Константы.ВалютаРегламентированногоУчета.Получить();
ВидДоговора                     = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком;
КонтрагентПараметр              = Объект.Контрагент;
ОрганизацияПараметр             = Объект.Организация;
ДатаПараметр                    = Объект.Дата;
ДоговорВТабличнойЧасти          = Ложь;
Выполнить(Алгоритмы.УстановитьДоговорПоКонтрагенту);

//вид поступления
Если ПараметрыОбъекта["ИспользованиеОрдернойСхемы"] Тогда
	
	Объект.ВидПередачи = Перечисления.ВидыПередачиТоваров.ПоОрдеру;
	
Иначе
	
	Объект.ВидПередачи = Перечисления.ВидыПередачиТоваров.СоСклада;
	
	//алгоритм по ордерной схеме..
КонецЕсли;

//заполним поле склад
Если Не ИскомыйСклад.Пустая() Тогда
	Объект.Склад = ИскомыйСклад;
КонецЕсли;

/// ТАБЛИЧНАЯ ЧАСТЬ

//заполним единицы измерения и, если нужно, номенклатуру (по характеристике)
ИмяТабличнойЧасти = "Товары";
ДокументОбъект = Объект;
Выполнить(Алгоритмы.ОбработкаТабличнойЧасти);

//заполним склад в табличной части тем же складом, который указан в шапке
Для Каждого СтрокаДокумента Из Объект.Товары Цикл
	СтрокаДокумента.Склад = Объект.Склад;
КонецЦикла;
