﻿ТипДокументаОснования = ТипЗнч(Источник.ДокументОснование);

Если ТипДокументаОснования = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
	Значение = "ОтПокупателя";
ИначеЕсли ТипДокументаОснования = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
	Значение = "Перемещение";
ИначеЕсли ТипДокументаОснования = Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
	Значение = "ОтПоставщика";
Иначе
	Отказ = Истина;
КонецЕсли;
