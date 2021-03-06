

//нужные переменные
МетаданныеДокумента  = Объект.Метаданные();
ИскомоеПодразделение = Справочники.Подразделения.ПустаяСсылка();
ИскомыйСклад         = Справочники.Склады.ПустаяСсылка();

/// ШАПКА 

//получим нужные поля по коду магазина
ИмяПараметра = "КодМагазина";
Выполнить(Алгоритмы.ОпределитьПараметрыМагазина);

//общие реквизиты шапки
Выполнить(Алгоритмы.ОбработкаШапки);

//заполним склад
Если Не ИскомыйСклад.Пустая() Тогда
	Объект.Склад = ИскомыйСклад;
КонецЕсли;

//попытаемся установить вид операции
ВидДокументаОснования = ПараметрыОбъекта["ВидДокументаОснования"];
Если ВидДокументаОснования = "ОтПокупателя" Тогда
	Объект.ВидОперации = Перечисления.ВидыОперацийПриходныйОрдер.ОтПокупателя;
ИначеЕсли ВидДокументаОснования = "Перемещение" Тогда
	Объект.ВидОперации = Перечисления.ВидыОперацийПриходныйОрдер.Перемещение;
ИначеЕсли ВидДокументаОснования = "ОтПоставщика" Тогда
	Объект.ВидОперации = Перечисления.ВидыОперацийПриходныйОрдер.ОтПоставщика;
КонецЕсли;

/// ТАБЛИЧНАЯ ЧАСТЬ

//работа с табличными частями
ИмяТабличнойЧасти = "Товары";
ДокументОбъект = Объект;
Выполнить(Алгоритмы.ОбработкаТабличнойЧасти);


Выполнить(Алгоритмы.УстановитьВозможностьРедактированияОбъекта);
