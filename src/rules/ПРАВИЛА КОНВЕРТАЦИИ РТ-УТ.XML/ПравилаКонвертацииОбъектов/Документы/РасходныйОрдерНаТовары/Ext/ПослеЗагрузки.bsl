﻿
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

//попытаемся установить вид операции
ВидДокументаОснования = ПараметрыОбъекта["ВидДокументаОснования"];
Если ВидДокументаОснования = "Покупателю" Тогда
	Объект.ВидОперации = Перечисления.ВидыОперацийРасходныйОрдер.РасходПоНакладной;
ИначеЕсли ВидДокументаОснования = "Перемещение" Тогда
	Объект.ВидОперации = Перечисления.ВидыОперацийРасходныйОрдер.Перемещение;
ИначеЕсли ВидДокументаОснования = "Поставщику" Тогда
	Объект.ВидОперации = Перечисления.ВидыОперацийРасходныйОрдер.ВозвратПоставщику;
КонецЕсли;

//установим контрагента
ТипДокументаПередачи = ТипЗнч(Объект.ДокументПередачи);
Если ЗначениеЗаполнено(Объект.ДокументПередачи) 
   И (ТипДокументаПередачи = Тип("ДокументСсылка.ВозвратТоваровПоставщику") 
	  Или ТипДокументаПередачи = Тип("ДокументСсылка.РеализацияТоваровУслуг")) Тогда
	  
	Объект.Контрагент  = Объект.ДокументПередачи.Контрагент;
	
КонецЕсли;


//заполним склад
Если Не ИскомыйСклад.Пустая() Тогда
	Объект.Склад = ИскомыйСклад;
КонецЕсли;


/// ТАБЛИЧНАЯ ЧАСТЬ

// Обработаем стандартно табличную часть докумета
ИмяТабличнойЧасти = "Товары";
ДокументОбъект = Объект;
Выполнить(Алгоритмы.ОбработкаТабличнойЧасти);

Выполнить(Алгоритмы.УстановитьВозможностьРедактированияОбъекта);
