Если ТипЗнч(Источник) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
	Значение = Источник.ТипЦен.ЦенаВключаетНДС;	
Иначе	
	Значение = Источник.ЦенаВключаетНДС;
КонецЕсли;
