Если ТипЗнч(Источник.ФизЛицо) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
	ИмяПКО = "ФизическиеЛица";
ИначеЕсли ТипЗнч(Источник.ФизЛицо) = Тип("СправочникСсылка.Организации") Тогда
	ИмяПКО = "Организации";
КонецЕсли;
